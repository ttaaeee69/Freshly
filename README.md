# 🥗 Freshly

Freshly is a Flutter-based mobile application designed to help users efficiently manage their fridge inventory. It allows users to track ingredients, cooked food, and recipes, set expiration dates, and receive reminders for expiring items. The app integrates Firebase for backend services and uses the Spoonacular API for recipe suggestions.

---

## ✨ Features

-   🥕 **Ingredient Management**: Add, edit, and delete ingredients with optional images.
-   🍲 **Cooked Food Management**: Track cooked food items separately from ingredients.
-   ⏰ **Expiration Tracking**: Set expiration dates and get notified about expiring items.
-   📸 **Image Upload**: Upload images for food items using Firebase Storage.
-   📅 **Calendar View**: View expiring items on a calendar.
-   🔍 **Recipe Suggestions**: Fetch recipes based on ingredients using the Spoonacular API.
-   🌐 **Offline Support**: Works seamlessly even without an internet connection.
-   🔒 **User Authentication**: Secure login and data management using Firebase Authentication.

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
        SPOONACULAR_API_KEY = your_spoonacular_api_key
        ```

5. Run the app:

    ```bash
    flutter run
    ```

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

-   **Endpoint**: `https://api.spoonacular.com/recipes/complexSearch`
-   **Purpose**: Fetches recipes based on user-provided ingredients or meal types.
-   **Example Query**:
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

## 📧 Contributors

### Varich Maleevan

-   **Student ID**: 6687097
-   **Email**: varich.mal@student.mahidol.edu
-   **GitHub**: [taetaevrh](https://github.com/taetaevrh)
-   **University Email**: varich.malee@gmail.com
-   **University GitHub**: [ttaaeee69](https://github.com/ttaaeee69)

### Onnicha Intuwattanakul

-   **Student ID**: 6687108
-   **Email**: onnicha.int@student.mahidol.edu
-   **GitHub**: [HOYEONNN](https://github.com/HOYEONNN)
-   **University Email**: onnicha.int@student.mahidol.edu
-   **University GitHub**: [cabbagearoi]https://github.com/cabbagearoi

---
