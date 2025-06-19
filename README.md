# LeadBreak Frontend 📱

A modern Flutter application for lead management and sales call processing with integrated CRM functionality and real-time calling features.

## 🚀 Features

- **🔐 Authentication System** - Firebase Auth with Google Sign-In
- **📞 Integrated Calling** - SIP calling with keypad interface
- **👥 Contact Management** - Full CRM functionality for lead tracking
- **📊 Dashboard Analytics** - Real-time insights and metrics
- **📋 Follow-up Management** - Track and manage customer follow-ups
- **🎨 Modern UI/UX** - Beautiful animations and responsive design
- **🔄 State Management** - Riverpod for efficient state handling
- **🌐 API Integration** - RESTful API communication with backend

## 📋 Table of Contents

- [Installation](#installation)
- [Project Structure](#project-structure)
- [Features Breakdown](#features-breakdown)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
- [Development](#development)
- [Building](#building)
- [Contributing](#contributing)

## 🛠 Installation

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project setup
- Backend API running

### Setup

1. **Clone the repository**
```bash
git clone <repository-url>
cd leadbreakfrontend
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter packages pub run build_runner build
```

4. **Firebase Setup**
```bash
# Run the provided Firebase setup script
./setup_firebase.bat  # Windows
# or
./validate_firebase_setup.sh  # Linux/Mac
```

5. **Run the application**
```bash
flutter run
```

## 🏗 Project Structure

```
lib/
├── main.dart                   # Application entry point
├── firebase_options.dart       # Firebase configuration
└── src/
    ├── app.dart               # Main app widget
    ├── common_widgets/        # Reusable UI components
    ├── config/               # App configuration
    ├── data/                 # Data layer (repositories, providers)
    ├── models/               # Data models
    ├── utils/                # Utility functions
    └── features/             # Feature-based modules
        ├── authentication/   # Login, signup, profile
        ├── calls/           # Calling functionality
        │   ├── call_details/    # Call information display
        │   ├── call_in_progress/ # Active call interface
        │   └── keypad/          # Dialer keypad
        ├── contacts_crm/    # Contact management
        ├── dashboard/       # Analytics and overview
        └── follow_ups/      # Follow-up management
```

## 🎯 Features Breakdown

### 🔐 Authentication (`features/authentication/`)
- **Firebase Authentication** integration
- **Google Sign-In** support
- **User profile** management
- **JWT token** handling for API calls

### 📞 Calling System (`features/calls/`)
- **SIP Integration** with backend
- **Interactive Keypad** for dialing
- **Call Progress** tracking
- **Call Details** display and history
- **Real-time call** status updates

### 👥 CRM & Contacts (`features/contacts_crm/`)
- **Lead Management** system
- **Contact Information** storage
- **Lead Status** tracking
- **Contact History** and notes

### 📊 Dashboard (`features/dashboard/`)
- **Analytics Overview** with metrics
- **Call Statistics** and reports
- **Lead Conversion** tracking
- **Performance Insights**

### 📋 Follow-ups (`features/follow_ups/`)
- **Scheduled Follow-ups** management
- **Reminder System** integration
- **Follow-up Status** tracking
- **Calendar Integration**

## 🚀 Getting Started

### 1. Firebase Configuration

Ensure your Firebase project is properly configured:

```dart
// firebase_options.dart should be generated
// Run: flutterfire configure
```

### 2. API Configuration

Update your API endpoints in the configuration files:

```dart
// lib/src/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://your-backend-url:8000';
  static const String loginEndpoint = '/register/login';
  static const String sipEndpoint = '/sip/calling_data';
}
```

### 3. Environment Setup

Create environment-specific configurations as needed.

## ⚙️ Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication and Firestore
3. Configure Google Sign-In
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

### Backend Integration
Ensure your backend API is running and accessible. The app expects:
- Authentication endpoints at `/register/*`
- SIP calling endpoints at `/sip/*`
- Proper CORS configuration

## 📦 Dependencies

### Core Dependencies
- **flutter_riverpod** `^2.5.1` - State management
- **go_router** `^13.2.0` - Navigation and routing
- **http** `^1.2.1` - HTTP client for API calls

### Firebase
- **firebase_core** `^2.27.1` - Firebase core functionality
- **firebase_auth** `^4.17.9` - Authentication
- **google_sign_in** `^6.2.1` - Google authentication

### UI/UX
- **google_fonts** `^6.2.1` - Custom fonts
- **animate_do** `^3.3.4` - Smooth animations
- **shimmer** `^3.0.0` - Loading effects

### Development
- **build_runner** `^2.4.8` - Code generation
- **riverpod_generator** `^2.4.0` - Riverpod code generation
- **flutter_lints** `^3.0.1` - Linting rules

## 💻 Development

### Code Generation
When working with Riverpod providers or data classes:

```bash
# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# One-time generation
flutter packages pub run build_runner build
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Debugging
- Use Flutter Inspector for widget debugging
- Enable Firebase debugging for authentication issues
- Check network requests in developer tools

## 🏗 Building

### Debug Build
```bash
flutter run --debug
```

### Release Build

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

### Web (if supported)
```bash
flutter build web --release
```

## 🎨 UI/UX Guidelines

- **Material Design 3** principles
- **Responsive Design** for different screen sizes
- **Accessibility** considerations
- **Dark/Light Theme** support (if implemented)
- **Smooth Animations** for better UX

## 🔧 Architecture

The app follows **Feature-First Architecture** with:

- **Separation of Concerns** - Clear layer separation
- **Dependency Injection** - Using Riverpod providers
- **Repository Pattern** - For data access abstraction
- **MVVM Pattern** - Model-View-ViewModel structure

## 🐛 Known Issues & Improvements

### Current Limitations
1. **Offline Support** - Limited offline functionality
2. **Background Calling** - Call handling when app is backgrounded
3. **Push Notifications** - For call notifications and follow-ups
4. **Data Synchronization** - Real-time sync with backend

### Planned Improvements
- [ ] Implement offline data caching
- [ ] Add push notification support
- [ ] Enhance call quality monitoring
- [ ] Add advanced analytics
- [ ] Implement dark theme
- [ ] Add internationalization (i18n)

## 🚨 Troubleshooting

### Common Issues

**Firebase not initializing:**
```bash
# Reconfigure Firebase
flutterfire configure
```

**Build failures:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**API connection issues:**
- Check backend is running
- Verify API endpoints
- Check network permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing code style and architecture
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ⚠️ **Web** (Limited functionality)
- ❌ **Desktop** (Not implemented)

## 🔐 Security

- Firebase Authentication handles user security
- API calls use JWT tokens
- Sensitive data is not stored locally
- Network communication uses HTTPS

## 📄 License

This project is part of the LeadBreak system. See the main project repository for license information.

## 📞 Support

For technical support:
- Check the [Issues](link-to-issues) section
- Review the backend API documentation
- Contact the development team

---

**Note**: This is the frontend application for the LeadBreak CRM system. Ensure the backend API is running and properly configured for full functionality.
