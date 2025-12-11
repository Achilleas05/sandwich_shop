# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.  
The app is built using Flutter and Dart and can run on Android, web, and desktop targets.

## Prerequisites

1. **Terminal**

   - **macOS** – use the built‑in Terminal app.
   - **Windows** – use Command Prompt, PowerShell, or Windows Terminal.

2. **Git**

   Check that Git is installed:

   ```bash
   git --version
   ```

   If missing, install it from the [official Git website](https://git-scm.com/downloads).

3. **Flutter SDK**

   Install Flutter and make sure it is configured:

   ```bash
   flutter doctor
   ```

   Fix any issues reported for the Flutter SDK or Android toolchain before continuing.[1]

4. **Android toolchain (for emulator/device tests)**

   - Install **Android Studio** and the **Android SDK**.
   - In Android Studio, use **Device Manager** to create an Android emulator (Android 13/14 recommended).
   - Verify that Flutter can see a device:

   ```bash
   flutter devices
   ```

   There should be at least one Android emulator or physical device listed.[1]

5. **Visual Studio Code**

   Optional but recommended as the main editor:

   ```bash
   code --version
   ```

   If missing, install VS Code from its website or via your package manager.

## Getting the code

### First‑time setup

```bash
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### Existing clone

```bash
git fetch origin
git checkout 8
```

## Running the app

From the project root:

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. To run in a **web browser** (original worksheet target):

   ```bash
   flutter run -d chrome
   ```

3. To run on an **Android emulator or device** (used for integration tests and release build):

   ```bash
   flutter run -d <device-id>
   ```

   Replace `<device-id>` with the id from `flutter devices` (for example `emulator-5554`).[1]

## Testing

The project includes:

- **Unit tests** for models, services, and repositories under `test/models`, `test/services`, `test/repositories`.
- **Widget tests** for screens and common widgets under `test/views` and `test/widgets`.
- **Integration tests** under `integration_test/` that exercise full user journeys.[1]

### Run all unit and widget tests

```bash
flutter test
```

### Run only integration tests (Worksheet 8)

Make sure an Android emulator or device is running, then:

```bash
flutter test integration_test/
```

This runs:

- `integration_test/app_test.dart` – end‑to‑end flows (add to cart, change sandwich type, modify quantity, checkout).
- `integration_test/smoke_test.dart` – a lightweight test that verifies the app launches and shows the home screen.[1]

If the environment is slow and you want to run only the smoke test on an emulator, you can also use:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/smoke_test.dart -d <device-id>
```

where `test_driver/integration_test.dart` is the small driver file that connects `flutter drive` to `integration_test`.[1]

## Building a release APK (Android)

After testing, you can build an optimized Android release APK:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The release APK will be created at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

You can compare this with the debug APK (`app-debug.apk`) in the same directory; the release build is smaller and starts faster because it is fully optimized and has no debug overhead.[1]

To install the release APK on an emulator or device:

```bash
flutter install -d <device-id> --use-application-binary=build/app/outputs/flutter-apk/app-release.apk
```

## Support

For questions about the coursework or this project, use the dedicated Discord channel linked from the module materials, or ask a member of staff during your lab session.[1]

[1](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/images/50592900/9e738357-d3bc-4ab6-8f28-6badcb23d31f/image.jpg)
