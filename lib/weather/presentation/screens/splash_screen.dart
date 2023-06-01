import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/core/router/router.gr.dart';
import 'package:weather_app/generated/assets.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome\n to weather App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LottieBuilder.asset(
                Assets.lottieWeather,
                onLoaded: (p0) {
                  Future.delayed(const Duration(seconds: 3), () {
                    context.router.replace(const WeatherHomeRoute());
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
