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

4. Add your Spoonacular API key in `lib/pages/menu/menu_page.dart`:

    ```dart
    final String apiKey = "your_api_key_here";
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

4. **Firebase Cloud Messaging (Optional)**:
    - Sends notifications for expiring items.

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

## 📸 Screenshots

### 🏠 Home Page

![Home Page](https://via.placeholder.com/400x300)

### 🧊 Fridge Management

![Fridge Management](https://via.placeholder.com/400x300)

### 🍽️ Recipe Suggestions

![Recipe Suggestions](https://via.placeholder.com/400x300)

---

## 🤝 Contributing

We welcome contributions! To contribute:

1. Fork the repository.
2. Create a new branch:
    ```bash
    git checkout -b feature-name
    ```
3. Commit your changes:
    ```bash
    git commit -m "Add feature-name"
    ```
4. Push to your branch:
    ```bash
    git push origin feature-name
    ```
5. Open a pull request.

---

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

For any inquiries or issues, please contact:

-   **Name**: Your Name
-   **Email**: your.email@example.com
-   **GitHub**: [your-username](https://github.com/your-username)

---

### 📝 Notes:

1. Replace placeholders like `your-username`, `your.email@example.com`, and screenshot URLs with actual values.
2. Add any additional sections or details specific to your project if needed.
