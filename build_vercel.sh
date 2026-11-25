#!/usr/bin/env bash
set -e

FLUTTER_VERSION="3.50.0"

if [ ! -d "flutter" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git
fi

export PATH="$PWD/flutter/bin:$PATH"

flutter --version
flutter pub get
flutter build web --release \
  --dart-define=SUPABASE_URL="https://gsfrmnvfcwwkplwjwqat.supabase.co/rest/v1/" \
  --dart-define=SUPABASE_ANON_KEY="sb_publishable_iyGMdVfO0ElUaAdE3o-09A_kogbus08"