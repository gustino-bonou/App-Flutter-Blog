import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/modele/carticles.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/articleItems.dart';
import 'package:user_firebase/screens/widget/botton_navigation_bar.dart';
import 'package:user_firebase/screens/widget/header_articles_category.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';


class AutreArticles extends StatefulWidget {
  const AutreArticles({Key? key}) : super(key: key);

  @override
  State<AutreArticles> createState() => _AutreArticles();
}

class _AutreArticles extends State<AutreArticles> {

  Article? _article;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");
    return Scaffold(
        drawer: MyDrawer(),



        backgroundColor:  Color(0xFF5F67EA),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'images/autre.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed:
                          (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black,),
                    ),
                  ],
                ),
              ),
              HeaderCatArticles(category: "Read more",),

              const Padding(
                padding:  EdgeInsets.only(left: 15, top: 15),
                child:  Text("Les derniers articles",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: articlesRef.orderBy('datePosted', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Article> articles = snapshot.data!.docs
                        .map((doc) => Article.fromDocument(doc))
                        .toList();
                    return Container(
                        margin: const EdgeInsets.all(15),
                        decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          //borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return buildArticleListItem(context, article, articlesRef);
                              },
                            ),
                          ],
                        )
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Container(

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
              ),
              APropos(),
            ],
          ),
        ),

        bottomNavigationBar: const ButtonNavigation());
  }
}
