import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  String _selectedCity = 'Hà Nội';
  late Future<WeatherModel> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeatherForCity(_selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chọn thành phố:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedCity,
                  items: WeatherService.cities.keys.map((String city) {
                    return DropdownMenuItem<String>(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (String? newCity) {
                    if (newCity != null) {
                      _selectedCity = newCity;
                      _loadWeather();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<WeatherModel>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  // 1. Trạng thái Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Đang tải dữ liệu thời tiết...'),
                        ],
                      ),
                    );
                  }

                  // 2. Trạng thái Error + Nút Retry
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 60),
                          const SizedBox(height: 12),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadWeather,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại (Retry)'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Không có dữ liệu thời tiết.'));
                  }

                  // 4. Trạng thái Thành công (Data Display)
                  final weather = snapshot.data!;
                  return ListView(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(weather.cityName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text('${weather.temperature}°C', style: const TextStyle(fontSize: 48, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text('Tốc độ gió: ${weather.windSpeed} km/h', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.amber.shade50,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.lightbulb, color: Colors.orange, size: 36),
                          title: const Text('Gợi ý hôm nay', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(weather.recommendation, style: const TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}