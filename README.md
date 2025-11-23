# MagicSlides: AI-Powered Presentation Generator

A Flutter application that generates stunning presentations using AI. Built with Clean Architecture and BLoC state management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-Database-3ECF8E?logo=supabase)


## Features

- Email/Password Authentication with persistent sessions
- AI-powered presentation generation
- Multiple template options
- Advanced customization (slide count, AI models, images)
- PDF preview & download functionality
- Smooth onboarding with Lottie animations

## Architecture
This project follows **Clean Architecture** principles with **BLoC** for state management:
 ```bash

lib/
├── core/ # Shared utilities & widgets
├── features/
│ ├── auth/ # Authentication feature
│ │ ├── data/ # Data sources & repositories
│ │ ├── domain/ # Business logic & entities
│ │ └── presentation/ # UI & BLoC
│ ├── onboarding/ # Onboarding flow
│ └── presentation/ # Main feature (PPT generation)
└── injection_container.dart # Dependency injection
 ```

## Design Patterns
- Clean Architecture (Domain, Data, Presentation layers)
- BLoC Pattern for state management
- Repository Pattern for data abstraction
- Dependency Injection with **get_it**

## Database

**Supabase** - Backend-as-a-Service
- Authentication: Email/Password with session management
- User data storage
- Real-time capabilities (future enhancement)

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Supabase Account

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/magic_slides_app.git
   cd magic_slides_app
   ```
3. **Install dependencies**
   ```bash
    flutter pub get
    ```

4. **Configure Supabase**

    Create a project at supabase.com and update lib/main.dart:

   ```bash
    await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY', );
   ```

5. **Configure MagicSlides API**

    Update lib/core/constants/api_constants.dart:
   
    ```bash
    static const String accessId = 'YOUR_ACCESS_ID';
   ```
6. **Add Lottie animations**

    Download animations from LottieFiles and place in:

   ```bash
    assets/lottie/presentation.json
    assets/lottie/ai.json
   ```
7. Run the app
   ```bash
    flutter run
   ```



 ## Dependencies
 
   ```bash

Package	Purpose
flutter_bloc	              State management
supabase_flutter	          Authentication and database
dio	                          HTTP client
get_it	                      Dependency injection
syncfusion_flutter_pdfviewer  PDF viewing
lottie	                      Animations
shared_preferences	          Local storage
  ```
**Known Issues**
- PDF Download on iOS: Requires additional permissions configuration
- Large PDF Files: May cause memory issues on low-end devices
- Network Timeout: Default timeout is 60s, may need adjustment for slow connections
- Supabase Session: Sessions expire after 1 hour, needs refresh token implementation


## Security

- Passwords are hashed using Supabase auth
- API keys stored in constants (move to .env for now)
- Secure HTTPS connections only

## Performance

- Cold start: ~2 seconds
- PDF rendering: Optimized with Syncfusion
- State management: Efficient with BLoC

## Contributing
Contributions are welcome. Please feel free to submit a Pull Request.


## Author
**Priyanshu Amrit**

**Made with ❤️ using Flutter**
