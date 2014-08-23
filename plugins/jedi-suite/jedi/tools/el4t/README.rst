====================================
 EL4T -- Emacs Launcher for Testing
====================================

* `Repository <https://github.com/tkf/el4t>`_ (at GitHub)
* `Issue tracker <https://github.com/tkf/el4t/issues>`_ (at GitHub)
* `Travis CI <https://travis-ci.org/#!/tkf/el4t>`_ |build-status|


Current best practice for automated test in Emacs Lisp project is to
use ERT, which is included in Emacs 24.  However, to test with older
Emacs, you need to load ERT manually which is very cumbersome to do.
Same goes for dependency resolution.  You need to load package.el
manually for Emacs older than 24 to install packages from
ELPA-compatible repositories.

EL4T is a simple proxy shell script to load ERT and package.el even
for older Emacs versions.

All you need to do is to set ``EL4T_EMACS`` to the Emacs executable
you want to use and call ``emacs.sh`` instead of that Emacs
executable.  For example, to run ERT test with Emacs 23, do some thing
like this::

  EL4T_EMACS=emacs23 PATH/TO/emacs.sh -Q --batch -l TEST-RUNNER.el


It is useful to use this script with Carton_::

  export EMACS=PATH/TO/emacs.sh
  export EL4T_EMACS=emacs23        # real Emacs executable to use
  carton install                   # use package.el to install dependencies
  carton exec $EMACS -Q --batch -l TEST-RUNNER.el

.. _Carton: https://github.com/rejeep/carton


License
-------

EL4T, including package.el and ERT distributed with EL4T, is free
software under GPL v3.  See COPYING file for details.


.. |build-status|
   image:: https://secure.travis-ci.org/tkf/el4t.png
           ?branch=master
   :target: http://travis-ci.org/tkf/el4t
   :alt: Build Status
