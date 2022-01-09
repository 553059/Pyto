#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

source environment.sh

cd ../bcrypt
python3 setup.py bdist
python3 ../tools/make_frameworks.py bcrypt Bcrypt
../tools/copy-scripts.sh build/lib*/* ../../../site-packages/bcrypt
