# 🚂 RailNova

> **Modern IRCTC-Style iOS Super App**  
> SwiftUI · MVVM · async/await · AI-Powered · Razorpay Sandbox

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift) ![iOS](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple) ![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green) ![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 📱 Project Vision

Build an **iOS-first premium railway platform** with fast booking, clean UX, AI-powered seat prediction, live train tracking, and a best-in-class Tatkal assistant — inspired by IRCTC, ixigo, ConfirmTkt, and RailOne.

---

## ✨ Features

### Core Features
- 🔐 Google / Apple / Phone OTP Login (Firebase Auth)
- 🔍 Train Search & Availability (All Classes, Quotas)
- 🪑 Interactive Coach Layout & Seat Selection
- 📄 PNR Status Tracking
- 🚦 Live Train Status with real-time station timeline
- 🎫 Ticket PDF Generation & Share
- 💸 Refund & Cancellation Management (TDR)
- 🍱 Food on Train (E-Catering / E-Pantry)
- 🔔 Push Notifications (Platform change, Delays, ETA)

### Advanced / AI Features
- 🤖 AI Seat Prediction (CNF Probability Engine)
- ⚡ Tatkal Assistant (Optimised fast-booking)
- 📈 Delay Forecasting
- 🗺️ Smart Travel Planner (Multi-modal trips)
- 🗓️ Fare Calendar (Best date suggestions)

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **UI** | SwiftUI 5 |
| **Architecture** | MVVM + Clean Architecture |
| **Async** | async/await + Combine |
| **Auth** | Firebase Authentication |
| **Backend** | Node.js (Express, TypeScript) / NestJS (planned) |
| **Database** | PostgreSQL + Redis |
| **Payments** | Razorpay Sandbox |
| **Deployment** | AWS / GCP |

---

## 📦 Swift Package Dependencies

| Package | Purpose |
|---|---|
| `Firebase iOS SDK` | Auth, Analytics, Notifications |
| `Razorpay iOS SDK` | Mock payment gateway |
| `SDWebImageSwiftUI` | Async image loading |
| `Lottie` | Animations |
| `KeychainSwift` | Secure token storage |

---

## Firebase setup

1. Create your own Firebase project.
2. Download `GoogleService-Info.plist`.
3. Add it to the iOS target in Xcode (not tracked in Git).

---

## 🗂 Folder Structure

```
RailNova/
├── App/
│   ├── RailNovaApp.swift
│   └── AppDelegate.swift
├── Core/
│   ├── Network/
│   │   ├── APIClient.swift
│   │   ├── Endpoints.swift
│   │   └── NetworkError.swift
│   ├── Models/
│   │   ├── Train.swift
│   │   ├── Booking.swift
│   │   ├── Passenger.swift
│   │   ├── PNRStatus.swift
│   │   └── LiveStatus.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   ├── BookingService.swift
│   │   └── TrainService.swift
│   └── Extensions/
│       ├── Color+RN.swift
│       └── Date+RN.swift
├── Features/
│   ├── Auth/
│   ├── Home/
│   ├── Search/
│   ├── Booking/
│   ├── PNR/
│   ├── LiveTracking/
│   ├── MyBookings/
│   ├── FoodOnTrain/
│   ├── AI/
│   └── Profile/
├── DesignSystem/
│   ├── RNColors.swift
│   ├── RNTypography.swift
│   └── Components/
│       ├── RNButton.swift
│       ├── RNCard.swift
│       └── RNTextField.swift
└── Resources/
    └── Assets.xcassets
```

---

## 🗓 Development Roadmap

| Phase | Scope | Timeline |
|---|---|---|
| **Phase 1** | Foundation — Auth, Design System, Tab Scaffold | Week 1–2 |
| **Phase 2** | Core Booking Flow — Search → Seat → Pay → Confirm | Week 3–5 |
| **Phase 3** | Utility Screens — PNR, Live Status, My Bookings, Profile | Week 6–7 |
| **Phase 4** | AI Features — Seat Prediction, Tatkal, Food, Alerts | Week 8–10 |
| **Phase 5** | Polish, Testing, App Store Submission | Week 11–12 |

---

## 🚀 Getting Started

```bash
git clone https://github.com/ChandraRao-Ravi/RailNova.git
cd RailNova
open RailNova.xcodeproj
```

> Requires Xcode 15+, iOS 17 SDK, Swift 5.9

> 🔌 Backend: For local development, start the RailNova API mock server
> from the `irctc-project-backend` repo (`npm run dev`) and point
> the app’s `APIClient.baseURL` to `http://localhost:3000/api`.

---

## 🔗 Related Projects

- [RailNova API (Node.js backend)](https://github.com/ChandraRao-Ravi/irctc-project-backend)

## 👨‍💻 Author

**Chandra Rao** · Senior iOS Developer  
[GitHub](https://github.com/ChandraRao-Ravi)

---

## 📄 License

MIT License © 2026 Chandra Rao
