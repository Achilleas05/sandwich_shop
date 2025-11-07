# Sandwich Shop 🥪

A simple Flutter application that demonstrates the fundamentals of building an interactive UI for ordering sandwiches. This project is designed to be run on the web, but it also works on mobile.

---

## Key Features

- **Customize Sandwich Size**: Choose between a 'Six-inch' or 'Footlong' sandwich.
- **Select Bread Type**: Pick from 'white', 'wheat', or 'wholemeal' bread.
- **Add Notes**: Include special instructions for your order.
- **Adjust Quantity**: Add or remove sandwiches, with a maximum order limit.
- **Real-Time Display**: The order summary updates instantly as you make changes.

## Prerequisites

Before you begin, ensure you have the following tools installed on your system.

- **Flutter SDK**: Version 3.0.0 or higher.
- **Git**: For version control.
- **Visual Studio Code**: Recommended editor for Flutter development.

## Installation & Setup

Follow these steps to get the project running on your local machine.

1.  **Clone the repository** to your desired directory, making sure to check out the correct branch (`3`).

    ```bash
    git clone --branch 3 https://github.com/Achilleas05/sandwich_shop
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

## Usage Instructions

- **Add/Remove**: Use the `+ Add` and `- Remove` buttons to change the quantity. The buttons disable automatically at the minimum (0) and maximum (5) limits.
- **Sandwich Size**: Toggle the `Switch` between 'Six-inch' and 'Footlong'.
- **Bread Type**: Use the `DropdownMenu` to select your preferred bread.
- **Notes**: Type any special requests into the `Add a note` text field. The display will update as you type.

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
│   ├── repositories/
│   │   └── order_repository_test.dart  # Unit tests for the repository logic
│   └── views/
│       └── widget_test.dart            # Widget tests for the UI components
└── pubspec.yaml                    # Project dependencies and metadata
```

## Technologies & Development Tools

- **Framework**: Flutter
- **Language**: Dart
- **Design**: Material Design
- **Dependencies**: Core Flutter SDK (`cupertino_icons`)
- **Development Tools**: Visual Studio Code, Flutter SDK, Git

## Known Issues and Limitations

- **Widget Test Failures**: As described in the "Running Tests" section, `test/widget_test.dart` has failing tests that need to be fixed.
- **Simple State Management**: The app currently uses `setState`. For larger applications, a more scalable state management solution like Provider or BLoC would be beneficial.
- **No Data Persistence**: The order is reset every time the app is closed. Future work could involve using `shared_preferences` to save the order state.
- **Hard-coded Limits**: The maximum quantity is hard-coded. This could be made configurable.

## Contribution

- All development work should be done on **`branch 3`**.
- Please create a Pull Request to merge your changes into the main branch.
- Write unit tests for pure Dart logic and widget tests for UI interactions.
- Commit your code frequently after completing features or exercises.

## Contact

- **Author**: Achilleas Achilleos
- **Email**: `achilleasachilleos0@gmail.com`
- **Support**: For questions and community help, please use the dedicated Discord channel.

---
