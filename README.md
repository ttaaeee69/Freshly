# 🥗 Freshly

Freshly is a Flutter-based mobile application designed to help users efficiently manage their fridge inventory. It allows users to track ingredients, cooked food, and recipes, set expiration dates, and receive reminders for expiring items. The app integrates Firebase for backend services and uses the Spoonacular API for recipe suggestions.

---

## ✨ Features

- 🥕 **Ingredient Management**: Add, edit, and delete ingredients with optional images.
- 🍲 **Cooked Food Management**: Track cooked food items separately from ingredients.
- ⏰ **Expiration Tracking**: Set expiration dates and get notified about expiring items.
- 📸 **Image Upload**: Upload images for food items using Firebase Storage.
- 📅 **Calendar View**: View expiring items on a calendar.
- 🔍 **Recipe Suggestions**: Fetch recipes based on ingredients using the Spoonacular API.
- 🌐 **Offline Support**: Works seamlessly even without an internet connection.
- 🔒 **User Authentication**: Secure login and data management using Firebase Authentication.

---

## 🚀 Setup Instructions

### Prerequisites

1. Install [Flutter](https://flutter.dev/docs/get-started/install) (version 3.0 or higher).
2. Install [Firebase CLI](https://firebase.google.com/docs/cli).
3. Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
4. Obtain an API key from [Spoonacular](https://spoonacular.com/food-api).

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/freshly.git
   cd freshly
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:

   - Add the `google-services.json` file (for Android) to `android/app/`.
   - Add the `GoogleService-Info.plist` file (for iOS) to `ios/Runner/`.

4. Set up the `.env` file:

   - Create a `.env` file in the root of your project (next to `pubspec.yaml`).
   - Add your Spoonacular API key to the `.env` file:
     ```env
     SPOONACULAR_API_KEY=your_spoonacular_api_key
     ```

5. Run the app:

   ```bash
   flutter run
   ```

---

### ⚠️ Important Note

- **Camera functionality** and **profile updates** may not work as expected when using an emulator. Please use a real device for these features.

---

## 🔗 APIs Used

### Firebase Services

1. **Firebase Authentication**:

   - Used for user authentication (email/password).
   - Allows users to securely log in and manage their data.

2. **Cloud Firestore**:

   - Stores food data (ingredients and cooked items).
   - Schema:
     ```json
     {
       "name": "String",
       "startDate": "Timestamp",
       "expDate": "Timestamp (optional)",
       "imageUrl": "String (optional)",
       "type": "String (ingredient/cooked)",
       "uid": "String (user ID)"
     }
     ```

3. **Firebase Storage**:

   - Used for uploading and storing food images.

### Spoonacular API

- **Endpoint**: `https://api.spoonacular.com/recipes/complexSearch`
- **Purpose**: Fetches recipes based on user-provided ingredients or meal types.
- **Example Query**:
  ```bash
  https://api.spoonacular.com/recipes/complexSearch?apiKey=your_api_key&query=pasta&number=10
  ```

---

## 📂 Folder Structure

```
lib/
├── main.dart # Entry point of the app
├── models/ # Data models (e.g., Food)
├── pages/ # Screens of the app
│ ├── home/ # Home page and calendar view
│ ├── fridge/ # Fridge management (ingredients and cooked)
│ ├── auth/ # Authentication pages
│ ├── menu/ # Recipe suggestions and meal planning
├── widgets/ # Reusable widgets
├── services/ # Firebase and other service integrations
```

---

## 🛠️ Tech Stack

### Frontend

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)

### Backend

![Firebase](https://img.shields.io/badge/Firebase-%23FFCA28.svg?style=for-the-badge&logo=Firebase&logoColor=black)
![Cloud Firestore](https://img.shields.io/badge/Cloud%20Firestore-%23FFCA28.svg?style=for-the-badge&logo=Firebase&logoColor=black)
![Firebase Storage](https://img.shields.io/badge/Firebase%20Storage-%23FFCA28.svg?style=for-the-badge&logo=Firebase&logoColor=black)

### APIs

![Spoonacular API](https://img.shields.io/badge/Spoonacular%20API-%23FF6F00.svg?style=for-the-badge&logo=api&logoColor=white)

### State Management

![Provider](https://img.shields.io/badge/Provider-%23E34F26.svg?style=for-the-badge&logo=flutter&logoColor=white)

### Platforms

![Android](https://img.shields.io/badge/Android-%233DDC84.svg?style=for-the-badge&logo=Android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-%23000000.svg?style=for-the-badge&logo=Apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-%230078D6.svg?style=for-the-badge&logo=Windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-%23000000.svg?style=for-the-badge&logo=Apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-%23FCC624.svg?style=for-the-badge&logo=Linux&logoColor=black)

---

## 📧 Contributors

### Varich Maleevan

- ![Student ID](https://img.shields.io/badge/Student%20ID-6687097-blue?style=for-the-badge)
- ![Email](https://img.shields.io/badge/Email-varich.mal@student.mahidol.edu-red?style=for-the-badge&logo=gmail&logoColor=white)
- [![GitHub](https://img.shields.io/badge/GitHub-taetaevrh-black?style=for-the-badge&logo=github)](https://github.com/taetaevrh)
- ![University Email](https://img.shields.io/badge/University%20Email-varich.malee@gmail.com-red?style=for-the-badge&logo=gmail&logoColor=white)
- [![University GitHub](https://img.shields.io/badge/University%20GitHub-ttaaeee69-black?style=for-the-badge&logo=github)](https://github.com/ttaaeee69)

---

### Onnicha Intuwattanakul

- ![Student ID](https://img.shields.io/badge/Student%20ID-6687108-blue?style=for-the-badge)
- ![Email](https://img.shields.io/badge/Email-onnicha.int@student.mahidol.edu-red?style=for-the-badge&logo=gmail&logoColor=white)
- [![GitHub](https://img.shields.io/badge/GitHub-HOYEONNN-black?style=for-the-badge&logo=github)](https://github.com/HOYEONNN)
- ![University Email](https://img.shields.io/badge/University%20Email-onnicha.int@student.mahidol.edu-red?style=for-the-badge&logo=gmail&logoColor=white)
- [![University GitHub](https://img.shields.io/badge/University%20GitHub-cabbagearoi-black?style=for-the-badge&logo=github)](https://github.com/cabbagearoi)

---
