import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  
  Weather? _currentWeather;
  List<Forecast> _forecast = [];
  List<Weather> _multiCityWeather = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  Weather? get currentWeather => _currentWeather;
  List<Forecast> get forecast => _forecast;
  List<Weather> get multiCityWeather => _multiCityWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WeatherProvider() {
    _loadCachedData();
    getCurrentWeather();
  }

  void _loadCachedData() {
    _currentWeather = _storageService.getCachedWeather();
    notifyListeners();
  }

  Future<void> getCurrentWeather() async {
    _setLoading(true);
    _error = null;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _currentWeather = _storageService.getCachedWeather();
        if (_currentWeather == null) {
          throw Exception('No internet connection and no cached data');
        }
      } else {
        _currentWeather = await _weatherService.getCurrentWeather();
        await _storageService.saveWeather(_currentWeather!);
        
        // Get forecast for current location
        await getForecast(_currentWeather!.lat, _currentWeather!.lon);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getForecast(double lat, double lon) async {
    try {
      _forecast = await _weatherService.getForecast(lat, lon);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> addCityWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeatherByCity(cityName);
      _multiCityWeather.add(weather);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  void removeCityWeather(int index) {
    _multiCityWeather.removeAt(index);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}