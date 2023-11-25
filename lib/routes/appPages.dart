import 'package:get/get.dart';
import 'package:movieapp/routes/appRoutes.dart';
import 'package:movieapp/screens/detailScreen.dart';
import 'package:movieapp/screens/homescreen/homescreen.dart';
import 'package:movieapp/screens/searchScreen.dart';
import 'package:movieapp/screens/splashScreen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen()),
    GetPage(name: AppRoutes.detailScreen, page: () => DetailScreen()),
    GetPage(name: AppRoutes.searchScreen, page: () => SearchScreen()),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
  ];
}
