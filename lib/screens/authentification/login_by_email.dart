import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/screens/authentification/create_account_by_email.dart';
import 'package:user_firebase/screens/authentification/reinitialiser_mot_passe.dart';
import 'package:user_firebase/util/show_snackbar.dart';

import '../../config/global.parents.dart';
import '../../services/auth_methode.dart';
import '../../services/authentification.dart';

import 'package:email_validator/email_validator.dart' as mail;

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLogin createState() => _EmailLogin();
}

class _EmailLogin extends State<EmailLogin> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController imageNameController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  void _loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  bool inLoginProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              height: 150,
              child: Column(
                children: [
                   const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('images/august.jpg'),
                  ),
                  Text('SuperBlog',
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 26,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            ),
            inLoginProcess ? const Center(
              child: CircularProgressIndicator(),
            ):
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Form(
                      key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: inputDecoration("Entre votre mail"),
                              validator: (email) =>
                              email != null && !(mail.EmailValidator.validate(email))?
                              "Entrer un email valide"
                                  : null

                              ,

                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: passwordController,
                                  decoration: inputDecoration("Entre votre mot de passe"),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                                  // validator: ,


                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
                                    }

                                    ,
                                    child: const Text("Mode de passe oublié ?",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800

                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          if(_formkey.currentState!.validate()){
                            _loginUser();                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xFF576dff),
                          padding: EdgeInsets.all(13),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(Icons.login),
                            SizedBox(width: 10),
                            Text('SE CONNECTER',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),

                          ],
                        )
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text("Vous n'avez pas de compte ?",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cliquez ici",
                        style: Theme.of(context).textTheme.headline2,
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)=>CreateAcountByEmail()));
                            },
                            child: Text("ici",
                              style: Theme.of(context).textTheme.headline1,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
        );
  }

  signin(email, password) {
    setState(() {
      inLoginProcess = true;
      try{
        AuthService().signUpWithEmail(email, password);
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
