#!/bin/bash
set -e

assert_equal() {
    if [ "$1" = "$2" ];
    then true;
    else
	echo -e "FAILED:\nLEFT:  ${1}\nRIGHT: ${2}"
	exit 1
    fi
}

test_cat_cats_file() {
    unix=$(cat ./README.md)
    exs=$(./cat.exs ./README.md)
    assert_equal "$unix" "$exs"
}

test_cat_copies_stdin() {
    unix=$(echo 'useless use of' | cat)
    exs=$(echo 'useless use of' | ./cat.exs)
    assert_equal "$unix" "$exs"
}

test_grep_finds_word_in_file() {
    unix=$(grep unix README.md)
    exs=$(./grep.exs unix README.md)
    assert_equal "$unix" "$exs"
}

test_grep_finds_word_in_stdin() {
    unix=$(echo -e "hello\nunix\ntools" | grep unix)
    exs=$(echo -e "hello\nunix\ntools" | ./grep.exs unix)
    assert_equal "$unix" "$exs"
}


test_cat_cats_file
test_cat_copies_stdin
test_grep_finds_word_in_file
test_grep_finds_word_in_stdin
