import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/modele/carticles.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/article_of_days.dart';
import 'package:user_firebase/screens/widget/botton_navigation_bar.dart';
import 'package:user_firebase/screens/widget/category_section.dart';
import 'package:user_firebase/screens/widget/header_section.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/popular_article.dart';
import 'package:user_firebase/screens/widget/serch_section.dart';
import 'widget/articleItems.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _articlesRef =
  FirebaseFirestore.instance.collection('articles');

  bool isFavorite = false;

  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor:  Color(0xFF5F67EA),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Transform(
                      transform: Matrix4.identity()..rotateZ(20),
                  origin: const Offset(150, 50),
                    child: Image.asset("images/backgound.png",
                    width: 200,
                    ),
                  ),
                  Positioned(
                    right: 0,
                      top: 200,
                      child: Transform(
                        transform: Matrix4.identity()..rotateZ(20),
                        origin: const Offset(150, 150),
                        child: Image.asset("images/backgound.png",
                          width: 150,
                        ),
                      ),
                  ),
                  Column(
                    children:  [
                      HeaderSection(),
                      SearchSection(),
                      CategorySection(),

                      Container(
                        color: Colors.white,
                        child: PopularArticles(),
                      ),
                      Container(
                        color: Colors.white,
                        child: ArticleOfDay(articleFunction: getLateArticlesFromCollection,),
                      )
                      //ListFavoriteArticles(),
                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 10,
              ),

              APropos(),



              // IconButton(
              //     onPressed: (){
              //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EmailLogin()));
              //     },
              //     icon: Icon(Icons.logout)),

            ],
          ),
        ),
      bottomNavigationBar: ButtonNavigation(),
    );
  }

//
void funt(){
  StreamBuilder<QuerySnapshot>(
    stream: _articlesRef.orderBy("datePosted", descending: true).snapshots(),
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
            return buildArticleListItem(context, article, _articlesRef);
          },
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
}