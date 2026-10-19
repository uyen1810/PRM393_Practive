class WeatherModel {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current_weather'];
    return WeatherModel(
      cityName: city,
      temperature: (current['temperature'] as num).toDouble(),
      windSpeed: (current['windspeed'] as num).toDouble(),
      weatherCode: current['weathercode'] as int,
    );
  }

  String get recommendation {
    if (weatherCode >= 51) {
      return "☔ Trời có mưa! Bạn nhớ mang theo ô hoặc áo mưa khi ra ngoài nhé.";
    } else if (temperature > 33) {
      return "🥵 Trời khá nóng (${temperature}°C). Hạn chế hoạt động mạnh ngoài trời và nhớ uống nhiều nước!";
    } else if (temperature < 18) {
      return "🧥 Trời lạnh (${temperature}°C). Hãy mặc thêm áo ấm trước khi ra đường.";
    } else {
      return "🌤️ Thời tiết rất đẹp và dễ chịu! Cực kỳ lý tưởng để đi dạo hoặc hoạt động ngoài trời.";
    }
  }
}