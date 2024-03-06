import 'package:get/get.dart';
import 'package:newsapp/Views/HomePage/main_home_page.dart';
import 'package:newsapp/Views/Login_SIgnup/social_login.dart';
import 'package:newsapp/Views/Splash_%20screen/splash_screen.dart';


abstract class Routes{
  static const SPLASHSCREEN = '/splash_screen';
  static const LOGIN = '/login';
  static const MAINHOMEPAGE = '/main_home_page';

}

abstract class AppPages{
  static final pages =  [
     GetPage(name: Routes.SPLASHSCREEN, page: () => SplashScreen(),transition: Transition.fadeIn),
     GetPage(name: Routes.LOGIN, page: () => SocialMediaLoginScreen(),transition: Transition.fadeIn),
     GetPage(name: Routes.MAINHOMEPAGE, page: () => MainHomePageView(),transition: Transition.fadeIn),
  
  ];
}