#!/bin/bash

assert_equal() {
    if [ "$1" = "$2" ] && [ -n "$1" ];
    then true;
    else
        echo -e "FAILED ON LINE ${3}\nLEFT:  ${1}\nRIGHT: ${2}"
        exit 1
    fi
}

test_cat_cats_file() {
    unix=$(cat ./README.md)
    exs=$(./cat.exs ./README.md)
    assert_equal "$unix" "$exs" $LINENO
}

test_cat_copies_stdin() {
    unix=$(echo 'useless use of' | cat)
    exs=$(echo 'useless use of' | ./cat.exs)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_file() {
    unix=$(grep unix README.md)
    exs=$(./grep.exs unix README.md)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_stdin() {
    unix=$(echo -e "hello\nunix\ntools" | grep unix)
    exs=$(echo -e "hello\nunix\ntools" | ./grep.exs unix)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_multiple_files() {
    unix=$(grep unix *)
    exs=$(./grep.exs unix *)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_match_in_file() {
    unix=$(grep 'u..x' README.md)
    exs=$(./grep.exs 'u..x' README.md)
    assert_equal "$unix" "$exs" $LINENO
}

test_curl_works_on_http_site() {
    unix=$(curl http://localhost:631 2>/dev/null)
    exs=$(./curl.exs http://localhost:631 2>/dev/null)
    assert_equal "$unix" "$exs" $LINENO
}

test_cat_cats_file
test_cat_copies_stdin
test_grep_finds_word_in_file
test_grep_finds_word_in_stdin
test_grep_finds_word_in_multiple_files
test_grep_finds_match_in_file
test_curl_works_on_http_site
echo "ALL TESTS PASSED"
