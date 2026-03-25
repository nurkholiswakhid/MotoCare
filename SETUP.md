# Aplikasi Mobile Penjadwalan Ganti Oli dan Servis Motor

Aplikasi Flutter untuk mengelola jadwal ganti oli dan servis rutin kendaraan bermotor dengan notifikasi otomatis.

## Fitur Utama

✅ **Autentikasi**
- Login dengan Email dan Password
- Login dengan Google  
- Registrasi Akun Baru
- Reset Password
- Multiple User Sessions

✅ **Manajemen Kendaraan**
- Menambah/Mengedit/Menghapus kendaraan
- Menyimpan informasi: Nama, Nopol, KM Saat Ini
- List view untuk semua kendaraan

✅ **Penjadwalan Servis**
- 2 tipe servis: Ganti Oli dan Servis Rutin
- Interval berbasis waktu (hari) dan kilometer
- Status otomatis: Aman, Segera Hadir, Terlambat
- Notifikasi otomatis (FCM + Local Notifications)

✅ **Riwayat Servis**
- Pencatatan lengkap: Tanggal, Tipe, Biaya, Catatan
- Total biaya servis terkumpul
- Sorting berdasarkan tanggal terbaru

✅ **Dashboard**
- Overview semua kendaraan
- Status servis real-time
- Quick access ke detail kendaraan

## Teknologi & Architektur

- **Framework**: Flutter (Dart)
- **Arch**: Clean Architecture + MVVM
- **State Management**: Provider
- **Backend**: Firebase (Auth, Firestore, FCM)
- **Local Storage**: SharedPreferences (untuk caching)
- **Notifications**: Firebase Cloud Messaging + Flutter Local Notifications

### Struktur Folder

```
lib/
├── core/                          # Domain Layer
│   ├── entities/                  # Business Models
│   │   ├── user.dart
│   │   ├── vehicle.dart
│   │   ├── schedule.dart
│   │   └── service_history.dart
│   └── repositories/              # Abstract Repositories
│       ├── auth_repository.dart
│       ├── vehicle_repository.dart
│       ├── schedule_repository.dart
│       └── service_history_repository.dart
│
├── data/                          # Data Layer
│   ├── models/                    # DTOs
│   │   ├── user_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── schedule_model.dart
│   │   └── service_history_model.dart
│   ├── datasources/               # Firebase APIs
│   │   ├── auth_remote_datasource.dart
│   │   ├── vehicle_remote_datasource.dart
│   │   ├── schedule_remote_datasource.dart
│   │   └── service_history_remote_datasource.dart
│   └── repositories/              # Repository Implementations
│       ├── auth_repository_impl.dart
│       ├── vehicle_repository_impl.dart
│       ├── schedule_repository_impl.dart
│       └── service_history_repository_impl.dart
│
├── presentation/                  # Presentation Layer
│   ├── viewmodels/                # MVVM ViewModels
│   │   ├── auth_viewmodel.dart
│   │   ├── vehicle_viewmodel.dart
│   │   ├── schedule_viewmodel.dart
│   │   └── service_history_viewmodel.dart
│   ├── pages/                     # Screens
│   │   ├── login_page.dart
│   │   ├── home_page.dart
│   │   ├── vehicle_list_page.dart
│   │   └── vehicle_detail_page.dart
│   └── widgets/                   # Reusable Widgets
│       ├── schedule_status_card.dart
│       ├── vehicle_card.dart
│       └── dialogs.dart
│
├── services/                      # Service Layer
│   ├── service_locator.dart       # Dependency Injection
│   └── notification_service.dart  # Notification Service
│
└── main.dart                      # App Entry Point
```

## Setup & Konfigurasi

### Prerequisites

- Flutter SDK (v3.11.3 atau lebih)
- Dart SDK
- IDE: Android Studio, VS Code, atau IntelliJ
- Android Emulator atau Physical Device

### 1. Clone & Install Dependencies

```bash
cd flutter_application_1
flutter pub get
```

### 2. Firebase Setup

#### 2.1 Buat Firebase Project

