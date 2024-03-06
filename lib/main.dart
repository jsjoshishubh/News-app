import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newsapp/Https%20Request/server_config.dart';
import 'package:newsapp/Routes/routes.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';

void main() async{
  await GetStorage.init();
  Config.appFlavor = Flavor.PROD;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options:  const FirebaseOptions(
    apiKey: "AIzaSyC6JhZnxJ8yU2r0va4XhaUS-qiFya4JHLg",
    appId: "1:974981037292:android:4d181b87802084a032f9c9",
    messagingSenderId: "974981037292",
    projectId: "news-app-885d5")
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});
 final storage  = GetStorage();

renderInitialRoute() {
  bool isLoggedIn = storage.read(isLOGGEDIN) ?? false;
  if(isLoggedIn){
    return Routes.MAINHOMEPAGE;
  }else{
    return Routes.SPLASHSCREEN;
  }
}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialRoute: renderInitialRoute(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white,elevation: 0,foregroundColor: primaryColor,systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white,statusBarBrightness: Brightness.dark,statusBarIconBrightness: Brightness.dark)),
        scaffoldBackgroundColor: Colors.white
      ),
    );
    
   
  }
}
