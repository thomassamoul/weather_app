import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weather_app/core/router/router.gr.dart';
import 'package:weather_app/generated/assets.dart';
import 'package:weather_app/weather/presentation/bloc/user_location_cubit/current_weather_cubit.dart';

@RoutePage()
class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<CurrentWeatherCubit>().getWeatherFromLatLng();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: BlocBuilder<CurrentWeatherCubit, CurrentWeatherState>(
                builder: (context, state) {
                  return state.maybeWhen(orElse: () {
                    return const Center(
                        child: SpinKitDoubleBounce(
                      color: Colors.blue,
                    ));
                  }, fetched: (weatherModel) {
                    final tempData =
                        weatherModel.main!.temp!.round() - 273.15.round();
                    final maxTemp =
                        weatherModel.main!.tempMax!.round() - 273.15.round();
                    final feelsLike =
                        weatherModel.main!.feelsLike!.round() - 273.15.round();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Image.asset(
                              Assets.imagesWeee,
                              height: 65.h,
                              width: 100.w,
                              scale: 1.3,
                              fit: BoxFit.fill,
                            ),
                            Text(
                              'Weather App',
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    context.router
                                        .push(SearchedRoute(searchTerm: value));
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  fillColor: Colors.white70,
                                  hintText: 'Search',
                                  hintStyle:
                                      const TextStyle(color: Colors.blue),
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Colors.blue),
                                    onPressed: () {},
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: weatherModel.weather!.length,
                          itemBuilder: (context, index) {
                            final data = weatherModel.weather![index];
                            return Column(
                              children: [
                                Image.network(
                                    "http://openweathermap.org/img/w/${data.icon}.png"
                                        .toString(),
                                    fit: BoxFit.fill),
                                Text(
                                  data.description.toString(),
                                  style: TextStyle(
                                      fontSize: 20.sp, color: Colors.black),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(weatherModel.name.toString(),
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.orange)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${tempData.toString()} °C',
                                style: TextStyle(
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green)),
                            SizedBox(width: 10.w),
                            Text('Feels Like:$feelsLike°C ',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey)),
                          ],
                        ),
                        Text(
                          'Max Temperature $maxTemp',
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Wind',
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.lightBlue)),
                            ),
                            Card(
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.air,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          '${weatherModel.wind!.speed.toString()} Speed Km/hr'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Barometer',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.lightBlue)),
                            ),
                            Card(
                              color: Colors.white70,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        LineIcons.highTemperature,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          'Temperature: ${tempData.toString()} °C'),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        LineIcons.draftingCompass,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          'Humidity: ${weatherModel.main!.humidity}%'),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        LineIcons.lowVision,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          'Visibility: ${weatherModel.visibility}'),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.push_pin,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          'Pressure: ${weatherModel.main!.pressure} hpa'),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        LineIcons.cloud,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                          'Clouds Covered: ${weatherModel.clouds!.all}%'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
