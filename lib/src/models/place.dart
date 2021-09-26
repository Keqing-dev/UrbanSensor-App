import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class Place with ClusterItem {
  final String id;
  final LatLng latLng;
  final String categories;
  final String address;
  final String timestamp;
  final String? observations;
  final String file;

  Place({
    required this.id,
    required this.latLng,
    required this.categories,
    required this.timestamp,
    required this.observations,
    required this.address,
    required this.file,
  });

  @override
  LatLng get location => latLng;
}
