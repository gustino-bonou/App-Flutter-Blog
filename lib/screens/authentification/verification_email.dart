// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class VerificationEmail extends StatefulWidget {
//   const VerificationEmail({Key? key}) : super(key: key);
//
//   @override
//   State<VerificationEmail> createState() => _VerificationEmailState();
// }
//
// class _VerificationEmailState extends State<VerificationEmail> {
//
//   bool isVerified = false;
//
//   Timer? time;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     time?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//    void veri() {
//     if(!isVerified){
//       sendVerificationEmail();
//
//       time = Timer.periodic(
//           const Duration(seconds: 30),
//               (_) => checkEmailVerified()
//       );
//     }
//    }
//
//    Future checkEmailVerified() async {
//
//     await FirebaseAuth.instance.currentUser!.reload();
//
//     setState(() {
//       isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });
//
//     if(isVerified) time?.cancel();
//
//    }
//    Future sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//
//       setState(() {
//         canResendEmail = false;
//       });
//
//       await Future.delayed(Duration(seconds: 5));
//       setState(() {
//         canResendEmail = true;
//       });
//
//     }on FirebaseAuthException catch(e){
//       print(e);
//     }
//    }
// }
