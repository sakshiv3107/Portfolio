#!/bin/bash
set -e

git clone https://github.com/flutter/flutter.git -b 3.32.7 --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

flutter --version
flutter pub get
flutter build web --release --no-tree-shake-icons