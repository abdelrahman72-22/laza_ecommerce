# Firebase Setup Guide

1. Create a project in Firebase Console.
2. Enable Email/Password Auth in the Authentication tab.
3. Enable Cloud Firestore in Test Mode.
4. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`.
5. Run `flutterfire configure` to link the app.
6. Apply the security rules found in `firestore.rules`.