import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart' as di;

import 'app/app_router.dart';
import 'features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow all orientations initially (portrait for auth, landscape for game)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await di.init(); // userBox is opened inside service_locator

  runApp(const AppRouter());
}
