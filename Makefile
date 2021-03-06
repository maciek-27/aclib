# makefile for aclib - auto completion library
#
# Copyright (c) 2015, Maciej Kaminski.
# Published under 2-clause BSD-style license
# 1. Redistributions of source code must retain the above copyright notice
# 2. Redistributions in binary form must reproduce the above copyright notice

# use this set of cflags for unit test execution
XCFLAGS= -g -fprofile-arcs -ftest-coverage -DDO_VALIDATE_UTF_8_OUTPUT --std=c99 --pedantic --pedantic-errors
# use this set of flags if you need clean and small executable
# XCFLAGS= -Os -DDO_VALIDATE_UTF_8_OUTPUT --std=c99 --pedantic --pedantic-errors
# use this set of flags if you need aclib to be thread safe (by default it is not)
# XCFLAGS= -Os -DTHREAD_SAFETY -DDO_VALIDATE_UTF_8_OUTPUT -std=c99 --pedantic --pedantic-errors

CFLAGS+=$(XCFLAGS)
help: .phony
	@echo "aclib - auto completion library by Maciej Kaminski. build it yourself:"
	@echo "following make targets are possible:"
	@echo " example - example program"
	@echo " library - only library"
	@echo " all - both"
	@echo " test - execute tests (requires CMake and gcov)"
	@echo " clean - remove build products"
	@echo " rebuild - clean all test"

all: aclib.a example

library: aclib.a

example: example.c aclib.a
	gcc example.c aclib.a $(CFLAGS) -o example

aclib.a: auto_complete.o special_keys.o vt100term.o
	ar -rcs aclib.a auto_complete.o special_keys.o vt100term.o

auto_complete.o: auto_complete.c
	gcc -c auto_complete.c $(CFLAGS) -o auto_complete.o

vt100term.o: vt100term.c
	gcc -c vt100term.c $(CFLAGS) -o vt100term.o

special_keys.o: special_keys.c
	gcc -c special_keys.c $(CFLAGS) -o special_keys.o

clean: .phony
	rm -f example
	rm -f *.o
	rm -f *.a
	rm -f *.gcda *.gcno *.gcov
	cd test; rm -rf CMakeCache.txt  CMakeFiles  cmake_install.cmake Makefile CTestTestfile.cmake Testing test_log gcov_log rm *.exe

test: example .phony
	gcc test/test_characters.c aclib.a -o test/test_characters.exe $(CFLAGS)
	gcc test/extra_long_completions.c aclib.a -o test/extra_long_completions.exe $(CFLAGS)
	gcc test/test_many_compl.c aclib.a -o test/test_many_compl.exe $(CFLAGS)
	rm -f test/test_log
	cd test; cmake .
	make -C test test
	@echo "Test log is contained in test/test_log"
	@./test/gcov_analysis.sh > test/gcov_log
	@echo "Coverage analysis is contained in test/gcov_log"

rebuild: .phony
	make clean
	make all
	make test

# My personal make target will likely be useless for you.
package: .phony
	cd .. ; tar -cf auto_complete.tar aclib/README aclib/*.c aclib/*.h aclib/Makefile aclib/LICENSE aclib/test/CMakeLists.txt aclib/test/template_* aclib/test/*.sh aclib/test/*.c
	scp ../auto_complete.tar s2.mydevil.net:~/domains/maciejkaminski.pl/public_html

.phony:

