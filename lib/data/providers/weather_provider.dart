import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_ID.dart';

class WeatherProvider {
  Future<Map<String, dynamic>> getJsonWeather(
      {required lat, required lon}) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=33.51&lon=36.27&appid=$app_ID&units=metric');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('error while connecting to server');
    }
    return json.decode(response.body);
  }
}
