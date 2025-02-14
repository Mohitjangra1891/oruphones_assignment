import '../utils/config.dart';

class BasePaths {
  static const baseImagePath = "assets/images";

  // static const baseProdUrl = "https://bitebitz-efchhjgfamebhsbd.centralindia-01.azurewebsites.net/api/v1";

  static const baseProdUrl = "http://40.90.224.241:5000";
  static const baseTestUrl = "http://40.90.224.241:5000";

  // static const baseTestUrl = "https://bitebitz-efchhjgfamebhsbd.centralindia-01.azurewebsites.net/api/v1";
  static const baseUrl = AppConfig.devMode ? baseTestUrl : baseProdUrl;
}
