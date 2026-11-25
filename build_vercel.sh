#!/usr/bin/env bash
set -e

FLUTTER_VERSION="3.50.0"

if [ ! -d "flutter" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git
fi

export PATH="$PWD/flutter/bin:$PATH"

flutter --version
flutter pub get
flutter build web --release