import 'package:dio/dio.dart';
import 'package:weather_app/core/exception/api_exception.dart';

extension DioErrorX on DioError {
  ApiException get toApiException {
    switch (type) {
      case DioErrorType.badResponse:
        final statusCode = response?.statusCode;
        if (statusCode == 200) {
          final error = response?.data as Map<String, dynamic>;
          return ApiException.errorFromBacked(message: error.toString());
        }
        return ApiException.serverException(
            message:
                'we are unable to process your request. Please try again later.');

      case DioErrorType.connectionTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
      case DioErrorType.connectionError:
        return ApiException.networkError();

      case DioErrorType.unknown:
        // TODO: Handle this case.
        break;
    }
    return ApiException.networkError();
  }
}

extension StringX on String {
  int get parseToInt => int.parse(this);
}
