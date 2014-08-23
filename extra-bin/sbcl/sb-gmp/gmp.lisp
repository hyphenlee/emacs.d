(defpackage "SB-GMP"
  (:use "COMMON-LISP" "SB-ALIEN" "SB-BIGNUM")
  ;; we need a few very internal symbols
  (:import-from "SB-BIGNUM"
                "%BIGNUM-0-OR-PLUSP" "%NORMALIZE-BIGNUM"
                "NEGATE-BIGNUM-IN-PLACE")
  (:export
   ;; bignum integer operations
   #:mpz-add
   #:mpz-sub
   #:mpz-mul
   #:mpz-mod
   #:mpz-cdiv
   #:mpz-fdiv
   #:mpz-tdiv
   #:mpz-powm
   #:mpz-pow
   #:mpz-gcd
   #:mpz-lcm
   #:mpz-sqrt
   #:mpz-probably-prime-p
   #:mpz-nextprime
   #:mpz-fac
   ;; Following three are GMP >= 5.1 only
   #:mpz-2fac
   #:mpz-mfac
   #:mpz-primorial
   #:mpz-bin
   #:mpz-fib2
   ;; random number generation
   #:make-gmp-rstate
   #:make-gmp-rstate-lc
   #:rand-seed
   #:random-bitcount
   #:random-int
   ;; ratio arithmetic
   #:mpq-add
   #:mpq-sub
   #:mpq-mul
   #:mpq-div
   ;; (un)installer functions
   ; these insert/remove the runtime patch in SBCL's runtime
   #:install-gmp-funs
   #:uninstall-gmp-funs
   ; these also load/unload the shared library and setup/clear
   ; hooks to handle core saves
   #:load-gmp
   #:unload-gmp
   ;; special variables
   #:*gmp-version*
   #:*gmp-disabled*
   ))

(in-package "SB-GMP")

(defvar *gmp-disabled* nil)

(defconstant +bignum-raw-area-offset+
  (- (* sb-vm:bignum-digits-offset sb-vm:n-word-bytes)
     sb-vm:other-pointer-lowtag))

(declaim (inline bignum-data-sap))
(defun bignum-data-sap (x)
  (declare (type bignum x))
  (sb-sys:sap+ (sb-sys:int-sap (sb-kernel:get-lisp-obj-address x))
               +bignum-raw-area-offset+))

(defun %load-gmp ()
  (handler-case
      (load-shared-object #-(or win32 darwin) "libgmp.so"
                          #+darwin "libgmp.dylib"
                          #+win32 "libgmp-10.dll"
                          :dont-save t)
    (error (e)
      (warn "GMP not loaded (~a)" e)
      (return-from %load-gmp nil)))
  t)

(defvar *gmp-features* nil)
(defvar *gmp-version* nil)

;; We load only the library right now to avoid undefined alien
;; style warnings
(%load-gmp)


;;; types and initialization
(define-alien-type nil
    (struct gmpint
            (mp_alloc int)
            (mp_size int)
            (mp_d (* unsigned-long))))

;; Section 3.6 "Memory Management" of the GMP manual states: "mpz_t
;; and mpq_t variables never reduce their allocated space. Normally
;; this is the best policy, since it avoids frequent
;; reallocation. Applications that need to return memory to the heap
;; at some particular point can use mpz_realloc2, or clear variables
;; no longer needed."
;;
;; We can therefore allocate a bignum of sufficiant size and use the
;; space for GMP computations without the need for memory transfer
;; from C to Lisp space.
(declaim (inline z-to-bignum z-to-bignum-neg))

(defun z-to-bignum (b count)
  "Convert GMP integer in the buffer of a pre-allocated bignum."
  (declare (optimize (speed 3) (space 3) (safety 0))
           (type bignum-type b)
           (type bignum-index count))
  (if (zerop count)
      0
      (the unsigned-byte (%normalize-bignum b count))))

(defun z-to-bignum-neg (b count)
  "Convert to twos complement int the buffer of a pre-allocated
bignum."
  (declare (optimize (speed 3) (space 3) (safety 0))
           (type bignum-type b)
           (type bignum-index count))
  (negate-bignum-in-place b)
  (the (integer * 0) (%normalize-bignum b count)))

