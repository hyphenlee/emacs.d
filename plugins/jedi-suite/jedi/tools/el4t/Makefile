CARTON ?= carton
EMACS ?= emacs
EL4T_EMACS_LIST ?= ${EMACS}

EL4T_CARTON = EL4T_EMACS=${EMACS} EMACS=./emacs.sh ${CARTON}

.PHONY : test test-1 clean clean-elpa clean-elc print-deps travis-ci

test: elpa
	make test-1

# Run test against Emacs listed in ${EL4T_EMACS_LIST}.
# E.g.: make EL4T_EMACS_LIST="emacs emacs-snapshot emacs23" test-all
test-all:
	for e in ${EL4T_EMACS_LIST}; do \
		make EMACS=$$e clean test; \
	done

# Run test without checking elpa directory.
test-1:
	${EL4T_CARTON} exec ./emacs.sh -Q -batch \
		-l tests/test-el4t.el \
		-f ert-run-tests-batch-and-exit

elpa:
	${EL4T_CARTON} install

clean: clean-elpa clean-elc

clean-elpa:
	rm -rf elpa

clean-elc:
	rm -f *.elc */*.elc

print-deps:
	@echo "----------------------- Dependencies -----------------------"
	$(EMACS) --version
	@echo "------------------------------------------------------------"

travis-ci: print-deps test
