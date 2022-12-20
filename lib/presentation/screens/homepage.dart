import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/business_logic/cubits/weather/weather_cubit.dart';
import 'package:weather_app/business_logic/cubits/weather/weather_states.dart';
import 'package:weather_app/presentation/widgets/custom_snackbar.dart';
import 'package:weather_app/presentation/widgets/loading_arrows.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Future<Position> _determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permission denied for ever we can\'t get your weather information'),
        behavior: SnackBarBehavior.floating,
      ));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permission denied'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permission denied for ever we can\'t get your weather information'),
        behavior: SnackBarBehavior.floating,
      ));
    }
    return await Geolocator.getCurrentPosition();
  }

  bool _isInit = false;
  late Position position;
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final _animation = Tween(begin: 0.0, end: 1.0).animate(_controller!);
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      return;
    }
    position = await _determinePosition(context);
    try {
      WeatherCubit.get(context).emitLoadingState();
      await WeatherCubit.get(context)
          .getWeather(lat: position.latitude, lon: position.longitude);
      _isInit = true;
    } catch (e) {
      customSnackBar(context: context, content: e.toString());
    }
    super.didChangeDependencies();
  }

  final Map<String, IconData> weatherIcons = {
    'Clouds': Meteocons.clouds_inv,
    'Clear': Meteocons.sun_inv,
    'Tornado': Meteocons.wind,
    'Squall': Meteocons.cloud_flash,
    'Ash': Meteocons.mist,
    'Dust': Meteocons.mist,
    'Sand': Meteocons.fog,
    'Fog': Meteocons.mist,
    'Haze': Meteocons.clouds_inv,
    'Smoke': Meteocons.fog,
    'Mist': Meteocons.mist,
    'Snow': Meteocons.snow_heavy_inv,
    'Rain': Typicons.rain,
    'Drizzle': Meteocons.drizzle_inv,
    'Thunderstorm': Typicons.cloud_flash,
  };
  Stream<String> getCurrentTime() async* {
    for (int i = 0;; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateFormat.jm().format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final hour = int.parse(DateFormat('H').format(DateTime.now()));
    return BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Stack(children: [
              SizedBox(
                  height: height,
                  width: width,
                  child: hour >= 0 && hour <= 6
                      ? Image.asset(
                          'images/night.jpg',
                          fit: BoxFit.fill,
                        )
                      : hour >= 7 && hour <= 17
                          ? Image.asset(
                              'images/day.png',
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'images/night.jpg',
                              fit: BoxFit.fill,
                            )),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: StreamBuilder(
                                    stream: getCurrentTime(),
                                    builder: (context, snapshot) =>
                                        !snapshot.hasData
                                            ? const Text(
                                                '00:00',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              )
                                            : Text(
                                                snapshot.data.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.center,
                                    )),
                                Expanded(
                                    child: (state is WeatherLoadingState)
                                        ? Container(
                                            alignment: Alignment.topRight,
                                            child: LoadingArrows(
                                              size: 35,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () async {
                                                WeatherCubit.get(context)
                                                    .emitLoadingState();
                                                final permission =
                                                    await Geolocator
                                                        .checkPermission();
                                                if (permission ==
                                                        LocationPermission
                                                            .deniedForever ||
                                                    permission ==
                                                        LocationPermission
                                                            .denied) {
                                                  customSnackBar(
                                                      context: context,
                                                      content:
                                                          'Location permession denied');
                                                } else {
                                                  await WeatherCubit.get(
                                                          context)
                                                      .getWeather(
                                                          lat:
                                                              position.latitude,
                                                          lon: position
                                                              .longitude);
                                                }
                                              },
                                              child: const Icon(
                                                FontAwesome.arrows_cw,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                              ])),
                      Expanded(
                          flex: 12,
                          child: FadeTransition(
                            opacity: _controller!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  WeatherCubit.get(context).weather.city!,
                                  style: TextStyle(
                                      fontSize: width * 0.1,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('EEEE, MMMM, yyyy')
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                      fontSize: width * 0.06,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${WeatherCubit.get(context).weather.temp!.toInt()}\u00b0',
                                          style: TextStyle(
                                              fontSize: width * 0.3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'feels like: ${WeatherCubit.get(context).weather.feelsLike!.toInt()}\u00b0',
                                      style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    )
                                  ],
                                ),
                                Icon(
                                  weatherIcons[WeatherCubit.get(context)
                                      .weather
                                      .mainStatus!],
                                  color: Colors.white,
                                  size: width * 0.15,
                                ),
                                Text(
                                  WeatherCubit.get(context).weather.mainStatus!,
                                  style: TextStyle(
                                      fontSize: width * 0.1,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: height * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.wind_power_outlined,
                                          color: Colors.white,
                                          size: width * 0.15,
                                        ),
                                        Text(
                                          '${WeatherCubit.get(context).weather.windSpeed.toString()} km',
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.water_drop,
                                          color: Colors.white,
                                          size: width * 0.15,
                                        ),
                                        Text(
                                          '${WeatherCubit.get(context).weather.humidity} %',
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ]),
          );
        });
  }
}
