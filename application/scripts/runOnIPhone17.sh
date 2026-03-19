#!/bin/bash

# ============================================
# 🚀 Run Astrology App on iPhone 17 Simulator
# ============================================

set -e

# Navigate to project directory
cd "$(dirname "$0")/.."

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  🔮 Astrology App — iPhone 17 Launcher  ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ------------------------------------------
# Step 1: Check Flutter is installed
# ------------------------------------------
echo "📋 Step 1: Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "   ❌ Flutter not found. Please install Flutter SDK first."
    echo "   👉 https://docs.flutter.dev/get-started/install"
    exit 1
fi
FLUTTER_VER=$(flutter --version 2>&1 | head -1)
echo "   ✅ $FLUTTER_VER"
echo ""

# ------------------------------------------
# Step 2: Check Xcode is installed
# ------------------------------------------
echo "📋 Step 2: Checking Xcode installation..."
if ! command -v xcodebuild &> /dev/null; then
    echo "   ❌ Xcode not found. Please install Xcode from the App Store."
    exit 1
fi
XCODE_VER=$(xcodebuild -version 2>&1 | head -1)
echo "   ✅ $XCODE_VER"
echo ""

# ------------------------------------------
# Step 3: Find iPhone 17 Simulator
# ------------------------------------------
echo "📋 Step 3: Finding iPhone 17 simulator..."
SIMULATOR_ID=$(xcrun simctl list devices available | grep "iPhone 17 (" | head -1 | grep -oE "[A-F0-9-]{36}")

if [ -z "$SIMULATOR_ID" ]; then
    echo "   ❌ iPhone 17 simulator not found."
    echo "   Available iPhone simulators:"
    xcrun simctl list devices available | grep -E "iPhone" | head -10 | sed 's/^/      /'
    echo ""
    echo "   💡 Try updating Xcode or downloading the latest iOS runtime:"
    echo "      Xcode → Settings → Platforms → Download iOS Simulator"
    exit 1
fi
echo "   ✅ Found iPhone 17 (ID: $SIMULATOR_ID)"
echo ""

# ------------------------------------------
# Step 4: Boot the simulator
# ------------------------------------------
echo "📋 Step 4: Booting iPhone 17 simulator..."
BOOT_STATUS=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | grep -o "(Booted)" || true)
if [ "$BOOT_STATUS" = "(Booted)" ]; then
    echo "   ✅ Simulator already booted"
else
    xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true
    echo "   ✅ Simulator booted"
fi
echo ""

# ------------------------------------------
# Step 5: Open Simulator app
# ------------------------------------------
echo "📋 Step 5: Opening Simulator app..."
open -a Simulator 2>/dev/null
echo "   ✅ Simulator app opened"
echo ""

# ------------------------------------------
# Step 6: Get Flutter dependencies
# ------------------------------------------
echo "📋 Step 6: Getting Flutter dependencies..."
flutter pub get
echo "   ✅ Dependencies resolved"
echo ""

# ------------------------------------------
# Step 7: Run the app
# ------------------------------------------
echo "📋 Step 7: Running app on iPhone 17..."
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  🔥 Hot Reload: r  |  🔄 Restart: R     ║"
echo "║  🛑 Quit: q        |  🔌 Detach: d      ║"
echo "╚══════════════════════════════════════════╝"
echo ""
flutter run -d "$SIMULATOR_ID"
