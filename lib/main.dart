import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/router/router.dart';
import 'package:weather_app/weather/data/repository/weather_repo_impl.dart';
import 'package:weather_app/weather/presentation/bloc/user_location_cubit/current_weather_cubit.dart';
import 'package:weather_app/weather/presentation/bloc/weathet_cubit/weather_cubit.dart';

import 'weather/data/data_source/weather_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              WeatherCubit(WeatherRepoImpl(WeatherDataSource(Dio()))),
        ),
        BlocProvider(
          create: (context) =>
              CurrentWeatherCubit(WeatherRepoImpl(WeatherDataSource(Dio()))),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            routerConfig: _appRouter.config(),
            themeMode: ThemeMode.light,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                background: Colors.white,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
