import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/config/global.parents.dart';


class EnteteListArticle extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final String? section;

  const EnteteListArticle({Key? key, this.user, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ThemeManager _themeManager = ThemeManager();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(section!,
            style: Theme
                .of(context)
                .textTheme
                .headline1,
            textAlign: TextAlign.start,
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueGrey,
            backgroundImage: NetworkImage(user!.photoURL!,),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
