
import 'package:cab_rider/datamodels/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


String mapKey = 'AIzaSyA_FFj58_p33Oy-PGffn7ACD84BI7HmSkE';


final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

User currentFirebaseUser;
UserModel currentUserInfo;