;;; conversion functions that also copy from GMP to SBCL bignum space
(declaim (inline gmp-z-to-bignum gmp-z-to-bignum-neg))

(defun gmp-z-to-bignum (z b count)
  "Convert and copy a positive GMP integer into the buffer of a
pre-allocated bignum. The allocated bignum-length must be (1+ COUNT)."
  (declare (optimize (speed 3) (space 3) (safety 0))
           (type (alien (* unsigned-long)) z)
           (type bignum-type b)
           (type bignum-index count))
  (dotimes (i count (%normalize-bignum b (1+ count)))
    (%bignum-set b i (deref z i))))

(defun gmp-z-to-bignum-neg (z b count)
  "Convert to twos complement and copy a negative GMP integer into the
buffer of a pre-allocated bignum. The allocated bignum-length must
be (1+ COUNT)."
  (declare (optimize (speed 3) (space 3) (safety 0))
           (type (alien (* unsigned-long)) z)
           (type bignum-type b)
           (type bignum-index count))
  (let ((carry 0)
        (add 1))
    (declare (type (mod 2) carry add))
    (dotimes (i count (%normalize-bignum b (1+ count)))
      (multiple-value-bind (value carry-tmp)
          (%add-with-carry
           (%lognot (deref z i)) add carry)
        (%bignum-set b i value)
        (setf carry carry-tmp
              add 0)))))

(declaim (inline blength bassert)
         (ftype (function (integer) (values bignum-index &optional)) blength)
         (ftype (function (integer) (values bignum &optional)) bassert))

(defun blength (a)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (etypecase a
    (fixnum 1)
    (t (%bignum-length a))))

(defun bassert (a)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (etypecase a
    (fixnum (make-small-bignum a))
    (t a)))

;;;; rationals
(define-alien-type nil
    (struct gmprat
            (mp_num (struct gmpint))
            (mp_den (struct gmpint))))

;;; memory initialization functions to support non-alloced results
;;; since an upper bound cannot always correctly predetermined
;;; (e.g. the memory required for the fib function exceed the number
;;; of limbs that are be determined through the infamous Phi-relation
;;; resulting in a memory access error.

;; use these for non-prealloced bignum values, but only when
;; ultimately necessary since copying back into bignum space a the end
;; of the operation is about three times slower than the shared buffer
;; approach.
(declaim (inline __gmpz_init __gmpz_clear))
(define-alien-routine __gmpz_init void
  (x (* (struct gmpint))))

(define-alien-routine __gmpz_clear void
  (x (* (struct gmpint))))


;;; integer interface functions
(defmacro define-twoarg-mpz-funs (funs)
  (loop for i in funs collect `(define-alien-routine ,i void
                                 (r (* (struct gmpint)))
                                 (a (* (struct gmpint))))
          into defines
        finally (return `(progn
                           (declaim (inline ,@funs))
                           ,@defines))))

(defmacro define-threearg-mpz-funs (funs)
  (loop for i in funs collect `(define-alien-routine ,i void
                                 (r (* (struct gmpint)))
                                 (a (* (struct gmpint)))
                                 (b (* (struct gmpint))))
          into defines
        finally (return `(progn
                           (declaim (inline ,@funs))
                           ,@defines))))

(defmacro define-fourarg-mpz-funs (funs)
  (loop for i in funs collect `(define-alien-routine ,i void
                                 (r (* (struct gmpint)))
                                 (a (* (struct gmpint)))
                                 (b (* (struct gmpint)))
                                 (c (* (struct gmpint))))
          into defines
        finally (return `(progn
                           (declaim (inline ,@funs))
                           ,@defines))))


(define-twoarg-mpz-funs (__gmpz_sqrt
                         __gmpz_nextprime))

(define-threearg-mpz-funs (__gmpz_add
                           __gmpz_sub
                           __gmpz_mul
                           __gmpz_mod
                           __gmpz_gcd
                           __gmpz_lcm))

(define-fourarg-mpz-funs (__gmpz_cdiv_qr
                          __gmpz_fdiv_qr
                          __gmpz_tdiv_qr
                          __gmpz_powm))

(declaim (inline __gmpz_pow_ui
                 __gmpz_probab_prime_p
                 __gmpz_fac_ui
                 __gmpz_2fac_ui
                 __gmpz_mfac_uiui
                 __gmpz_primorial_ui
                 __gmpz_bin_ui
                 __gmpz_fib2_ui))

