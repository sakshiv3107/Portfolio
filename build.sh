#!/bin/bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Verify flutter works
flutter --version

# Get dependencies and build
flutter pub get
flutter build web --release