# 📱 FakeNFT Project

## 📌 Description
This repository contains an iOS application written in Swift 5.9+ and a backend implemented using [Vapor](https://vapor.codes/). The app supports iOS 13+ and communicates with the server via API requests.

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
- macOS 12+
- Xcode 15+
- Swift 5.9+

### 🔹 Installing Dependencies
#### 📲 iOS Application
1. Open a terminal and navigate to the application folder:
   ```sh
   cd ios-app
   ```
2. Install dependencies (if using Swift Package Manager or CocoaPods):
   ```sh
   pod install  # If using CocoaPods
   ```
3. Open `ios-app.xcworkspace` in Xcode.
4. Build and run on a simulator or device.

#### 🌍 Vapor Server
1. Navigate to the server folder:
   ```sh
   cd Server
   ```
2. Install dependencies:
   ```sh
   vapor update
   ```
3. Set up the database (e.g., for PostgreSQL):
   ```sh
   brew install postgresql  # Install PostgreSQL (if not installed)
   brew services start postgresql  # Start the service
   createdb vapor_database  # Create the database
   ```
4. Start the server locally:
   ```sh
   vapor run
   ```
   The server will start on `http://127.0.0.1:8080`.

## 📡 Connecting the iOS App to the Server
By default, the app sends requests to `http://127.0.0.1:8080`. To ensure proper operation:
- Enable `App Transport Security (ATS)` by adding the following to `Info.plist`:
  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```
- Ensure the server is running locally before launching the app.

## 🛠 Development and Debugging
### 🔸 Logging
- The iOS app uses `print()` or `OSLog` for logging.
- The server uses Vapor's `Logger` for logging.

### 🔸 API Testing
After starting the server, use `curl` or Postman to test the API:
```sh
curl -X GET http://127.0.0.1:8080/api/test
```

## 🎯 TODO
- [ ] Improve error handling
- [ ] Write tests

---

✉️ For any questions or suggestions, open an `Issue` or submit a `Pull Request`!