(define-alien-routine __gmpz_pow_ui void
  (r (* (struct gmpint)))
  (b (* (struct gmpint)))
  (e unsigned-long))

(define-alien-routine __gmpz_probab_prime_p int
  (n (* (struct gmpint)))
  (reps int))

(define-alien-routine __gmpz_fac_ui void
  (r (* (struct gmpint)))
  (a unsigned-long))

(define-alien-routine __gmpz_2fac_ui void
  (r (* (struct gmpint)))
  (a unsigned-long))

(define-alien-routine __gmpz_mfac_uiui void
  (r (* (struct gmpint)))
  (n unsigned-long)
  (m unsigned-long))

(define-alien-routine __gmpz_primorial_ui void
  (r (* (struct gmpint)))
  (n unsigned-long))

(define-alien-routine __gmpz_bin_ui void
  (r (* (struct gmpint)))
  (n (* (struct gmpint)))
  (k unsigned-long))

(define-alien-routine __gmpz_fib2_ui void
  (r (* (struct gmpint)))
  (a (* (struct gmpint)))
  (b unsigned-long))


;; ratio functions
(defmacro define-threearg-mpq-funs (funs)
  (loop for i in funs collect `(define-alien-routine ,i void
                                 (r (* (struct gmprat)))
                                 (a (* (struct gmprat)))
                                 (b (* (struct gmprat))))
          into defines
        finally (return `(progn
                           (declaim (inline ,@funs))
                           ,@defines))))

(define-threearg-mpq-funs (__gmpq_add
                           __gmpq_sub
                           __gmpq_mul
                           __gmpq_div))


;;;; SBCL interface

