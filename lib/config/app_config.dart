import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Get Web Client ID from environment variable or use fallback
  static String? get googleWebClientId {
    return dotenv.env['GOOGLE_WEB_CLIENT_ID'];
  }
}