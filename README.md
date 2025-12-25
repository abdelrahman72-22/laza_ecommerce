 Laza – E-commerce Mobile App (MVP)

---

## 1. Project Overview
Laza is a simplified, functional e-commerce Minimum Viable Product (MVP) based on the Laza UI Kit. This application is built using **Flutter** for a single codebase (iOS & Android) and leverages **Firebase** for backend services and **Platzi Fake Store API** for product data.

### Team Members:
- Abdelrahman Nashat
- Abdelrahman ElNaggar

---

## 2. Functional Requirements (Section 5)
The application fulfills the following requirements as specified in the project scope:

*   **Authentication (Firebase):** 
    *   Email/Password Signup and Login.
    *   Password reset functionality.
    *   Auto-login (persists login state across sessions).
    *   Minimal user data storage in Firestore: `users/{uid}`.
*   **Home & Catalog:** 
    *   Real-time product fetching from Platzi API (`GET /products`).
    *   Local search filtering to find products by title.
*   **Product Details:** 
    *   Display of Image, Title, Price, and Description.
    *   Actions: "Add to Cart" and "Add to Favorites."
*   **Cart & Checkout (Firestore):** 
    *   Persistent cart storage at `carts/{userId}/items/{productId}`.
    *   Quantity updates and item removal.
    *   Dynamic subtotal calculation.
    *   Mock checkout: Clears cart and displays a Success Screen.
*   **Favorites:** 
    *   Persistent wishlist stored at `favorites/{userId}/items/{productId}`.
*   **Profile:** 
    *   Displays current user's email and includes Logout functionality.

---

## 3. Tech Stack
- **Frontend:** Flutter (Dart) - Material 3 Design
- **Backend:** Firebase Authentication & Cloud Firestore
- **API Integration:** HTTP package with Platzi Fake Store API
- **State Management:** Provider & StreamBuilder

---

## 4. Repository Structure (Requirement 9.1)
Following the modular folder structure requirement:
- `/lib/models`: Data structures for Products and Users.
- `/lib/screens`: All UI pages (Auth, Home, Cart, Details, etc.).
- `/lib/services`: Firebase and API logic.
- `/lib/widgets`: Reusable UI components.
- `/builds/apk`: Contains the `app-release.apk` for Android.
- `/docs/screenshots`: Visual evidence of the implemented screens.
- `/appium_tests`: Automation scripts for Auth and Cart flows.
- `/video`: A 1–3 minute MP4 screen recording of the app.

---

## 5. Installation & Setup (Requirement 9.5)

### Prerequisites
- Flutter SDK installed
- VS Code or Android Studio
- An Android Emulator or Real Device

### Instructions
1. **Clone the Repo:**
   ```bash
   git clone [Your-Repository-URL]
2. **Install Dependencies:**
```Bash
  flutter pub get
```
3. **Firebase Configuration:**
   - The project includes firebase_options.dart. To sync with your own Firebase project:

  ```Bash
  flutterfire configure
```
4. **Security Rules:**
  - Apply the rules found in firestore.rules to your Firebase Console under the "Rules" tab of Firestore.
  - Run the App:
```Bash
  flutter run
```