1. Buka [Firebase Console](https://console.firebase.google.com)
2. Klik "Create Project" atau "Add Project"
3. Masukkan nama project: `flutter-service-schedule`
4. Enable Google Analytics (optional)
5. Klik "Create"

#### 2.2 Setup Android

1. Di Firebase Console, klik "Add App" → Android
2. Masukkan Package Name: `com.example.flutter_application_1`
3. Download `google-services.json`
4. Copy ke: `android/app/google-services.json`
5. Ikuti instruksi Firebase untuk setup Gradle

#### 2.3 Setup iOS

1. Di Firebase Console, klik "Add App" → iOS
2. Masukkan Bundle ID: `com.example.flutterApplication1`
3. Download `GoogleService-Info.plist`
4. Buka Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
5. Drag `GoogleService-Info.plist` ke `Runner` folder
6. Pastikan "Copy items if needed" checked

### 3. Firestore Database Setup

1. Di Firebase Console → Firestore Database
2. Klik "Create Database"
3. Pilih region terdekat (contoh: `asia-southeast2`)
4. Pilih "Start in test mode" (untuk development)
5. Klik "Enable"

#### Firestore Rules (Development)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /vehicles/{vehicleId} {
        allow read, write: if request.auth.uid == userId;
        
        match /schedules/{scheduleId} {
          allow read, write: if request.auth.uid == userId;
        }
        
        match /history/{historyId} {
          allow read, write: if request.auth.uid == userId;
        }
      }
    }
  }
}
```

### 4. Firebase Authentication Setup

1. Di Firebase Console → Authentication
2. Klik "Get Started"
3. Enable providers:
   - **Email/Password**: Enable di "Sign-in method"
   - **Google Sign-In**: 
     - Enable di "Sign-in method"
     - Untuk Android: SHA-1 fingerprint (dapatkan dari `./gradlew signingReport`)
     - Untuk iOS: Pastikan OAuth consent screen sudah configured

### 5. Firebase Cloud Messaging (FCM)

1. Di Firebase Console → Cloud Messaging
2. Configure default notification channel untuk Android
3. Topics optional (for broadcast notifications)

### 6. Build & Run

```bash
# Run di debug mode
flutter run

# Run dengan specific device
flutter run -d <device-id>

# Build APK (Android)
flutter build apk --release

# Build AAB (Play Store)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

## Cara Penggunaan

### 1. Login / Registrasi

```
- Klik "Belum punya akun? Daftar di sini" untuk registrasi baru
- Masukkan Email, Password, Nama, dan Konfirmasi Password
- Atau login dengan Google
```

### 2. Tambah Kendaraan

```
- Di Home Page, klik FAB "Tambah Kendaraan"
- Masukkan: Nama, Nopol, KM Saat Ini
- Klik "Tambah"
```

### 3. Kelola Jadwal Servis

```
- Klik salah satu kendaraan
- Klik FAB "+" untuk tambah jadwal
- Pilih tipe servis (Ganti Oli / Servis Rutin)
- Masukkan tanggal terakhir servis
- Isi interval waktu (hari) dan/atau jarak (km)
- Klik "Tambah"
```

### 4. Catat Riwayat Servis

```
- Di Vehicle Detail, buka tab "Riwayat"
- Klik FAB "+" untuk catat servis baru
- Masukkan: Tanggal, Tipe, Biaya, Catatan
- Klik "Tambah"
```

### 5. Lihat Status Servis

```
Status ditampilkan di kartu jadwal:
- 🟢 Aman: Servis tidak urgentkan
- 🟠 Segera Hadir: Servis 7 hari lagi atau 500 km lagi
- 🔴 Terlambat: Sudah lewat dari jadwal
```

## Notifikasi

Aplikasi akan mengirim notifikasi ketika:

1. **Time-based**: Tanggal servis sudah tiba atau terlewat
2. **KM-based**: Jarak tempuh mencapai interval yang ditentukan

Setup FCM untuk push notifications:
```
- Setiap kali app buka, FCM token otomatis didaftarkan
- Notifikasi akan dicetak sesuai jadwal
```

## Troubleshooting

### Firebase Connection Error
```
- Pastikan google-services.json / GoogleService-Info.plist sudah di place yang benar
- Pastikan paket name dan bundle ID sesuai dengan Firebase project
- Coba: flutter clean && flutter pub get
```

### Authentication Failed
```
- Pastikan email belum terdaftar (untuk signup)
- Pastikan email dan password benar (untuk login)
- Pastikan Google Sign-In sudah dikonfigurasi dengan SHA-1 Android
```

### Notifications Not Working
```
- Pastikan app memiliki permission untuk notification (Android 13+)
- Pastika FCM dependencies sudah updated: flutter pub upgrade
- Check notification logs di Flutter console
```

### Build Error
```
- flutter clean
- flutter pub get
- flutter pub upgrade
```

## Environment Variables (Optional)

Buat file `.env` untuk konfigurasi:

```
FIREBASE_PROJECT_ID=flutter-service-schedule
FIREBASE_MESSAGING_SENDER_ID=<sender-id>
```

## Production Checklist

Sebelum deploy ke Play Store:

- [ ] Ganti package name ke unique name
- [ ] Update app icon dan splash screen
- [ ] Setup signing key untuk Android
- [ ] Enable production Firestore rules
- [ ] Enable rate limiting untuk API
- [ ] Setup error reporting (Crashlytics)
- [ ] Test di physical device
- [ ] Setup app versioning dan naming

## License

MIT License

## Support & Kontak

Untuk bug report atau feature request, hubungi developer.

---

**Latest Update**: Maret 2026
**Version**: 1.0.0
