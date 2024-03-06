enum Flavor {DEV, PROD,NEWPROD}


class Config {
  static Flavor? appFlavor;
  static String get baseUrlLogin {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'https://newsapi.org/v2/';
      default:
        return 'https://newsapi.org/v2/';
    }
  }
}

String ApibaseUrl = Config.baseUrlLogin;
