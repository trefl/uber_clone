import 'dart:async';

import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/dataproviders/appdata.dart';
import 'package:cab_rider/helpers/helpermethods.dart';
import 'package:cab_rider/screens/searchpage.dart';
import 'package:cab_rider/styles/styles.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  static const String id='mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  var geoLocator = Geolocator();
  Position currentPosition;

  void setupPositionLocator() async {

    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address = await HelperMethods.findCordinateAddress(position, context);
    print(address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/user_icon.png', height: 60, width: 60,),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Kierowca', style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),),
                          SizedBox(height: 5,),
                          Text('View Profile'),
                        ],
                      )

                    ],
                  ),

                  ),
              ),
              BrandDivider(),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text('Darmowe przejazdy', style: kDrawerItemStyle,),
              ),
              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text('Płatności', style: kDrawerItemStyle,),
              ),
              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Historia', style: kDrawerItemStyle,),
              ),
              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text('Wsparcie', style: kDrawerItemStyle,),
              ),
              ListTile(
                leading: Icon(OMIcons.info),
                title: Text('Informacja', style: kDrawerItemStyle,),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),

            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              setState((){
                mapBottomPadding = 300;

              });
              setupPositionLocator();


            },
          ),

          Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(
                        0.7,
                        0.7,
                      )
                    )
                  ]

                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.menu, color: Colors.black87,),

                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
              color:Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    )

                  )
                ]
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Text('Miło Cię widzieć!', style: TextStyle(fontSize: 10),),
                    Text('Dokąd chcesz jechać?', style: TextStyle(fontSize: 18, fontFamily: 'Brand-bold'),),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SearchPage()
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(
                                0.7,
                                0.7,
                              )
                            )
                          ]

                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search, color: Colors.blueAccent,),
                              SizedBox(width: 10,),
                              Text('Szukaj miejsca docelowego'),
                            ],
                          ),
                        )
                      ),
                    ),
                    SizedBox(height: 22,),
                    Row(
                      children: <Widget>[
                        Icon(OMIcons.home, color: BrandColors.colorDimText,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          children: <Widget>[
                            Text('+ DOM'),
                            SizedBox(height: 3,),
                            Text('Twój adres domowy',
                            style: TextStyle(fontSize: 11, color: BrandColors.colorDimText,),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    BrandDivider(),
                    SizedBox(height: 16,),
                    Row(
                      children: <Widget>[
                        Icon(OMIcons.workOutline, color: BrandColors.colorDimText,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          children: <Widget>[
                            Text('+ PRACA'),
                            SizedBox(height: 3,),
                            Text('Twoje miejsce pracy',
                              style: TextStyle(fontSize: 11, color: BrandColors.colorDimText,),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
          ),
        ]
      )
    );
  }
}
