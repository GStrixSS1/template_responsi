import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/movie_controller.dart';
import 'controllers/schedule_controller.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';
import 'views/auth/login_view.dart';
import 'views/home/main_nav_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(AuthService.userBoxName);
  await AuthService.seedDefaultUserIfEmpty();

  final isUserLoggedIn = await AuthService.isUserLoggedIn();

  runApp(CinemaApp(isLoggedIn: isUserLoggedIn));
}

class CinemaApp extends StatelessWidget {
  final bool isLoggedIn;

  const CinemaApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(FavoriteController());
    Get.put(MovieController());
    Get.put(ScheduleController());

    return GetMaterialApp(
      title: 'Cinema XXI Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const MainNavView() : const LoginView(),
    );
  }
}

