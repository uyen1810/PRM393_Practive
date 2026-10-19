import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const Map<String, Map<String, double>> cities = {
    'Hà Nội': {'lat': 21.0285, 'lon': 105.8542},
    'Đà Nẵng': {'lat': 16.0544, 'lon': 108.2022},
    'TP. Hồ Chí Minh': {'lat': 10.8231, 'lon': 106.6297},
    'Tokyo': {'lat': 35.6762, 'lon': 139.6503},
  };

  Future<WeatherModel> fetchWeatherForCity(String cityName) async {
    final coords = cities[cityName] ?? cities['Hà Nội']!;
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${coords['lat']}&longitude=${coords['lon']}&current_weather=true',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data, cityName);
      } else {
        throw Exception('Lỗi máy chủ: Mã lỗi ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối đến API. Vui lòng kiểm tra mạng! ($e)');
    }
  }
}