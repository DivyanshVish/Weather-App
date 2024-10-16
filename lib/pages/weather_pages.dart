// ignore_for_file: unused_element, unused_field, constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/service/weather_services.dart';

class WeatherPages extends StatefulWidget {
  const WeatherPages({super.key});

  @override
  State<WeatherPages> createState() => _WeatherPagesState();
}

class _WeatherPagesState extends State<WeatherPages> {
  /* --------------------------------- API Key -------------------------------- */
  final _weatherServices = WeatherServices('7e9c7b1b72d634366b63067607140bbf');
  Weather? _weather;

  /* ------------------------------ Fetch Weather ----------------------------- */
  _fetchWeather() async {
    /* ------------------------------ Get City Name ----------------------------- */
    String cityName = await _weatherServices.getCurrentCity();

    /* -------------------------- Get Weather for City -------------------------- */
    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  /* ---------------------------- Weather Animation --------------------------- */
  String getweatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'showers rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  /* --------------------- Initial State to start the app --------------------- */
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  static const IconData location_on =
      IconData(0xe3ab, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Icon(location_on, size: 50, color: Colors.grey),
                /* -------------------------------- CityName -------------------------------- */
                Text(_weather?.cityName ?? 'Loading City...'),
              ],
            ),

            /* ------------------------------- Animation ------------------------------ */
            Lottie.asset(getweatherAnimation(_weather?.maincondition)),
            // const SizedBox(
            //   height: 200,
            // ),
            /* ------------------------------- Temperature ------------------------------ */
            Text(
              '${_weather?.temperature.round()}°C',
            ),
          ],
        ),
      ),
    );
  }
}
