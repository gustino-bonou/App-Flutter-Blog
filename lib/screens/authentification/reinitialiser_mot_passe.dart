import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_firebase/config/global.parents.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("Recevez l'email de reinitialisation",
               style: Theme.of(context).textTheme.headline3,
               ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                decoration: inputDecoration("entrer l'eamil"),
                controller: emailController,

              //  validator: ,

              ) ,
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {},
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
                      Text('ENVOYER',
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
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Se connecter
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
                      Text('Envoyer à nouveau',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),

                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
