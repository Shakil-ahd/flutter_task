Posts App – Flutter Assessment Submission

A complete Flutter application built with **Clean Architecture**, **BLoC**, **API Integration**, **Deep Linking**, and **Native Android MethodChannel**.

This README follows all required sections asked in the **Softmax Assessment**.

---

Submission Requirements

Source Code
All source code is included in this repository.

---



---

Project Overview

This application demonstrates:

- Clean Architecture (Data → Domain → Presentation)
- Flutter BLoC for state management
- Secure login with Shared Preferences token
- Home screen with:
  - Infinite scrolling posts
  - Pull-to-refresh
  - Animated UI with glassmorphism
  - Search with debounce
- User details popup with animation
- Post details page with tags, author info, and stats
- Native Android integration using **MethodChannel**  
  → Floating Action Button returns device model & Android version  
- Deep linking using custom scheme:  
  **`myapp://posts/{id}`**

---

Setup Instructions

Clone Repository
```bash
git clone https://github.com/Shakil-ahd/flutter_task.git
```

Install Dependencies
```bash
flutter pub get
```

Run the App
```bash
flutter run
```

Test Login Credentials
```
Username: emilys
Password: emilyspass
```

---

Deep Link Testing Command (ADB)

To directly open **Post #10**:

```bash
adb shell am start -a android.intent.action.VIEW -d "myapp://posts/10"
```

---

Important Decisions & Notes

- Used **BLoC** to separate UI and business logic  
- Applied **Repository pattern** for clean data flow  
- **Debounce search** implemented using RxDart  
- **Infinite scroll** with paging logic inside BLoC  
- **MethodChannel** written in Kotlin to fetch real device info  
- **Deep link intent-filters** added in AndroidManifest  
- **Shared Preferences** used for secure token persistence  
- Clean and scalable architecture suitable for interviews  

---

Download the APK:

👉 **[Download APK](https://drive.google.com/file/d/1-Vzd9kG2FuywVxawp316p2u3dC0dFq0F/view?usp=sharing)**

---

Screen Recording (Google Drive)
Contains:

✔ Login  
✔ Home with user info  
✔ Infinite post loading  
✔ Pull-to-refresh  
✔ Search  
✔ Post details  
✔ Deep link test  
✔ FAB → Native device info dialog  

👉 **[Watch Screen Recorded Video](https://drive.google.com/file/d/1LpoC6LSKqg2YW1JaC3tU5SYWVTjo0N1g/view?usp=sharing)**

---

