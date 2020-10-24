#!/bin/bash

git submodule update --init --recursive 2>/dev/null
git pull --recurse-submodules 2>/dev/null
