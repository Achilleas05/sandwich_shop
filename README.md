## Sandwich Shop

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

   Fix any issues reported for the Flutter SDK or Android toolchain before continuing.

4. **Android toolchain (for emulator/device tests)**

   - Install **Android Studio** and the **Android SDK**.
   - In Android Studio, use **Device Manager** to create an Android emulator (Android 13/14 recommended).
   - Verify that Flutter can see a device:

     ```bash
     flutter devices
     ```

     There should be at least one Android emulator or physical device listed.

5. **Visual Studio Code**

   Optional but recommended as the main editor:

   ```bash
   code --version
   ```

   If missing, install VS Code from its website or via your package manager.

## Getting the code

Use the restored coursework project that was provided to you and open it in your editor:

```bash
cd sandwich_shop_restored
code .
```

If you keep the project in a different folder name, adjust the path accordingly.

## Running the app

From the project root (`sandwich_shop_restored`):

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. To run in a **web browser**:

   ```bash
   flutter run -d chrome
   ```

3. To run on an **Android emulator or device** (used for integration tests and release build):

   ```bash
   flutter run -d <device-id>
   ```

   Replace `<device-id>` with the id from `flutter devices` (for example `emulator-5554`).

## Testing

The project includes:

- **Unit tests** for models, services, and repositories under `test/`.
- **Widget tests** for screens and common widgets under `test/`.
- **Integration tests** under `integration_test/` that exercise full user journeys.

### Run all unit and widget tests

```bash
flutter test
```

### Run only integration tests

Make sure an Android emulator or device is running, then:

```bash
flutter test integration_test/
```

This runs:

- `integration_test/app_test.dart` – end‑to‑end flows (add to cart, change sandwich type, modify quantity, checkout).
- `integration_test/smoke_test.dart` – a lightweight test that verifies the app launches and shows the home screen.

If you want to run only the smoke test with the `flutter drive` command, you can use:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/smoke_test.dart -d <device-id>
```

where `test_driver/integration_test.dart` is the driver file that connects `flutter drive` to the tests in `integration_test/`.

## Building a release APK (Android)

After testing, you can build an optimized Android release APK:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The release APK is created at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

In this project, the debug APK (`app-debug.apk`) is about **97.6 MB**, whereas the release APK (`app-release.apk`) is about **81.4 MB**, so the release build is roughly **16 MB smaller**.  
The release build also starts faster and feels smoother because it is fully optimized and does not include debug tooling or hot‑reload support.

To install the release APK on an emulator or device:

```bash
flutter install -d <device-id> --use-application-binary=build/app/outputs/flutter-apk/app-release.apk
```

Then open the app icon on the device/emulator to run the release build.

## Support

For questions about the coursework or this project, use the dedicated module discussion channels (such as the course Discord/Teams) or ask a member of staff during your lab session.
