# Sandwich Shop

A simple Flutter application that demonstrates the fundamentals of building an interactive UI for ordering sandwiches. This project is designed to be run on the web, but it also works on mobile.

!Build Status
!Flutter Version
!License

---

## Key Features

- **Customize Sandwich Size**: Choose between a 'Six-inch' or 'Footlong' sandwich.
- **Select Bread Type**: Pick from 'white', 'wheat', or 'wholemeal' bread.
- **Add Notes**: Include special instructions for your order.
- **Adjust Quantity**: Add or remove sandwiches, with a maximum order limit.

## Screenshots

_(This is a placeholder section. To add your own screenshots, create a directory named `assets/screenshots/` in the project root, add your images there, and update the paths below.)_

|    Main Screen    |
| :---------------: |
| `!App Screenshot` |

## Prerequisites

Before you begin, ensure you have the following tools installed on your system.

1.  **Terminal**:

    - **macOS**: Use the built-in Terminal app.
    - **Windows**: Use Command Prompt, PowerShell, or Windows Terminal.

2.  **Git**: Verify installation with `git --version`. If it's not installed, download it from the official Git website.

3.  **Flutter SDK**: Verify installation with `flutter doctor`. If it's missing, you can install it using a package manager:

    - **macOS (Homebrew)**: `brew install --cask flutter`
    - **Windows (Chocolatey)**: `choco install flutter`

4.  **Visual Studio Code**: Verify installation with `code --version`. This is the recommended editor.
    - **macOS (Homebrew)**: `brew install --cask visual-studio-code`
    - **Windows (Chocolatey)**: `choco install vscode`

## Installation & Setup

Follow these steps to get the project running on your local machine.

1.  **Clone the repository** to your desired directory, making sure to check out the correct branch (`3`).

    ```bash
    git clone --branch 3 https://github.com/manighahrmani/sandwich_shop
    ```

2.  **Navigate into the project directory** and open it in Visual Studio Code.

    ```bash
    cd sandwich_shop
    code .
    ```

3.  **Install dependencies** by running the following command in the VS Code integrated terminal.

    ```bash
    flutter pub get
    ```

## Running the App

You can run the app on the web or a mobile emulator.

- **To run in a web browser (Chrome):**

  ```bash
  flutter run -d chrome
  ```

- **To run on a connected device or emulator:**

  ```bash
  flutter run
  ```

## Running Tests

To run the unit and widget tests for the project, execute:

```bash
flutter test
```

### How to Fix Failing Widget Tests

You may notice that some tests in `test/widget_test.dart` are failing. This is intentional and serves as a great learning exercise!

**The Cause**: The tests fail because of a mismatch between the text the test _expects_ to find and the text the app _actually_ displays. The UI constructs a descriptive string that includes the quantity, bread type, and sandwich size (e.g., `0 white Footlong sandwich(es): `). The original tests were likely written with a simpler expectation (e.g., `0 Footlong sandwich(es): `).

**How to Fix**: You have two primary options:

1.  **Update the Test (Recommended)**: Adjust the test to match the current UI behavior. This is the standard practice.

    - **File to edit**: `test/widget_test.dart`
    - **Example Fix**: Change the `find.text()` matcher to include the bread type and correct capitalization.

      ```dart
      // Before (This will fail)
      expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);

      // After (This will pass)
      expect(find.text('0 white Footlong sandwich(es): '), findsOneWidget);
      ```

2.  **Update the UI**: Alternatively, you can modify the UI to match the simpler test assertion.

    - **File to edit**: `lib/main.dart`
    - **Example Fix**: Modify the `displayText` string in the `OrderItemDisplay` widget's `build` method.

      ```dart
      // In OrderItemDisplay build method

      // Before
      String displayText =
          '$quantity ${breadType.name} $itemType sandwich(es): ${'🥪' * quantity}';

      // After (to match a simpler test)
      String displayText =
          '$quantity $itemType sandwich(es): ${'🥪' * quantity}';
      ```

## Usage

- **Add/Remove**: Use the `+ Add` and `- Remove` buttons to change the quantity of sandwiches. The buttons will disable automatically at the minimum (0) and maximum (5) limits.
- **Sandwich Size**: Toggle the `Switch` between 'Six-inch' and 'Footlong'.
- **Bread Type**: Use the `DropdownMenu` to select your preferred bread.
- **Notes**: Type any special requests into the `TextField`. The display will update as you type.

## Project Structure

The project follows a standard Flutter structure, with logic separated from the UI.

```
sandwich_shop/
├── lib/
│   ├── repositories/
│   │   └── order_repository.dart   # Business logic for managing order quantity
│   ├── views/
│   │   └── app_styles.dart         # Shared text styles for the app
│   └── main.dart                   # Main application UI and entry point
├── test/
│   ├── order_repository_test.dart  # Unit tests for the repository logic
│   └── widget_test.dart            # Widget tests for the UI components
└── pubspec.yaml                    # Project dependencies and metadata
```

## Technologies & Dependencies

- **Framework**: Flutter
- **Language**: Dart
- **Dependencies**: Core Flutter SDK (`cupertino_icons`).

## Known Issues & TODOs

- **Failing Widget Tests**: As described in the "Running Tests" section, `widget_test.dart` has failing tests that need to be fixed.
- **Simple State Management**: The app currently uses `setState`. For larger applications, a more scalable state management solution like Provider or BLoC would be beneficial.
- **No Data Persistence**: The order is reset every time the app is closed. Future work could involve using `shared_preferences` to save the order state.
- **UI Polish**: The UI is functional but could be improved with better accessibility labels and more robust form validation.

## Contribution & Development

- All development work should be done on **`branch 3`**.
- Please create a Pull Request to merge your changes into the main branch.
- Write unit tests for pure Dart logic (`/test/*_test.dart`) and widget tests for UI interactions (`/test/widget_test.dart`).
- Commit your code frequently after completing features or exercises.

## Contact

- **Author**: Achilleas Achilleos
- **Email**: `achilleasachilleos0@gmail.com`
- **Support**: For questions and community help, please use the dedicated Discord channel.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---
