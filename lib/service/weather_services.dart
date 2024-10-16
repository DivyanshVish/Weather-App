// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(cityName) async {
    final responce = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (responce.statusCode == 200) {
      return Weather.fromJson(jsonDecode(responce.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    /* ----------------------- Check the location permission ----------------------- */
    LocationAccuracy accuracy = LocationAccuracy.high;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    /* ----------------------- fetch the current location ----------------------- */
    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);

    /* -------------- Convert the location into a list of placemark objects ------------- */
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    /* ---------------- Extract the city name from the placemark ---------------- */
    String? cityName = placemarks[0].locality;

    return cityName ?? '';
  }
}
