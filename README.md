# Meal Deal App

## Project Overview
The **Meal Deal App** is a mobile application designed to provide users with detailed information about meal deals, including calorie content, kilojoules, carbohydrates, and protein values. It fetches and displays nested nutrient data, allowing users to make informed dietary choices.

### Key Features
- Display of meal deals with descriptions, prices, and images.
- Nutrient information parsed from complex JSON structures.
- Support for calorie, kilojoule, carbohydrate, and protein data visualization.
- Modern, user-friendly UI.

---

## Requirements
To run this project, you will need:

- **Android Studio**: Arctic Fox (or later)
- **Flutter SDK**: Version 3.0 or later
- **Dart SDK**: Included with Flutter
- **Android Emulator**: API level 30 or higher

---

## Steps to Run the Project

### 1. Clone the Repository
```bash
https://github.com/PramodMannapperuma/foodOrderingApplication.git
cd your-repository-name
```

### 2. Set Up Flutter Environment
Ensure that the Flutter SDK is installed and added to your system's PATH.

Check Flutter installation:
```bash
flutter --version
```

If not installed, follow the instructions here: [Install Flutter](https://flutter.dev/docs/get-started/install)

### 3. Open in Android Studio
1. Launch Android Studio.
2. Select **Open an Existing Project**.
3. Navigate to the project folder and open it.

### 4. Install Dependencies
Run the following command in the terminal to fetch the required dependencies:
```bash
flutter pub get
```

### 5. Connect an Emulator or Device
- **Android Emulator**:
  1. Go to **AVD Manager** in Android Studio.
  2. Create or start an emulator.
- **Physical Device**:
  1. Enable Developer Options and USB Debugging on your Android device.
  2. Connect the device via USB.

Verify the device connection:
```bash
flutter devices
```

### 6. Run the App
Use the following command to run the app:
```bash
flutter run
```

Alternatively, press the **Run** button in Android Studio.

---

## Project Structure
- `lib/`: Contains the Dart source code.
  - `models/`: Data models for parsing JSON.
  - `screens/`: UI screens.
  - `widgets/`: Reusable UI components.
- `assets/`: Static resources like images and JSON files.
- `test/`: Unit and widget tests.

---

## Troubleshooting
1. **Dependencies not found:** Run `flutter pub get`.
2. **Emulator not starting:** Ensure the emulator API level matches the Flutter requirements.
3. **Device not detected:** Check USB connection or use `adb devices` to verify.

For additional support, refer to the [Flutter documentation](https://flutter.dev/docs).

---

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch for your feature: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add new feature'`
4. Push to the branch: `git push origin feature-name`
5. Open a pull request.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

---

### Happy Coding!

