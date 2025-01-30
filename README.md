# 📱 FakeNFT iOS App Project

## 📌 Description
This repository contains an iOS application and a backend implemented using [Vapor](https://vapor.codes/). The app communicates with the local running server via API requests.

## 📂 Project Structure
```
/iOS-FakeNFT
│── README.md
│── Server/           # Backend (Vapor)
│── iOS App/          # iOS application (Swift, UIKit)
│── .gitignore        # Ignored files
│── API.html          # API description
```

## 🚀 Getting Started
### 🔹 Requirements
- macOS 15+
- Xcode 16+
- Swift 5.9+

Note: The project has not been tested on Xcode versions below 16 and macOS versions below 15, but it may still work.

### 🌍 Run local Server
1. Navigate to the server folder:
   ```sh
   cd Server
   ```
2. Start the server locally:
   ```sh
   swift run
   ```
   The server will start on `http://127.0.0.1:8080`.
### 📲 iOS Application
1. Open the application folder.
2. Open `FakeNFT.xcodeproj` in Xcode.
3. Build and run on a simulator or device.

- Ensure the server is running locally before launching the app.

---

✉️ For any questions or suggestions, open an `Issue` or submit a `Pull Request`!
