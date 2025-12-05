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
make -j$(nproc)
make install

# ---- Build Python binding ----
cd "$ROOT/bindings/Python"
rm -rf build dist *.egg-info
python3 setup.py install

# ---- Run Python integration tests ----
cd "$ROOT/tests/Python_and_core"
python3 test.py

echo "All tests completed successfully."
