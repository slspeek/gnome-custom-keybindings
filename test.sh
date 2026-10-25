#!/usr/bin/env bash
test_results=$(nix-instantiate --eval --strict test-mkSettings.nix)

if [[ $test_results = "[ ]" ]]; then
    echo Tests succeeded;
else
    echo Tests failed:
    echo "$test_results";
    exit 1;
fi
