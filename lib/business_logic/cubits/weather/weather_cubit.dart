import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/utilities/localstorage.dart';
import '../weather/weather_states.dart';

class WeatherCubit extends Cubit<WeatherState> {
  static WeatherCubit get(BuildContext context) =>
      BlocProvider.of<WeatherCubit>(context);
  WeatherCubit() : super(WeatherInitialState());

  Weather weather = !LocalStorage.containKey('weather')
      ? Weather(
          temp: 0,
          feelsLike: 0,
          humidity: 0,
          mainStatus: 'normal',
          windSpeed: 0,
          city: 'N/A',
        )
      : Weather(
          mainStatus: LocalStorage.getData('weather')['main Status'],
          temp: LocalStorage.getData('weather')['temp'],
          feelsLike: LocalStorage.getData('weather')['feelsLike'],
          humidity: LocalStorage.getData('weather')['humidity'],
          windSpeed: LocalStorage.getData('weather')['windSpeed'],
          city: LocalStorage.getData('weather')['city']);
  void emitLoadingState() {
    emit(WeatherLoadingState());
  }

  Future<void> getWeather({required lat, required lon}) async {
    final _weatherRepository = WeatherRepository();
    final _weather = await _weatherRepository.getWeather(lat: lat, lon: lon);
    weather = _weather;
    LocalStorage.saveData('weather', {
      'temp': _weather.temp,
      'feelsLike': _weather.feelsLike,
      'humidity': _weather.humidity,
      'main Status': _weather.mainStatus,
      'windSpeed': _weather.windSpeed,
      'city': _weather.city
    });
    emit(WeatherUpdatedState());
  }
}
