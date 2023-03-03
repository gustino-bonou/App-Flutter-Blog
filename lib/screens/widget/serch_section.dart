import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/screens/widget/articleItems.dart';

import '../../modele/carticles.dart';
import '../rechercer_article.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({Key? key}) : super(key: key);

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Stack(
            children: [
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none
                    )
                  ),
                  prefixIcon: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RechercheArticle(_searchController.text)));
                    },
                      icon: const Icon(Icons.search_outlined, size: 30,)
                  ),
                  hintText: "Serch_article",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.7),
                  )

                ),
                controller: _searchController,
              ),
              Positioned(
                right: 12,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.mic_rounded,
                    color: Color(0xFF5F67EA),
                      size: 25,
                    ),
                  )
              )
            ],
          ),
        ),

      ],
    );
  }
}
