import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/base/base_data_source.dart';
import 'package:weather_app/weather/data/models/weather_model.dart';

@lazySingleton
class WeatherDataSource extends BaseRemoteSource {
  WeatherDataSource(this._dioClient);

  late final Dio _dioClient;

  Future<WeatherModel> getWeather({required String city}) async {
    return networkHandler(
        onResponse: (data) => WeatherModel.fromJson(data),
        request: (Dio dio) => _dioClient.get(
            'https://api.openweathermap.org/data/2.5/weather?APPID=faab8fc391cfd4166e4df298d171a1f7&units=metric&q=$city&lang=en'));
  }

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    return networkHandler(
        onResponse: (data) => WeatherModel.fromJson(data),
        request: (Dio dio) => _dioClient.get(
            'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=faab8fc391cfd4166e4df298d171a1f7'));
  }
}
