import 'package:flutter/material.dart';

class APropos extends StatelessWidget {
  const APropos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(

      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          onPressed: (){},
          child: const Text("A PROPOS",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
          )),
    );
  }
}
