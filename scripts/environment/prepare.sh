#! /usr/bin/env bash
set -e -o verbose

rustup toolchain install "$(cat rust-toolchain)"
rustup default "$(cat rust-toolchain)"
rustup component add rustfmt
rustup component add clippy
rustup target add wasm32-wasi

cd scripts
bundle update --bundler
bundle install
cd ..


if ! [ -x "$(command -v sudo)" ]; then
  npm -g install markdownlint-cli
else
  sudo npm -g install markdownlint-cli
fi


pip3 install jsonschema==3.2.0
pip3 install remarshal==0.11.2
