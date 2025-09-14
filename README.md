# BitChat 🟢💬

BitChat is a **Swift-based chat application** with **dual modes**:
- 🌐 **Online Chat** (like WhatsApp, powered by Firebase)
- 📡 **Offline Mesh Chat** using **Bluetooth peer-to-peer networking**

Designed with **MVVM architecture** and a **modular structure**, BitChat provides seamless communication whether you're connected to the internet or not.

---

## ✨ Features

- 🔗 **Dual Chat Modes**
  - Online chat (real-time via Firebase)
  - Offline peer-to-peer chat (Bluetooth mesh)
- 📡 **Mesh Networking**
  - Peer discovery & message relaying via Bluetooth
- 🔒 **Secure & Persistent**
  - CoreData-backed message history
  - Encrypted communication
- 🎨 **Modern UI**
  - SwiftUI + custom reusable components
- 🛠 **Scalable Codebase**
  - Modular services, view models, and utilities

---

## 🛠 Tech Stack

- **Language:** Swift
- **UI:** SwiftUI + UIKit (where needed)
- **Networking:** Firebase + CoreBluetooth
- **Persistence:** CoreData
- **Architecture:** MVVM + Combine
- **Testing:** XCTest

---

## 📂 Project Structure

```
BitChat/
│── Components/        # Reusable UI widgets (buttons, text fields, bubbles)
│── Models/            # Data models (ChatRoom, Message)
│── Services/          # CoreData, Firebase, NetworkMonitor, SyncService
│── Sources/           # Bluetooth manager for offline mesh mode
│── Utils/             # Peer management helpers
│── ViewModels/        # Chat & OfflineChat state managers (MVVM)
│── Views/             # Screens (ChatList, Chat, OfflineChat, Onboarding)
│── Assets/            # App assets (colors, images, icons)
│── BitChatApp.swift   # App entry point
│── Tests/             # Unit & UI tests
```

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15+
- iOS 16+ device (Bluetooth requires real devices)

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/rachit-goyal1071/bit-chat.git
   ```
2. Open the project:
   ```bash
   cd BitChat
   open BitChat.xcodeproj
   ```
3. Run on your iPhone (not simulator for Bluetooth).

---

## 📸 Screenshots

> *(Add screenshots or demo GIFs here — Chat UI, Bluetooth pairing, etc.)*

---

## 🗺 Roadmap

- [ ] Group chats in mesh mode
- [ ] Media sharing (images, files) offline
- [ ] Push notifications for online mode
- [ ] Delivery/read receipts
- [ ] Cross-platform support (Android planned)

---

## 🤝 Contributing

Contributions are welcome!
1. Fork the repo
2. Create a feature branch (`git checkout -b feature/awesome-feature`)
3. Commit (`git commit -m 'Add feature'`)
4. Push (`git push origin feature/awesome-feature`)
5. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## 👨‍💻 Author

Built with ❤️ by [Rachit Goyal](https://github.com/rachit-goyal1071)
