import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String?> getCityFromLocation() async {
    try {
   
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled)
       {
        print("Location service is disabled.");
        return null;
      }

     
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) 
      {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) 
        {
          print("Location permission denied.");
          return null;
        }
      }

   
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
         accuracy: LocationAccuracy.high,
         ),
      );

      print("Got position: lat=${position.latitude}, long=${position.longitude}");

      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty)
       {
        String city = placemarks.first.locality ?? "";
        print("Detected city: $city");
        return city;
      }

      print("No placemarks found.");
      return null;
    }
     catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
