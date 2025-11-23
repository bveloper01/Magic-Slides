import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String generatePptEndpoint = dotenv.env['END_POINT']!;

  // Replace with actual accessId in .env file
  static String accessId = dotenv.env['ACCESS_ID']!;

  static const int connectionTimeout = 60000;
  static const int receiveTimeout = 60000;
}
