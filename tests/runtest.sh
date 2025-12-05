#!/usr/bin/env bash
set -ex

ROOT=$PWD

echo "Python version:"
python3 -V

echo "GCC version:"
gcc -v || true
g++ -v || true

# ---- Build core ----
cd "$ROOT"
rm -rf build && mkdir build && cd build

cmake ..
make -j"$(nproc)"
make install

# ---- Build Python binding using pyproject.toml ----
cd "$ROOT/bindings/Python"

# clean old builds
rm -rf build dist *.egg-info

# ensure python-build is available (PEP517 builder)
pip3 install --upgrade pip setuptools wheel build

# build wheel
python3 -m build

# install wheel
pip3 install dist/*.whl

# ---- Run Python integration tests ----
cd "$ROOT/tests/Python_and_core"
python3 test.py

echo "All tests passed successfully."
