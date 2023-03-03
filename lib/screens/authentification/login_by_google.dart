import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_firebase/screens/authentification/create_account_by_email.dart';
import 'package:user_firebase/util/show_snackbar.dart';

import '../../main.dart';
import '../../services/authentification.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool inLoginProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 150,
              child: Column(
                children: [
                   const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('images/logo.jpg'),
                  ),
                  Text('SuperBlog',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),

            ),
            inLoginProcess ? const Center(
              child: CircularProgressIndicator(),
            ):
            Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text('Identifiez-vous et lisez les meilleurs articles du monde',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 70),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>CreateAcountByEmail()));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Color(0xFF576dff),
                              padding: EdgeInsets.all(13),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(Icons.email),
                                SizedBox(width: 10),
                                Text('EMAIL',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),),

                              ],
                            )
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () => signin(),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.white,
                              padding: EdgeInsets.all(13),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/logo_google.jpg', height: 20,),
                                SizedBox(width: 10),
                                Text('GOOGLE',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),

                                ),

                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
        );
  }

  signin() {
    setState(() {
      inLoginProcess = true;
      try{
        AuthService().signInWithGoogle();
      } on SocketException catch (_){
        Utils.showSnack(context, "Vérifiez votre connexion internet");
      }
    });
  }
   Future signIn(BuildContext context) async {
    if (kIsWeb) {
      setState(() {
        inLoginProcess = true;
        AuthService().signInWithGoogle();
       // Navigator.pushReplacement(context, newRoute)
      });
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() async {
            inLoginProcess = true;
            AuthService().signInWithGoogle();
          });
        }
      } on SocketException catch (_) {
        Utils.showSnack(context, 'Aucune connexion internet');
      }
    }
  }
}
