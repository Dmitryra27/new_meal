import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetApiKeyWeb {
  Future<String> read() async {
    await dotenv.load(fileName: ".env");
    String apiKeyWeb =  dotenv.env['APIKEYWEB'] ?? '';
    return apiKeyWeb;
  }


}

