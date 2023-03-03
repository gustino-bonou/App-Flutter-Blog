import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/global.parents.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  user = Provider.of<User?>(context);
    return Drawer(

      elevation: 85,
      //backgroundColor: Color(0xFF8a307f),
      child: ListView(
        children:  [
           DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF6AA5E7),
                    Color(0xFF56002D),
                  ])
              ),
              child: Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:  [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: NetworkImage(user!.photoURL!,),
                    ),
                    const SizedBox(height: 5,),
                    SingleChildScrollView(
                      child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${user!.displayName}\n',
                                    style: Theme.of(context).textTheme.headline5

                                ),
                              ]
                          )),
                    )



                  ],
                ),
              )
          ),


          ...(GlobalParams.menus).map((element){
            return Column(
              children: [
                ListTile(
                  title:  Text('${element['title']}', style: TextStyle(fontSize: 22),),
                  leading:  element['icon'],
                  trailing:  Icon(Icons.arrow_right, color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '${element['route']}');
                  },
                ),
                const Divider(color: Color(0xFF56002D), height: 8,),
              ],
            );
          }
          )



          /*
          ListTile(
            title: const Text('Home', style: TextStyle(fontSize: 22),),
            leading: const Icon(Icons.home, color: Colors.orange,),
            trailing: const Icon(Icons.arrow_right, color: Colors.orange,),
            onTap: (){},
          ),
          const Divider(height: 2, color: Colors.deepOrange,),
          ListTile(
            title: const Text('Meteo', style: TextStyle(fontSize: 22),),
            leading: const Icon(Icons.home, color: Colors.orange,),
            trailing: const Icon(Icons.arrow_right, color: Colors.orange,),
            onTap: (){
              //Pour voir le drawer fermer quand on va revenir sur le page home
              Navigator.of(context).pop();
              //Pour aller sur la page meteo
              Navigator.pushNamed(context, "/meteo");
            },
          ),
          const Divider(height: 2, color: Colors.deepOrange,),
          ListTile(
            title: const Text('Gallery', style: TextStyle(fontSize: 22),),
            leading: const Icon(Icons.home, color: Colors.orange,),
            trailing: const Icon(Icons.arrow_right, color: Colors.orange,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/gallery');
            },
          ),
          const Divider(height: 2, color: Colors.deepOrange,),
          ListTile(
            title: const Text('Counter', style: TextStyle(fontSize: 22),),
            leading: const Icon(Icons.home, color: Colors.orange,),
            trailing: const Icon(Icons.arrow_right, color: Colors.orange,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/counter');
            },
          )

          */
        ],

      ),
    );
  }
}