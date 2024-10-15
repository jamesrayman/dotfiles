.DELETE_ON_ERROR:

c_src := $(wildcard *.c)
cpp_src := $(wildcard *.cpp)
java_src := $(wildcard *.java)
tex_src := $(wildcard *.tex)


all: $(c_src:.c=) $(cpp_src:.cpp=) $(java_src:.java=.class) $(tex_src:.tex=.pdf)

% : %.c
	$(CC) $(CFLAGS) -o $@ $<

% : %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

%.class : %.java
	$(JAVAC) $(JAVAFLAGS) $<

%.pdf : %.tex
	latexmk -xelatex -quiet $< >/dev/null
	if [ -f $*-1.asy ]; then \
	    for x in $*-*.asy; do asy "$$x"; done; \
	    latexmk -xelatex -quiet $< >/dev/null; \
	fi
	latexmk -c >/dev/null 2>&1
	rm -f $*.pre $*.xdv
