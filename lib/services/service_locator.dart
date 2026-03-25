import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/schedule_remote_datasource.dart';
import '../data/datasources/service_history_remote_datasource.dart';
import '../data/datasources/vehicle_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/schedule_repository_impl.dart';
import '../data/repositories/service_history_repository_impl.dart';
import '../data/repositories/vehicle_repository_impl.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/schedule_repository.dart';
import '../core/repositories/service_history_repository.dart';
import '../core/repositories/vehicle_repository.dart';
import '../firebase_options.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  static bool _firebaseInitialized = false;

  static GetIt get instance => _getIt;
  static bool get firebaseInitialized => _firebaseInitialized;

  static Future<void> setup() async {
    try {
      // Firebase Initialization with platform-specific options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firebaseInitialized = true;
      print('✅ Firebase initialized successfully');

      // Firebase Services
      _getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
      _getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
      _getIt.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
      
      // GoogleSignIn - try to initialize, may fail on web without proper configuration
      GoogleSignIn? googleSignIn;
      try {
        googleSignIn = GoogleSignIn();
        // Try to initialize
        await googleSignIn.signOut();
      } catch (e) {
        print('⚠️ GoogleSignIn not available (web without client_id): $e');
        // Create a stub GoogleSignIn for web
        googleSignIn = GoogleSignIn();
      }
      _getIt.registerSingleton<GoogleSignIn>(googleSignIn);

      // Data Sources
      _getIt.registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImpl(
          firebaseAuth: _getIt<FirebaseAuth>(),
          googleSignIn: _getIt<GoogleSignIn>(),
        ),
      );

      _getIt.registerSingleton<VehicleRemoteDataSource>(
        VehicleRemoteDataSourceImpl(firestore: _getIt<FirebaseFirestore>()),
      );

      _getIt.registerSingleton<ScheduleRemoteDataSource>(
        ScheduleRemoteDataSourceImpl(firestore: _getIt<FirebaseFirestore>()),
      );

      _getIt.registerSingleton<ServiceHistoryRemoteDataSource>(
        ServiceHistoryRemoteDataSourceImpl(
          firestore: _getIt<FirebaseFirestore>(),
        ),
      );

      // Repositories
      _getIt.registerSingleton<AuthRepository>(
        AuthRepositoryImpl(
          authRemoteDataSource: _getIt<AuthRemoteDataSource>(),
        ),
      );

      _getIt.registerSingleton<VehicleRepository>(
        VehicleRepositoryImpl(
          vehicleRemoteDataSource: _getIt<VehicleRemoteDataSource>(),
        ),
      );

      _getIt.registerSingleton<ScheduleRepository>(
        ScheduleRepositoryImpl(
          scheduleRemoteDataSource: _getIt<ScheduleRemoteDataSource>(),
        ),
      );

      _getIt.registerSingleton<ServiceHistoryRepository>(
        ServiceHistoryRepositoryImpl(
          serviceHistoryRemoteDataSource:
              _getIt<ServiceHistoryRemoteDataSource>(),
        ),
      );
    } catch (e) {
      _firebaseInitialized = false;
      print('⚠️ Firebase initialization failed: $e');
      print('App will display setup instructions.');
    }
  }
}
