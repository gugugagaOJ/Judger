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

# ---- Create Python virtual environment ----
cd "$ROOT"
rm -rf venv
python3 -m venv venv

# activate venv
source venv/bin/activate

python3 -V
pip install --upgrade pip setuptools wheel build

# ---- Build Python binding using pyproject.toml ----
cd "$ROOT/bindings/Python"

rm -rf build dist *.egg-info
python3 -m build
pip install dist/*.whl

# ---- Run Python integration tests ----
cd "$ROOT/tests/Python_and_core"
python3 test.py

echo "All tests passed successfully."
