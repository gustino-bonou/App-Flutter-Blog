import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top+25,
        left: 25,
        right: 25
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Welcome, ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(
                height: 5,
              ),
              Text("Would you like to reda?",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          CircleAvatar(
            child: Image.asset("images/avatar.png",
            fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
