class Weather {
  String? mainStatus;
  double? temp;
  double? feelsLike;
  int? humidity;
  double? windSpeed;
  String? city;

  Weather(
      {required this.mainStatus,
      required this.temp,
      required this.feelsLike,
      required this.humidity,
      required this.windSpeed,
      this.city});

  Weather.fromJson(Map<String, dynamic> json) {
    mainStatus = json['weather'][0]['main'];
    temp = json['main']['temp'];
    feelsLike = json['main']['feels_like'];
    humidity = json['main']['humidity'];
    windSpeed = json['wind']['speed'];
    city = json['name'];
  }
}
