import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/config/global.parents.dart';
import 'package:user_firebase/services/authentification.dart';


class SimpleAppBar extends StatefulWidget implements PreferredSizeWidget {
  //final User? user;

  const SimpleAppBar({Key? key, }) : super(key: key);

  @override
  State<SimpleAppBar> createState() => _SimpleAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75);

}

class _SimpleAppBarState extends State<SimpleAppBar> {


  int _currentImageIndex = 0;
  final List<String> _backgroundImages = [    'images/music.png',    'images/autre.png',    'images/appbar_img.png',  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _backgroundImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    //ThemeManager _themeManager = ThemeManager();
    return AppBar(
      //backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImages[_currentImageIndex]),
            fit: BoxFit.cover,
          ),
        ),
      ),
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.arrow_back,
      //     color: Colors.amber
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      // ),
      title: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            AuthService().signOutGoogle();
          },
        ),
      ],
    );
    //   AppBar(
    //   title: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: const  [
    //        Text('SuperBlog'),
    //       CircleAvatar(
    //         radius: 20,
    //         backgroundColor: Colors.blueGrey,
    //         backgroundImage: AssetImage('images/logo.jpg',
    //           // color: Colors.transparent,
    //           // colorBlendMode: BlendMode.color,
    //         ),
    //       ),
    //     ],
    //   ),
    //   flexibleSpace: Container(
    //     decoration:  BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //         gradient: const LinearGradient(begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             colors: <Color>[
    //               Colors.green,
    //               Colors.blue
    //             ])),
    //   ),
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         bottomLeft: Radius.circular(20.0),
    //         bottomRight: Radius.circular(20.0),
    //       ),
    //     ),
    //     bottom: const PreferredSize(
    //     preferredSize: Size.fromHeight(10.0),
    // child: ClipRRect(
    // borderRadius: BorderRadius.only(
    // bottomLeft: Radius.circular(20.0),
    // bottomRight: Radius.circular(20.0),
    // ),
    // )
    //     ),
    // );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75);
}
// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class SimpleAppBar extends StatefulWidget {
//   @override
//   _SimpleAppBar createState() => _SimpleAppBar();
// }
//
// class _SimpleAppBar extends State<SimpleAppBar> {
//   int _currentImageIndex = 0;
//   List<String> _backgroundImages = [    'assets/images/background1.jpg',    'assets/images/background2.jpg',    'assets/images/background3.jpg',  ];
//
//   @override
//   void initState() {
//     super.initState();
//     Timer.periodic(Duration(seconds: 3), (timer) {
//       setState(() {
//         _currentImageIndex = (_currentImageIndex + 1) % _backgroundImages.length;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(_backgroundImages[_currentImageIndex]),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             // Action pour revenir à la liste des articles
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.share,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               // Action pour partager l'article
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.favorite_border,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               // Action pour ajouter l'article aux favoris
//             },
//           ),
//         ],
//       );
//   }
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => Size.fromHeight(75);
// }
