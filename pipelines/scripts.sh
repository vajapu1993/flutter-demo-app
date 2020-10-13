#!/bin/sh

set -e
export PATH=$BUILD_SOURCESDIRECTORY/flutter/bin:$BUILD_SOURCESDIRECTORY/flutter/bin/cache/dart-sdk/bin:$PATH

# All scripts will be placed here
install_flutter() {
  git clone -b stable https://github.com/flutter/flutter.git

  flutter precache
  yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
  flutter doctor
}

envTes() {
  dart lib/test.dart
}

flutter_test() {
  flutter packages get
  flutter drive --target=test_driver/app.dart
}

start_android_emulator(){
  #!/usr/bin/env bash
  # Install AVD files
  echo "y" | $ANDROID_HOME/tools/bin/sdkmanager --install 'system-images;android-27;google_apis;x86'
  # Create emulator
  echo "no" | $ANDROID_HOME/tools/bin/avdmanager create avd -n xamarin_android_emulator -k 'system-images;android-27;google_apis;x86' --force
  $ANDROID_HOME/emulator/emulator -list-avds
  echo "Starting emulator"
  # Start emulator in background
  nohup $ANDROID_HOME/emulator/emulator -avd xamarin_android_emulator -no-snapshot -no-boot-anim > /dev/null 2>&1 &
  $ANDROID_HOME/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed | tr -d '\r') ]]; do sleep 1; done; input keyevent 82'
  $ANDROID_HOME/platform-tools/adb devices
  echo "Emulator started"
}

function start_iOS_simulator()
{
  UUID=$(xcrun simctl list devices | grep "$1" | awk -F"[()]" '{print $2}' | head -1)
  xcrun simctl boot ${UUID}
  RESULT=$(xcrun simctl spawn ${UUID} launchctl print system | grep com.apple.springboard.services)
  echo "RESULT = "${RESULT}
  counter=$((0))
  while [ "$RESULT" = "" ]; do
    sleep 2
    ((counter++))
    RESULT=$(xcrun simctl spawn ${UUID} launchctl print system | grep com.apple.springboard.services)
    echo "waiting on boot event for device ${UUID}, RESULT = "${RESULT}
    if [ $counter -gt 90 ]; then
        echo "device ${UUID} took too long to boot"
        exit 1
    fi
    done
  echo "device ${UUID} booted successfully"
}

generate_test_report() {
  npm install multiple-cucumber-html-reporter
  node pipelines/reporter.js
  find test_driver/reports -type f -name "*.html" -print0 | xargs -0 sed -i '' "s/<.*created-by.*>//g"
  find test_driver/reports -type f -name "*.html" -print0 | xargs -0 sed -i '' "s/<.*\"http.*>//g"
  find test_driver/reports -type f -name "*.html" -print0 | xargs -0 sed -i '' "s/<.*Created.*>//g"
  find test_driver/reports -type f -name "*.html" -print0 | xargs -0 sed -i '' "s/Multiple Cucumber HTML Reporter/Flutter Demo Report/g"
}

"$@"
