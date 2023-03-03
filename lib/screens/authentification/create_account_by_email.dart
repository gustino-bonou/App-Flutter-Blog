import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/screens/authentification/login_by_email.dart';
import 'package:user_firebase/util/show_snackbar.dart';

import '../../config/global.parents.dart';
import '../../services/auth_methode.dart';
import '../../services/authentification.dart';

import 'package:email_validator/email_validator.dart' as mail;

class CreateAcountByEmail extends StatefulWidget {
  const CreateAcountByEmail({Key? key}) : super(key: key);

  @override
  _CreateAcountByEmail createState() => _CreateAcountByEmail();
}

class _CreateAcountByEmail extends State<CreateAcountByEmail> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController secondPassController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  void emailValidator(){

  }
  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(5, errorText: 'Content must be at least 200 digits long'),
  ]);

  void _signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
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
                                  : null,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: passwordController,
                              decoration: inputDecoration("Entre votre mail"),
                              validator: _passwordValidator
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: secondPassController,
                                  decoration: inputDecoration("Confirmer mot de passe"),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: _passwordValidator,
                                  // validator: ,


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
                            _signUpUser();
                            print('object');
                          }
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
                            Text('CREER UN COMPTE',
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
                    Text("Avez-vous de compte ?",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Connectez-vous ici",
                        style: Theme.of(context).textTheme.headline2,
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)=>EmailLogin()));
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
