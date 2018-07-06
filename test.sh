#!/bin/bash

assert_equal() {
    if [ "$1" = "$2" ] && [ -n "$1" ];
    then true;
    else
        echo -e "FAILED ON LINE ${3}\nLEFT:\n${1}\nRIGHT:\n${2}"
        exit 1
    fi
}

test_true_returns_true() {
    unix=$(true && echo "$?")
    exs=$(./true.exs && echo "$?")
    assert_equal "$unix" "$exs" $LINENO
}

test_echo_echoes_one_arg() {
    unix=$(echo hello)
    exs=$(./echo.exs hello)
    assert_equal "$unix" "$exs" $LINENO
}

test_echo_echoes_many_args() {
    unix=$(echo hello world)
    exs=$(./echo.exs hello world)
    assert_equal "$unix" "$exs" $LINENO
}

test_echo_preserves_quotes() {
    unix=$(echo hello "'x'" world)
    exs=$(./echo.exs hello "'x'" world)
    assert_equal "$unix" "$exs" $LINENO
}

test_yes_repeats_y() {
    unix=$(yes | head -n10)
    exs=$(./yes.exs  2>/dev/null | head -n10)
    assert_equal "$unix" "$exs" $LINENO
}

test_yes_repeats_first_arg() {
    unix=$(yes no | head -n10)
    exs=$(./yes.exs no  2>/dev/null | head -n10)
    assert_equal "$unix" "$exs" $LINENO
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

test_wc_counts_dev_null() {
    unix=$(wc /dev/null | tr -s ' ')
    exs=$(./wc.exs /dev/null | tr -s ' ')
    assert_equal "$unix" "$exs" $LINENO
}

test_wc_counts_in_file() {
    unix=$(wc README.md | tr -s ' ')
    exs=$(./wc.exs README.md | tr -s ' ')
    assert_equal "$unix" "$exs" $LINENO
}

test_wc_sums_multiple_files() {
    unix=$(wc README.md test.sh | tr -s ' ')
    exs=$(./wc.exs README.md test.sh | tr -s ' ')
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_file() {
    unix=$(grep grep README.md)
    exs=$(./grep.exs grep README.md)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_stdin() {
    unix=$(echo -e "hello\nunix\ntools" | grep unix)
    exs=$(echo -e "hello\nunix\ntools" | ./grep.exs unix)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_word_in_multiple_files() {
    unix=$(grep grep *)
    exs=$(./grep.exs grep *)
    assert_equal "$unix" "$exs" $LINENO
}

test_grep_finds_match_in_file() {
    unix=$(grep 'g..p' README.md)
    exs=$(./grep.exs 'g..p' README.md)
    assert_equal "$unix" "$exs" $LINENO
}

test_curl_works_on_http_site() {
    unix=$(curl http://localhost:631 2>/dev/null)
    exs=$(./curl.exs http://localhost:631 2>/dev/null)
    assert_equal "$unix" "$exs" $LINENO
}

test_true_returns_true
test_echo_echoes_one_arg
test_echo_echoes_many_args
test_echo_preserves_quotes
test_yes_repeats_y
test_yes_repeats_first_arg
test_cat_cats_file
test_cat_copies_stdin
test_wc_counts_dev_null
test_wc_counts_in_file
test_wc_sums_multiple_files
test_grep_finds_word_in_file
test_grep_finds_word_in_stdin
test_grep_finds_word_in_multiple_files
test_grep_finds_match_in_file
test_curl_works_on_http_site
echo "ALL TESTS PASSED"
