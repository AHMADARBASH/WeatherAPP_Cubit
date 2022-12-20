import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/business_logic/bloc_observer.dart';
import 'package:weather_app/business_logic/cubits/weather/weather_cubit.dart';
import 'package:weather_app/presentation/screens/homepage.dart';
import 'package:weather_app/utilities/localstorage.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white))),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
