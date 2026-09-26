import 'package:new_strucuture/app_bloc_observer.dart';
import 'package:new_strucuture/core/notification_services/notification_service.dart';
import 'package:new_strucuture/core/utils/system_ui.dart';
import 'package:new_strucuture/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_strucuture/injector.dart' as injector;
import '../preferences/preferences.dart';

bool isFirebaseInitialized = false;

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseConfigured = false;
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.apiKey.isNotEmpty && options.appId.isNotEmpty) {
      isFirebaseConfigured = true;
    }
  } catch (e) {
    debugPrint("Firebase options are not fully configured: $e");
  }

  if (isFirebaseConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isFirebaseInitialized = true;
    } catch (e) {
      debugPrint("Error initializing Firebase: $e");
    }
  } else {
    debugPrint("Firebase is not configured or setup. Skipping initialization.");
  }

  NotificationService notificationService = NotificationService();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  AndroidOptions getAndroidOptions() => const AndroidOptions();
  IOSOptions getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  prefs = await SharedPreferences.getInstance();
  SystemUiStyle.overlayStyle();
  secureStorage = FlutterSecureStorage(
    aOptions: getAndroidOptions(),
    iOptions: getIOSOptions(),
  );
  await notificationService.initialize();

  await injector.setupDependencies();
  injector.registerCubits();
  injector.registerRepositories();
  Bloc.observer = AppBlocObserver();
}
