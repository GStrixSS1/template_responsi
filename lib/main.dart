import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/auth_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/product_controller.dart';
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

  runApp(EcommerceApp(isLoggedIn: isUserLoggedIn));
}

class EcommerceApp extends StatelessWidget {
  final bool isLoggedIn;

  const EcommerceApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(FavoriteController());
    Get.put(ProductController());
    Get.put(CategoryController());

    return GetMaterialApp(
      title: 'ShopEase Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const MainNavView() : const LoginView(),
    );
  }
}
