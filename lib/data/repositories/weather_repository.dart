import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/providers/weather_provider.dart';

class WeatherRepository {
  final weatherProvider = WeatherProvider();

  Future<Weather> getWeather({required lat, required lon}) async {
    final jsonWeather;
    try {
      jsonWeather = await weatherProvider.getJsonWeather(lat: lat, lon: lon);
    } catch (e) {
      rethrow;
    }
    final Weather weather = Weather.fromJson(jsonWeather);
    return weather;
  }
}
