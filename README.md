# 📱 SwiftUI Chat App – Interview Assignment

## 🧩 Project Overview

This is a single-screen chat application built using **SwiftUI** and **WebSockets** for real-time communication. It supports **offline message queuing** and **automatic retry** when the network is restored.

The goal of this assignment is to demonstrate:
- Real-time data handling with WebSockets
- Offline resilience and error handling
- Clean SwiftUI architecture with MVVM
- Unit test coverage for core functionality

---

## 🚀 Features

- ✅ Real-time messaging via [PieSocket](https://www.piesocket.com/) WebSocket
- ✅ Offline message queuing using `OfflineMessageQueueManager`
- ✅ Automatic retry of queued messages when the network reconnects
- ✅ Alerts for connectivity issues and WebSocket errors
- ✅ Lightweight UI built with SwiftUI
- ✅ Unit test coverage for ViewModel, WebSocketManager, Offline Queue

---

## ⚙️ Setup Instructions

1. Open the project in Xcode (Tested with Xcode 15.3)
2. Target Platform: iOS 16+
3. No third-party dependencies required
4. WebSocket endpoint is mocked for demonstration purposes

---

## 🧪 Testing

- Unit tests written for:
  - `ChatViewModel`
  - `WebSocketManager`
  - `OfflineMessageQueueManager`
  - `Message` model behavior
- UI Tests are skipped to keep the project focused, but can be added as a next step


## 📚 Architecture Notes

- MVVM pattern for maintainability
- `ChatViewModel` acts as the central controller for WebSocket and input handling
- `OfflineMessageQueueManager` is a singleton managing retry logic
- Alerts are globally injected using `.alert()` on views based on `WebSocketManager` state

---

## ⚠️ Known Limitations

- No persistent storage of queued messages (they are cleared on app restart)
- UI is minimal and functional, not styled for production
- WebSocket state is not deeply monitored (could be extended with reconnect strategies)

---

## ✨ Future Improvements

- Add UI Tests using XCUITest
- Persist offline queue using local storage (e.g., CoreData or file system)
- Enhanced error handling with codes and recovery suggestions
- Better message delivery indicators (pending/sent/read)
- Implement authentication and multi-user support

---

## 🧠 Final Notes

This project is designed to be simple, readable, and functional, showcasing my understanding of SwiftUI, real-time systems, and clean architecture.  
Thank you for reviewing!

— Naval Hasan
