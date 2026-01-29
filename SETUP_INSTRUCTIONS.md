# Quick Setup Instructions to Run the App

## Option 1: Using VS Code (Easiest - Recommended)

1. **Install VS Code** (if not installed)
   - Download from: https://code.visualstudio.com/

2. **Install Flutter Extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Flutter" by Dart Code
   - Click Install
   - The extension will guide you to install Flutter automatically

3. **Open Project**
   - File → Open Folder
   - Select: `C:\Users\purvi\Videos\daily meal planning`

4. **Run the App**
   - Press `F5` or click the Run button
   - Select a device when prompted

## Option 2: Manual Flutter Installation

1. **Download Flutter**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter SDK zip file
   - Extract to: `C:\Users\purvi\flutter`

2. **Add to PATH**
   - Press Windows key, search "Environment Variables"
   - Click "Edit the system environment variables"
   - Click "Environment Variables"
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\Users\purvi\flutter\bin`
   - Click OK on all dialogs

3. **Restart Terminal/IDE**

4. **Verify Installation**
   ```powershell
   flutter doctor
   ```

5. **Get Dependencies**
   ```powershell
   cd "C:\Users\purvi\Videos\daily meal planning"
   flutter pub get
   ```

6. **Run the App**
   ```powershell
   flutter run
   ```

## Option 3: Using Android Studio

1. **Install Android Studio**
   - Download from: https://developer.android.com/studio

2. **Install Flutter Plugin**
   - Open Android Studio
   - File → Settings → Plugins
   - Search for "Flutter" and install
   - Restart Android Studio

3. **Open Project**
   - File → Open
   - Select: `C:\Users\purvi\Videos\daily meal planning`

4. **Run the App**
   - Click the green Run button
   - Select a device

## Quick Download Links

- **Flutter SDK**: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip
- **VS Code**: https://code.visualstudio.com/
- **Android Studio**: https://developer.android.com/studio

## After Installation

Once Flutter is installed, run these commands in the project directory:

```powershell
cd "C:\Users\purvi\Videos\daily meal planning"
flutter pub get
flutter run
```

## Troubleshooting

- **"flutter not found"**: Make sure Flutter is in your PATH and you've restarted the terminal
- **"No devices found"**: Start an Android emulator or connect a physical device
- **Build errors**: Run `flutter clean` then `flutter pub get`
