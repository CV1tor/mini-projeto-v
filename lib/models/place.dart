import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
        latitude: json['latitude'], longitude: json['longitude']);
  }
}

class Place {
  final String id;
  final String title;
  final PlaceLocation? location;
  final File image;

  Place({
    required this.id,
    required this.title,
    this.location,
    required this.image,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final image = File(json['image']);
    
    return Place(
      id: json['id'],
      title: json['title'],
      image: image,
    );
  }
}
