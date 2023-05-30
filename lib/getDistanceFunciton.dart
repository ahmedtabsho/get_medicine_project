// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;


Future<int> getDistance(String firstLocation, String secondLocation) async{

  final firstCoordinates = await getCoordinates(firstLocation);
  final secondCoordinates = await getCoordinates(secondLocation);
  final double distance; // bu değişkeni kullanacağız

  if (firstCoordinates != null && secondCoordinates != null) {
    distance = await calculateDistance(firstCoordinates, secondCoordinates);
    return distance.toInt();
  } else {
    return -1;
  }

}


Future<List<double>?> getCoordinates(String address) async {
  final encodedAddress = Uri.encodeComponent(address);
  const apiKey = "5b3ce3597851110001cf62481bf4aa67caa64a0a899873e99b2d2dc0";
  final url = "https://api.openrouteservice.org/geocode/search?api_key=$apiKey&text=$encodedAddress";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final features = data['features'];
    if (features != null && features is List && features.isNotEmpty) {
      final geometry = features[0]['geometry'];
      final latitude = geometry['coordinates'][1];
      final longitude = geometry['coordinates'][0];
      if (latitude != null && longitude != null) {
        return [latitude, longitude];
      }
    }
  }

  return null;
}

Future<double> calculateDistance(List<double> firstCoordinates, List<double> secondCoordinates) async {
  final firstLatitude = firstCoordinates[0];
  final firstLongitude = firstCoordinates[1];
  final secondLatitude = secondCoordinates[0];
  final secondLongitude = secondCoordinates[1];

  const apiKey = "5b3ce3597851110001cf62481bf4aa67caa64a0a899873e99b2d2dc0";
  final url = "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$firstLongitude,$firstLatitude&end=$secondLongitude,$secondLatitude";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final distance = data['features'][0]['properties']['summary']['distance'];
    return distance.toDouble();
  }

  return 0;
}


