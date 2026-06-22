#!/bin/sh
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

echo "Cleaning Flutter build..."
flutter clean

echo "Removing Xcode DerivedData for Runner..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*

echo "Reinstalling dependencies..."
flutter pub get
cd ios
rm -rf Pods Podfile.lock build
pod install
cd ..

echo "Done. Run: flutter run"
