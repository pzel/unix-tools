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

test_cat_cats_file
test_cat_copies_stdin

