import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/main.dart';
import 'package:user_firebase/modele/carticles.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/articleItems.dart';
import 'package:user_firebase/screens/widget/botton_navigation_bar.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/simple_app_bar.dart';

class MesFavoris extends StatefulWidget {
  @override
  _MesFavoris createState() => _MesFavoris();
}

class _MesFavoris extends State<MesFavoris> {

  bool voirDetail = false;

  DocumentSnapshot? article;

  CollectionReference articlesRef = FirebaseFirestore.instance.collection('articles');
  @override

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
        drawer: MyDrawer(),
        backgroundColor: d_green,

      appBar: SimpleAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/favorite.png",
                    ),
                  fit: BoxFit.cover
                )
              ),
              child: Stack(
                children: const [
                  Center(
                    child: Text("Our Favorites",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 40
                    ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: articlesRef.orderBy('datePosted', descending: true)
                  .where('likedBy', arrayContains: _user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Article> articles = snapshot.data!.docs
                      .map((doc) => Article.fromDocument(doc))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return buildArticleListItem(context, article, articlesRef);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            APropos(),
          ],
        ),
      ),
      bottomNavigationBar: ButtonNavigation(),
    );
  }
}
