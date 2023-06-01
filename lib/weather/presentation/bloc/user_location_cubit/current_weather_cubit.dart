import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/weather/data/models/weather_model.dart';
import 'package:weather_app/weather/data/repository/weather_repo_impl.dart';

part 'current_weather_cubit.freezed.dart';
part 'current_weather_state.dart';

class CurrentWeatherCubit extends Cubit<CurrentWeatherState> {
  CurrentWeatherCubit(this._weatherRepo)
      : super(const CurrentWeatherState.initial());
  late final WeatherRepoImpl _weatherRepo;

  void getWeatherFromLatLng() {
    _weatherRepo.getCurrentLocation().then((userLocation) async {
      final data = await _weatherRepo.getWeatherFromLatLng(
          lat: userLocation.latitude, long: userLocation.longitude);
      data.fold(
        (error) => emit(CurrentWeatherState.error(error.toString())),
        (fetchedData) => emit(
          CurrentWeatherState.fetched(weatherModel: fetchedData),
        ),
      );
    });
  }
}
