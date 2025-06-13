import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'your api key'; // OpenWeather API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  final Dio _dio = Dio();

  // Get current user location using Geolocator
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Fetch current weather based on current location
  Future<Weather> getCurrentWeather() async {
    try {
      final position = await getCurrentLocation();
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': position.latitude,
          'lon': position.longitude,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return Weather.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch current weather: $e');
    }
  }

  // Fetch current weather based on city name
  Future<Weather> getWeatherByCity(String cityName) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/weather',
        queryParameters: {
          'q': cityName,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return Weather.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch weather for "$cityName": $e');
    }
  }

  // Fetch 5-day forecast (in 3-hour intervals)
  Future<List<Forecast>> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      final List<dynamic> forecastList = response.data['list'];
      return forecastList
          .map((json) => Forecast.fromJson(json))
          .take(40) // 5 days * 8 intervals per day (3-hourly)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch forecast: $e');
    }
  }

  // Construct weather icon URL using icon code from OpenWeatherMap
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
