import 'package:cab_rider/datamodels/address.dart';
import 'package:cab_rider/datamodels/directiondetails.dart';
import 'package:cab_rider/dataproviders/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/helpers/requesthelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodePoints = response['routes'][0]['overview_polyline']['points'];

    return directionDetails;

  }
  static int estimateFares (DirectionDetails details){
    //za km = 0.3 PLN
    //za min 0.2 PLN
    //Podstawa = 3 PLN

    double baseFare = 3;
    double distanceFare = (details.distanceValue/1000) * 0.3;
    double timeFare = (details.durationValue/60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }
}
