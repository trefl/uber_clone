
import 'package:cab_rider/datamodels/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;

  void updatePickupAddress(Address pickup){
    pickupAddress = pickup;
    notifyListeners();

  }
}