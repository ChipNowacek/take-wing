CASK=cask
EMACS=emacs
CASKRUN=$(CASK) exec emacs --debug --script
WING=$(CASKRUN) script/build.el --

all: gen-src test publish

viewing: gen-src test tex

really-all: install all


install:
	$(CASK) install

## at the moment, this breaks where
gen-src: install
	$(WING) gen-src

test: gen-src
	lein test

PDFLATEX=pdflatex -interaction=nonstopmode

pdf:
	cd latex;$(PDFLATEX) take_wing.tex;$(PDFLATEX) take_wing.tex

html: gen-html

gen-html:
	cd latex;htlatex "take_wing" "cf,fn-in" "" "" "-interaction=nonstopmode"

fixup-html:
	$(CASKRUN) script/fixup.el

publish: pdf html fixup-html

clean:
	# There really has to be a better way than this!
	- find latex -not -name "*tex" -not -name ".gitignore" \
		-not -name "cf.cfg" -not -name "*css" -not -name "*js" \
		-not -name "Makefile" -not -name ".dir-locals.el" \
		-not -name "*org" -not -name "*sty" \
		-print -exec rm {} \;
	- rm latex/take_wing.css
	- rm latex/_region_*
	- rm latex/_buffer_*
	- rm src/take/wing/*clj

-include Makefile-local

.PHONY: test build tex
