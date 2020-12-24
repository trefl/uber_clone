import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {

  static const String id='register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
        content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  Future<void> registerUser() async {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Rejestrowanie',),
    );


    final User user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){
      //sprawdzanie błędu i jego wyświetlenie
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    })).user;

    Navigator.pop(context);
      //Sprawdzanie czy rejestracja przebiegła pomyślnie
    if(user != null){
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('user/${user.uid}');

      //Dane do zapisania w tabeli uzytkowników
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      //Przenieś użytkownika do mainPage
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Utwórz konto pasażera',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      //Imię i nazwisko
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Imię i nazwisko',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      //Email Adres
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Adres email',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      //Telefon
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Nr telefonu',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      //Hasło
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Hasło',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 40,
                      ),


                      TaxiButton(
                        title: 'Zarejestruj',
                        color: BrandColors.colorGreen,
                        onPressed:()async{

                          //Sprawdzanie połączenia
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi ){
                            showSnackBar('Brak połączenia z internetem');
                            return;
                          }

                          //walidacja
                          if(fullNameController.text.length < 3){
                            showSnackBar('Nazwa jest za krótka');
                            return;
                          }
                          if(phoneController.text.length < 10){
                            showSnackBar('Numer jest za krótki');
                            return;
                          }
                          if(!emailController.text.contains('@')){
                            showSnackBar('Niepoprawny adres email');
                            return;
                          }
                          if(passwordController.text.length < 8){
                            showSnackBar('Hasło musi się składać z min. 8 znaków');
                            return;
                          }

                          registerUser();

                        },
                      ),                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                    child: Text('Posiadasz już konto, zaloguj')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