;;; utility macros for GMP mpz variable and result declaration and
;;; incarnation of associated SBCL bignums
(defmacro with-mpz-results (pairs &body body)
  (loop for (gres size) in pairs
        for res = (gensym "RESULT")
        collect `(,gres (struct gmpint)) into declares
        collect `(,res (%allocate-bignum ,size))
          into resinits
        collect `(setf (slot ,gres 'mp_alloc) (%bignum-length ,res)
                       (slot ,gres 'mp_size) 0
                       (slot ,gres 'mp_d) (bignum-data-sap ,res))
          into inits
        collect `(if (minusp (slot ,gres 'mp_size)) ; check for negative result
                     (z-to-bignum-neg ,res ,size)
                     (z-to-bignum ,res ,size))
          into normlimbs
        collect res into results
        finally (return
                  `(let ,resinits
                     (sb-sys:with-pinned-objects ,results
                       (with-alien ,declares
                         ,@inits
                         ,@body
                         (values ,@normlimbs)))))))

(defmacro with-mpz-vars (pairs &body body)
  (loop for (a ga) in pairs
        for length = (gensym "LENGTH")
        for plusp = (gensym "PLUSP")
        for barg = (gensym "BARG")
        for arg = (gensym "ARG")
        collect `(,ga (struct gmpint)) into declares
        collect `(,barg (bassert ,a)) into gmpinits
        collect `(,plusp (%bignum-0-or-plusp ,barg (%bignum-length ,barg))) into gmpinits
        collect `(,arg (if ,plusp ,barg (negate-bignum ,barg nil))) into gmpinits
        collect `(,length (%bignum-length ,arg)) into gmpinits
        collect arg into vars
        collect `(setf (slot ,ga 'mp_alloc) ,length
                       (slot ,ga 'mp_size)
                       (progn ;; handle twos complements/ulong limbs mismatch
                         (when (zerop (%bignum-ref ,arg (1- ,length)))
                           (decf ,length))
                         (if ,plusp ,length (- ,length)))
                       (slot ,ga 'mp_d) (bignum-data-sap ,arg))
          into gmpvarssetup
        finally (return
                  `(with-alien ,declares
                     (let* ,gmpinits
                       (sb-sys:with-pinned-objects ,vars
                         ,@gmpvarssetup
                         ,@body))))))

(defmacro with-gmp-mpz-results (resultvars &body body)
  (loop for gres in resultvars
        for res = (gensym "RESULT")
        for size = (gensym "SIZE")
        collect size into sizes
        collect `(,gres (struct gmpint)) into declares
        collect `(__gmpz_init (addr ,gres)) into inits
        collect `(,size (abs (slot ,gres 'mp_size)))
          into resinits
        collect `(,res (%allocate-bignum (1+ ,size)))
          into resinits
        collect `(setf ,res (if (minusp (slot ,gres 'mp_size)) ; check for negative result
                                (gmp-z-to-bignum-neg (slot ,gres 'mp_d) ,res ,size)
                                (gmp-z-to-bignum (slot ,gres 'mp_d) ,res ,size)))
          into copylimbs
        collect `(__gmpz_clear (addr ,gres)) into clears
        collect res into results
        finally (return
                  `(with-alien ,declares
                     ,@inits
                     ,@body
                     (let* ,resinits
                       (declare (type bignum-index ,@sizes))
                       ;; copy GMP limbs into result bignum
                       (sb-sys:with-pinned-objects ,results
                         ,@copylimbs)
                       ,@clears
                       (values ,@results))))))

;;; function definition and foreign function relationships
(defmacro defgmpfun (name args &body body)
  `(progn
     (declaim (sb-ext:maybe-inline ,name))
     (defun ,name ,args
       (declare (optimize (speed 3) (space 3) (safety 0))
                (type integer ,@args))
       ,@body)))


;; SBCL/GMP functions
(defgmpfun mpz-add (a b)
  (with-mpz-results ((result (1+ (max (blength a)
                                      (blength b)))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_add (addr result) (addr ga) (addr gb)))))

(defgmpfun mpz-sub (a b)
  (with-mpz-results ((result (1+ (max (blength a)
                                      (blength b)))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_sub (addr result) (addr ga) (addr gb)))))

(defgmpfun mpz-mul (a b)
  (with-mpz-results ((result (+ (blength a)
                                (blength b))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_mul (addr result) (addr ga) (addr gb)))))

(defgmpfun mpz-mod (a b)
  (with-mpz-results ((result (1+ (max (blength a)
                                      (blength b)))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_mod (addr result) (addr ga) (addr gb))
      (when (and (minusp (slot gb 'mp_size))
                 (/= 0 (slot result 'mp_size)))
        (__gmpz_add (addr result) (addr result) (addr gb))))))

(defgmpfun mpz-cdiv (n d)
  (let ((size (1+ (max (blength n)
                       (blength d)))))
    (with-mpz-results ((quot size)
                       (rem size))
      (with-mpz-vars ((n gn) (d gd))
        (__gmpz_cdiv_qr (addr quot) (addr rem) (addr gn) (addr gd))))))

(defgmpfun mpz-fdiv (n d)
  (let ((size (1+ (max (blength n)
                       (blength d)))))
    (with-mpz-results ((quot size)
                       (rem size))
      (with-mpz-vars ((n gn) (d gd))
        (__gmpz_fdiv_qr (addr quot) (addr rem) (addr gn) (addr gd))))))

(defgmpfun mpz-tdiv (n d)
  (let ((size (max (blength n)
                   (blength d))))
    (with-mpz-results ((quot size)
                       (rem size))
      (with-mpz-vars ((n gn) (d gd))
        (__gmpz_tdiv_qr (addr quot) (addr rem) (addr gn) (addr gd))))))

(defun mpz-pow (base exp)
  (with-gmp-mpz-results (rop)
    (with-mpz-vars ((base gbase))
      (__gmpz_pow_ui (addr rop) (addr gbase) exp))))

(defgmpfun mpz-powm (base exp mod)
  (with-mpz-results ((rop (1+ (blength mod))))
    (with-mpz-vars ((base gbase) (exp gexp) (mod gmod))
      (__gmpz_powm (addr rop) (addr gbase) (addr gexp) (addr gmod)))))

(defgmpfun mpz-gcd (a b)
  (with-mpz-results ((result (min (blength a)
                                  (blength b))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_gcd (addr result) (addr ga) (addr gb)))))

(defgmpfun mpz-lcm (a b)
  (with-mpz-results ((result (+ (blength a)
                                (blength b))))
    (with-mpz-vars ((a ga) (b gb))
      (__gmpz_lcm (addr result) (addr ga) (addr gb)))))

(defgmpfun mpz-sqrt (a)
  (with-mpz-results ((result (1+ (ceiling (blength a) 2))))
    (with-mpz-vars ((a ga))
      (__gmpz_sqrt (addr result) (addr ga)))))


;;; Functions that use GMP-side allocated integers and copy the result
;;; into a SBCL bignum at the end of the computation when the required
;;; bignum length is known.
(defun mpz-probably-prime-p (n &optional (reps 25))
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type reps fixnum)
  (with-mpz-vars ((n gn))
    (__gmpz_probab_prime_p (addr gn) reps)))

(defun mpz-nextprime (a)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (with-gmp-mpz-results (prime)
    (with-mpz-vars ((a ga))
      (__gmpz_nextprime (addr prime) (addr ga)))))

(defun mpz-fac (n)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type n (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (fac)
    (__gmpz_fac_ui (addr fac) n)))

(defun %mpz-2fac (n)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type n (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (fac)
    (__gmpz_2fac_ui (addr fac) n)))

(defun %mpz-mfac (n m)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type n (unsigned-byte #.sb-vm:n-word-bits))
  (check-type m (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (fac)
    (__gmpz_mfac_uiui (addr fac) n m)))

(defun %mpz-primorial (n)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type n (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (r)
    (__gmpz_primorial_ui (addr r) n)))

(defun setup-5.1-stubs ()
  (macrolet ((stubify (name implementation &rest arguments)
               `(setf (fdefinition ',name)
                      (if (member :sb-gmp-5.1 *gmp-features*)
                          (fdefinition ',implementation)
                          (lambda ,arguments
                            (declare (ignore ,@arguments))
                            (error "~S is only available in GMP >= 5.1"
                                   ',name))))))
    (stubify mpz-2fac %mpz-2fac n)
    (stubify mpz-mfac %mpz-mfac n m)
    (stubify mpz-primorial %mpz-primorial n)))

(defun mpz-bin (n k)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type k (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (r)
    (with-mpz-vars ((n gn))
      (__gmpz_bin_ui (addr r) (addr gn) k))))

(defun mpz-fib2 (n)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  ;; (let ((size (1+ (ceiling (* n (log 1.618034 2)) 64)))))
  ;; fibonacci number magnitude in bits is assymptotic to n(log_2 phi)
  ;; This is correct for the result but appears not to be enough for GMP
  ;; during computation (memory access error), so use GMP-side allocation.
  (check-type n (unsigned-byte #.sb-vm:n-word-bits))
  (with-gmp-mpz-results (fibn fibn-1)
    (__gmpz_fib2_ui (addr fibn) (addr fibn-1) n)))


;;;; Random bignum (mpz) generation

;; we do not actually use the gestalt of the struct but need its size
;; for allocation purposes
(define-alien-type nil
    (struct gmprandstate
            (mp_seed (struct gmpint))
            (mp_alg int)
            (mp_algdata (* t))))

(declaim (inline __gmp_randinit_mt
                 __gmp_randinit_lc_2exp
                 __gmp_randseed
                 __gmp_randseed_ui
                 __gmpz_urandomb
                 __gmpz_urandomm))

(define-alien-routine __gmp_randinit_mt void
  (s (* (struct gmprandstate))))

(define-alien-routine __gmp_randinit_lc_2exp void
  (s (* (struct gmprandstate)))
  (a (* (struct gmpint)))
  (c unsigned-long)
  (exp unsigned-long))

(define-alien-routine __gmp_randseed void
  (s (* (struct gmprandstate)))
  (sd (* (struct gmpint))))

(define-alien-routine __gmp_randseed_ui void
  (s (* (struct gmprandstate)))
  (sd unsigned-long))

(define-alien-routine __gmpz_urandomb void
  (r (* (struct gmpint)))
  (s (* (struct gmprandstate)))
  (bcnt unsigned-long))

(define-alien-routine __gmpz_urandomm void
  (r (* (struct gmpint)))
  (s (* (struct gmprandstate)))
  (n (* (struct gmpint))))

(defstruct (gmp-rstate (:constructor %make-gmp-rstate))
  (ref (make-alien (struct gmprandstate))
   :type (alien (* (struct gmprandstate))) :read-only t))

(defun make-gmp-rstate ()
  "Instantiate a state for the GMP Mersenne-Twister random number generator."
  (declare (optimize (speed 3) (space 3)))
  (let* ((state (%make-gmp-rstate))
         (ref (gmp-rstate-ref state)))
    (__gmp_randinit_mt ref)
    (sb-ext:finalize state (lambda () (free-alien ref)))
    state))

(defun make-gmp-rstate-lc (a c m2exp)
  "Instantiate a state for the GMP linear congruential random number generator."
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type c (unsigned-byte #.sb-vm:n-word-bits))
  (check-type m2exp (unsigned-byte #.sb-vm:n-word-bits))
  (let* ((state (%make-gmp-rstate))
         (ref (gmp-rstate-ref state)))
    (with-mpz-vars ((a ga))
      (__gmp_randinit_lc_2exp ref (addr ga) c m2exp))
    (sb-ext:finalize state (lambda () (free-alien ref)))
    state))

(defun rand-seed (state seed)
  "Initialize a random STATE with SEED."
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type state gmp-rstate)
  (let ((ref (gmp-rstate-ref state)))
    (cond
      ((typep seed '(unsigned-byte #.sb-vm:n-word-bits))
       (__gmp_randseed_ui ref seed))
      ((typep seed '(integer 0 *))
       (with-mpz-vars ((seed gseed))
         (__gmp_randseed ref (addr gseed))))
      (t
       (error "SEED must be a positive integer")))))

(defun random-bitcount (state bitcount)
  "Return a random integer in the range 0..(2^bitcount - 1)."
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type state gmp-rstate)
  (check-type bitcount (unsigned-byte #.sb-vm:n-word-bits))
  (let ((ref (gmp-rstate-ref state)))
    (with-mpz-results ((result (+ (ceiling bitcount sb-vm:n-word-bits) 2)))
      (__gmpz_urandomb (addr result) ref bitcount))))

(defun random-int (state boundary)
  "Return a random integer in the range 0..(boundary - 1)."
  (declare (optimize (speed 3) (space 3) (safety 0)))
  (check-type state gmp-rstate)
  (let ((b (bassert boundary))
        (ref (gmp-rstate-ref state)))
    (with-mpz-results ((result (1+ (%bignum-length b))))
      (with-mpz-vars ((b gb))
        (__gmpz_urandomm (addr result) ref (addr gb))))))


;;; Rational functions
(declaim (inline %lsize))
(defun %lsize (minusp n)
  (declare (optimize (speed 3) (space 3) (safety 0)))
  "n must be a (potentially denormalized) bignum"
  (let ((length (%bignum-length n)))
    (when (zerop (%bignum-ref n (1- length)))
      (decf length))
    (if minusp (- length) length)))

(defmacro defmpqfun (name gmpfun)
  `(progn
     (declaim (sb-ext:maybe-inline ,name))
     (defun ,name (a b)
       (declare (optimize (speed 3) (space 3) (safety 0)))
       (let ((size (+ (max (blength (numerator a))
                           (blength (denominator a)))
                      (max (blength (numerator b))
                           (blength (denominator b)))
                      3)))
         (with-alien ((r (struct gmprat)))
           (let ((num (%allocate-bignum size))
                 (den (%allocate-bignum size)))
             (sb-sys:with-pinned-objects (num den)
               (setf (slot (slot r 'mp_num) 'mp_size) 0
                     (slot (slot r 'mp_num) 'mp_alloc) size
                     (slot (slot r 'mp_num) 'mp_d) (bignum-data-sap num))
               (setf (slot (slot r 'mp_den) 'mp_size) 0
                     (slot (slot r 'mp_den) 'mp_alloc) size
                     (slot (slot r 'mp_den) 'mp_d) (bignum-data-sap den))
               (let* ((an (bassert (numerator a)))
                      (ad (bassert (denominator a)))
                      (asign (not (%bignum-0-or-plusp an (%bignum-length an))))
                      (bn (bassert (numerator b)))
                      (bd (bassert (denominator b)))
                      (bsign (not (%bignum-0-or-plusp bn (%bignum-length bn)))))
                 (when asign
                   (setf an (negate-bignum an nil)))
                 (when bsign
                   (setf bn (negate-bignum bn nil)))
                 (let* ((anlen (%lsize asign an))
                        (adlen (%lsize NIL ad))
                        (bnlen (%lsize bsign bn))
                        (bdlen (%lsize NIL bd)))
                   (with-alien ((arga (struct gmprat))
                                (argb (struct gmprat)))
                     (sb-sys:with-pinned-objects (an ad bn bd)
                       (setf (slot (slot arga 'mp_num) 'mp_size) anlen
                             (slot (slot arga 'mp_num) 'mp_alloc) (abs anlen)
                             (slot (slot arga 'mp_num) 'mp_d)
                             (bignum-data-sap an))
                       (setf (slot (slot arga 'mp_den) 'mp_size) adlen
                             (slot (slot arga 'mp_den) 'mp_alloc) (abs adlen)
                             (slot (slot arga 'mp_den) 'mp_d)
                             (bignum-data-sap ad))
                       (setf (slot (slot argb 'mp_num) 'mp_size) bnlen
                             (slot (slot argb 'mp_num) 'mp_alloc) (abs bnlen)
                             (slot (slot argb 'mp_num) 'mp_d)
                             (bignum-data-sap bn))
                       (setf (slot (slot argb 'mp_den) 'mp_size) bdlen
                             (slot (slot argb 'mp_den) 'mp_alloc) (abs bdlen)
                             (slot (slot argb 'mp_den) 'mp_d)
                             (bignum-data-sap bd))
                       (,gmpfun (addr r) (addr arga) (addr argb)))))
                 (locally (declare (optimize (speed 1)))
                   (sb-kernel::build-ratio (if (minusp (slot (slot r 'mp_num) 'mp_size))
                                               (z-to-bignum-neg num size)
                                               (z-to-bignum num size))
                                           (z-to-bignum den size)))))))))))

(defmpqfun mpq-add __gmpq_add)
(defmpqfun mpq-sub __gmpq_sub)
(defmpqfun mpq-mul __gmpq_mul)
(defmpqfun mpq-div __gmpq_div)


;;;; SBCL interface and integration installation
(macrolet ((def (name original)
             (let ((special (intern (format nil "*~A-FUNCTION*" name))))
               `(progn
                  (declaim (type function ,special)
                           (inline ,name))
                  (defvar ,special (symbol-function ',original))
                  (defun ,name (&rest args)
                    (apply (load-time-value ,special t) args))))))
  (def orig-mul multiply-bignums)
  (def orig-truncate bignum-truncate)
  (def orig-gcd bignum-gcd)
  (def orig-lcm sb-kernel:two-arg-lcm)
  (def orig-isqrt isqrt)
  (def orig-two-arg-+ sb-kernel:two-arg-+)
  (def orig-two-arg-- sb-kernel:two-arg--)
  (def orig-two-arg-* sb-kernel:two-arg-*)
  (def orig-two-arg-/ sb-kernel:two-arg-/))

;;; integers
(defun gmp-mul (a b)
  (declare (optimize (speed 3) (space 3))
           (type bignum-type a b)
           (inline mpz-mul))
  (if (or (< (min (%bignum-length a)
                  (%bignum-length b))
             6)
          *gmp-disabled*)
      (orig-mul a b)
      (mpz-mul a b)))

(defun gmp-truncate (a b)
  (declare (optimize (speed 3) (space 3))
           (type bignum-type a b)
           (inline mpz-tdiv))
  (if (or (< (min (%bignum-length a)
                  (%bignum-length b))
             3)
          *gmp-disabled*)
      (orig-truncate a b)
      (mpz-tdiv a b)))

(defun gmp-lcm (a b)
  (declare (optimize (speed 3) (space 3))
           (type integer a b)
           (inline mpz-lcm))
  (if (or (and (typep a 'fixnum)
               (typep b 'fixnum))
          *gmp-disabled*)
      (orig-lcm a b)
      (mpz-lcm a b)))

(defun gmp-isqrt (n)
  (declare (optimize (speed 3) (space 3))
           (type unsigned-byte n)
           (inline mpz-sqrt))
  (if (or (typep n 'fixnum)
          *gmp-disabled*)
      (orig-isqrt n)
      (mpz-sqrt n)))

;;; rationals
(defun gmp-two-arg-+ (x y)
  (declare (optimize (speed 3) (space 3))
           (inline mpq-add))
  (if (and (or (typep x 'ratio)
               (typep y 'ratio))
           (rationalp y)
           (rationalp x)
           (not *gmp-disabled*))
      (mpq-add x y)
      (orig-two-arg-+ x y)))

(defun gmp-two-arg-- (x y)
  (declare (optimize (speed 3) (space 3))
           (inline mpq-sub))
  (if (and (or (typep x 'ratio)
               (typep y 'ratio))
           (rationalp y)
           (rationalp x)
           (not *gmp-disabled*))
      (mpq-sub x y)
      (orig-two-arg-- x y)))

(defun gmp-two-arg-* (x y)
  (declare (optimize (speed 3) (space 3))
           (inline mpq-mul))
  (if (and (or (typep x 'ratio)
               (typep y 'ratio))
           (rationalp y)
           (rationalp x)
           (not *gmp-disabled*))
      (mpq-mul x y)
      (orig-two-arg-* x y)))

(defun gmp-two-arg-/ (x y)
  (declare (optimize (speed 3) (space 3))
           (inline mpq-div))
  (if (and (rationalp x)
           (rationalp y)
           (not (eql y 0))
           (not *gmp-disabled*))
      (mpq-div x y)
      (orig-two-arg-/ x y)))

;;; installation
(defmacro with-package-locks-ignored (&body body)
  `(handler-bind ((sb-ext:package-lock-violation
                    (lambda (condition)
                      (declare (ignore condition))
                      (invoke-restart :ignore-all))))
     ,@body))

(defun install-gmp-funs ()
  (with-package-locks-ignored
      (macrolet ((def (destination source)
                   `(setf (fdefinition ',destination)
                          (fdefinition ',source))))
        (def multiply-bignums gmp-mul)
        (def bignum-truncate gmp-truncate)
        (def bignum-gcd mpz-gcd)
        (def sb-kernel:two-arg-lcm gmp-lcm)
        (def sb-kernel:two-arg-+ gmp-two-arg-+)
        (def sb-kernel:two-arg-- gmp-two-arg--)
        (def sb-kernel:two-arg-* gmp-two-arg-*)
        (def sb-kernel:two-arg-/ gmp-two-arg-/)
        (def isqrt gmp-isqrt)))
  (values))

(defun uninstall-gmp-funs ()
  (with-package-locks-ignored
      (macrolet ((def (destination source)
                   `(setf (fdefinition ',destination)
                          ,(intern (format nil "*~A-FUNCTION*" source)))))
        (def multiply-bignums orig-mul)
        (def bignum-truncate orig-truncate)
        (def bignum-gcd orig-gcd)
        (def sb-kernel:two-arg-lcm orig-lcm)
        (def sb-kernel:two-arg-+ orig-two-arg-+)
        (def sb-kernel:two-arg-- orig-two-arg--)
        (def sb-kernel:two-arg-* orig-two-arg-*)
        (def sb-kernel:two-arg-/ orig-two-arg-/)
        (def isqrt orig-isqrt)))
  (values))

(defun load-gmp (&key (persistently t))
  (setf *gmp-features* nil
        *gmp-version* nil
        *features* (set-difference *features* '(:sb-gmp :sb-gmp-5.0 :sb-gmp-5.1)))
  (when persistently
    (pushnew 'load-gmp sb-ext:*init-hooks*)
    (pushnew 'uninstall-gmp-funs sb-ext:*save-hooks*))
  (let ((success (%load-gmp)))
    (when success
      (setf *gmp-version* (extern-alien "__gmp_version" c-string)))
    (cond ((null *gmp-version*))
          ((string<= *gmp-version* "5.")
           (warn "SB-GMP requires at least GMP version 5.0")
           (setf success nil))
          (t
           (pushnew :sb-gmp *gmp-features*)
           (pushnew :sb-gmp-5.0 *gmp-features*)
           (when (string>= *gmp-version* "5.1")
             (pushnew :sb-gmp-5.1 *gmp-features*))
           (setf *features* (union *features* *gmp-features*))))
    (if success
        (install-gmp-funs)
        (uninstall-gmp-funs))
    (setup-5.1-stubs)
    success))

(defun unload-gmp ()
  (setf sb-ext:*init-hooks* (remove 'load-gmp sb-ext:*init-hooks*))
  (uninstall-gmp-funs)
  (setf sb-ext:*save-hooks* (remove 'uninstall-gmp-funs sb-ext:*save-hooks*))
  (values))

(load-gmp)
