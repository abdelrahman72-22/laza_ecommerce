# Running Appium Tests - Setup Guide

## Prerequisites
✅ Appium is installed
✅ Android Emulator (emulator-5554) is running  
✅ APK has been copied to appium_tests folder

## Issue
The ANDROID_HOME environment variable needs to be set for Appium to work properly.

## Solution - Run Tests Step by Step

### Option 1: Manual (Recommended for first time)

1. **Open a NEW Command Prompt window** (not PowerShell)

2. **Set environment variables and start Appium:**
   ```cmd
   set ANDROID_HOME=C:\Users\abdel\AppData\Local\Android\Sdk
   set ANDROID_SDK_ROOT=C:\Users\abdel\AppData\Local\Android\Sdk
   node "C:\Users\abdel\AppData\Roaming\npm\node_modules\appium\build\lib\main.js"
   ```

3. **In your current PowerShell terminal, run the tests:**
   ```powershell
   cd c:\Users\abdel\laza_ecommerce\appium_tests
   node ../node_modules/@wdio/cli/bin/wdio.js wdio.conf.js
   ```

### Option 2: Using Batch File

1. **Double-click on:** `c:\Users\abdel\laza_ecommerce\appium_tests\start_appium.bat`
   
   This will open a command window with Appium running.

2. **In your PowerShell terminal, run:**
   ```powershell
   cd c:\Users\abdel\laza_ecommerce\appium_tests
   node ../node_modules/@wdio/cli/bin/wdio.js wdio.conf.js
   ```

### Option 3: Set Environment Variables Permanently

1. **Open System Properties:**
   - Press `Win + Pause/Break`
   - OR Search for "Environment Variables" in Start Menu

2. **Add User Environment Variables:**
   - Click "Environment Variables"
   - Under "User variables", click "New"
   - Variable name: `ANDROID_HOME`
   - Variable value: `C:\Users\abdel\AppData\Local\Android\Sdk`
   - Click OK
   - Add another:
   - Variable name: `ANDROID_SDK_ROOT`
   - Variable value: `C:\Users\abdel\AppData\Local\Android\Sdk`
   - Click OK

3. **Restart VS Code completely**

4. **Then you can start Appium normally:**
   ```powershell
   appium
   ```

5. **And run tests in another terminal:**
   ```powershell
   cd c:\Users\abdel\laza_ecommerce\appium_tests
   node ../node_modules/@wdio/cli/bin/wdio.js wdio.conf.js
   ```

## Test Files
- `auth_test.spec.js` - Authentication flow test
- `cart_test.spec.js` - Shopping cart test

## Configuration
- Appium Server: `http://localhost:4723`
- Device: `emulator-5554`
- APK: `./app-debug.apk`
