#!/bin/bash

function convert() {
    run pandoc -f markdown -t slack.lua tests/"$1".md
}

function read_expected() {
    echo "$(< tests/"$1"-expected.md)"
}

function test_file() {
    convert "$1"

    assert_success

    local expected
    expected="$(read_expected "$1")"
    if [ "$expected" != "$output" ]; then
        # diff with whitespace also shown
        diff -U 3 --label=expected --label=actual <(echo "$expected") <(echo "$output") | cat -vet
        false
    fi
}


setup() {
    bats_load_library "bats-support"
    bats_load_library "bats-assert"
}

# TESTS

@test "basic" {
    test_file basic
}

@test "extended" {
    test_file extended
}

