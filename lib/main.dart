import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'services/service_locator.dart';
import 'services/notification_service.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/vehicle_viewmodel.dart';
import 'presentation/viewmodels/schedule_viewmodel.dart';
import 'presentation/viewmodels/service_history_viewmodel.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'core/repositories/auth_repository.dart';
import 'core/repositories/vehicle_repository.dart';
import 'core/repositories/schedule_repository.dart';
import 'core/repositories/service_history_repository.dart';

// Modern Color Scheme
class AppColors {
  static const Color primary = Color(0xFF006B8C); // Deep Teal
  static const Color primaryLight = Color(0xFF00A8CC); // Bright Teal
  static const Color primaryDark = Color(0xFF004D66); // Dark Teal
  static const Color accent = Color(0xFFFF6B35); // Vibrant Orange
  static const Color accentLight = Color(0xFFFFD700); // Golden Yellow
  static const Color background = Color(0xFFF7F9FC); // Light Blue-Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color success = Color(0xFF16A34A); // Green
  static const Color error = Color(0xFFDC2626); // Red
  static const Color textPrimary = Color(0xFF1A2B33); // Dark Grayish Blue
  static const Color textSecondary = Color(0xFF64748B); // Slate Gray
}

// Modern Theme Configuration
ThemeData buildModernTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      tertiary: AppColors.accentLight,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.poppins(color: AppColors.textPrimary),
      bodySmall: GoogleFonts.poppins(color: AppColors.textSecondary),
      labelLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w400),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent, // allow gradient backgrounds if needed
      foregroundColor: AppColors.primary,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: AppColors.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Slate 200
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      prefixIconColor: AppColors.textSecondary,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.textSecondary.withOpacity(0.7),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 6,
      splashColor: AppColors.primaryLight.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (e) {
    print('Error initializing date formatting: $e');
  }

  try {
    await ServiceLocator.setup();
  } catch (e) {
    print('Error during ServiceLocator setup: $e');
  }

  try {
    await NotificationService().initialize();
  } catch (e) {
    print('Error during NotificationService initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if Firebase is initialized
    if (!ServiceLocator.firebaseInitialized) {
      return MaterialApp(
        title: 'Service Schedule',
        theme: buildModernTheme(),
        home: const FirebaseSetupErrorPage(),
        debugShowCheckedModeBanner: false,
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            authRepository: ServiceLocator.instance<AuthRepository>(),
          )..checkCurrentUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => VehicleViewModel(
            vehicleRepository: ServiceLocator.instance<VehicleRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleViewModel(
            scheduleRepository: ServiceLocator.instance<ScheduleRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceHistoryViewModel(
            serviceHistoryRepository:
                ServiceLocator.instance<ServiceHistoryRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Service Schedule',
        theme: buildModernTheme(),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class FirebaseSetupErrorPage extends StatelessWidget {
  const FirebaseSetupErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                'Firebase Not Configured',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This app requires Firebase setup to run. Please follow the setup instructions in SETUP.md:',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Create Firebase Project at console.firebase.google.com',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2. Add Android app and download google-services.json',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '3. Place google-services.json in android/app/',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '4. Restart the app',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        if (authVM.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authVM.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      authVM.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => authVM.checkCurrentUser(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return authVM.isAuthenticated ? const HomePage() : const LoginPage();
      },
    );
  }
}
