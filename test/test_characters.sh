#!/bin/bash
# Test script aclib - auto completion library
# This is part of automated (unit) test suite for library
#
# Purpose of this test processing of special characters from xterm
#
# Copyright (c) 2015, Maciej Kaminski.
# Published under 2-clause BSD-style license
# 1. Redistributions of source code must retain the above copyright notice
# 2. Redistributions in binary form must reproduce the above copyright notice

OUTPUT=`echo -e "$1" | ./test_characters.exe `

test "$2" = "$OUTPUT"

RESULT=$?
(
    echo "Editing test"
    echo "Test input:  $1"
    echo "Test output: $OUTPUT"
    echo "Expected:    $2"
    echo "Test result: $RESULT"
) >> test_log
exit $RESULT
