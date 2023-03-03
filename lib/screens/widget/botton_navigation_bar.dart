import 'package:flutter/material.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? _selectedIndex;
    return Container(
     // color: Color(0xfff6f8ff),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10
              )
            ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          child: BottomNavigationBar(

              onTap: (int index){
                setState(() {
                  _selectedIndex = index;
                });
                if(_selectedIndex == 3){
                  Navigator.of(context).pushNamed("/write");
                }
                if(_selectedIndex == 2){
                  Navigator.of(context).pushNamed("/favorite");
                }
                if(_selectedIndex == 1){
                  Navigator.of(context).pushNamed("/mesarticles");
                }
                if(_selectedIndex == 0){
                  Navigator.of(context).pushNamed("/home");
                }
              },
            selectedItemColor: const Color(0xFF5F67EA),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey.withOpacity(0.7),
            type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'home',
                    icon: Icon(Icons.home,
                      size: 35,
                    )
                ),
                BottomNavigationBarItem(
                    label: 'search',
                    icon: Icon(Icons.my_library_books,
                      size: 35,
                    )
                ),
                BottomNavigationBarItem(
                    label: 'favorite',
                    icon: Icon(Icons.favorite,
                    size: 35,
                    ),
                ),
                BottomNavigationBarItem(
                    label: 'write',
                    icon: Icon(Icons.edit,
                      size: 35,
                    ),
                )
              ]),
        ),
      ),
    );
  }
}
