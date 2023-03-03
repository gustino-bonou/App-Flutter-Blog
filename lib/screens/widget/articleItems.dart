import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/modele/carticles.dart';

import '../../util/format_date.dart';
import '../detail_article.dart';

import 'package:flutter/material.dart';

class ListFavoriteArticles extends StatefulWidget {
  ListFavoriteArticles({Key? key}) : super(key: key);

  @override
  State<ListFavoriteArticles> createState() => _ListFavoriteArticlesState();
}

class _ListFavoriteArticlesState extends State<ListFavoriteArticles> {

  int? _itemCount;
  List<Article>? _articles;

  Future<List<Article>> getArticlesFromCollection() async {
    List<Article> articles = [];
    List<Article> articless = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('collection').where("likes", isGreaterThan: 0).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articless.add(Article.fromDocument(article));
    });
    return articles;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArticlesFromCollection().then((articles) {
      setState(() {
        _itemCount = articles.length;
        _articles = articles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
          color: Color(0xFFF6F8FF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            child: ListView.builder(

              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)=>Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _articles![index].id as IconData,
                      color: Colors.white,
                      size: 40,),

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_articles![index].title as String,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              itemCount: _itemCount,),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:const Text("Popular Articles",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          )
        ],
      ),
    );
  }
}



Widget buildArticleListItem(BuildContext context, Article article, CollectionReference collectionReference) {
  final _user = Provider.of<User?>(context);
  String date = formateDate(article.datePosted!);
  Map artMap = article.toData() ;
  bool isFavorite = false;
  String title = artMap["title"];
  if (title.toString().length>55){
    title = title.substring(0, 55);
  }

  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailArticle(artid: article.id!),
      ));
    },
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade300
      ),
      child: Column(
        children: [
          artMap["imageUrl"] != null ? Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width,
            height: 200,
            // width: double.infinity,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                    artMap["imageUrl"] ,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Container(
                        color: Colors.grey,
                      );
                    }
                )
            ),
          ):Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade400
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formateDate(artMap["datePosted"]),
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              _likeArticle(context, collectionReference, article.id, _user.uid);
                              isFavorite = !isFavorite;
                            },
                            icon:  Icon(Icons.favorite_outline,
                              color: article.likedBy!.contains(_user!.uid)
                                  ? Colors.red
                                  : Colors.grey.shade700,
                            )
                        ),
                        Text("${artMap["likes"]}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold

                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> _likeArticle(BuildContext context,CollectionReference collection,  articleid, currentUserId) async {
  final articleRef = collection.doc(articleid);
  articleRef.get().then((doc) {
    final article = Article.fromDocument(doc);
    if (article.likedBy!.contains(currentUserId)) {

      article.likes= article.likes!-1;
      article.likedBy!.remove(currentUserId);

    } else {

      article.likes = article.likes!+1;
      article.likedBy!.add(currentUserId);

    }
    articleRef.set(article.toData());
  });
}



Widget myArticle(BuildContext context, Article article, CollectionReference collectionReference) {
  final _user = Provider.of<User?>(context);
  String date = formateDate(article.datePosted!);
  Map artMap = article.toData() ;
  bool isFavorite = false;
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFF2E4C5),
          ),
          child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailArticle(artid: article.id!)));
              },
              child: Column(
                  children: [

                    artMap.containsKey("imageUrl") ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          child: Image.network(
                            artMap["imageUrl"],
                            fit: BoxFit.cover,
                          )
                      ),
                    ):Container(),

                    const SizedBox(
                      height: 5,
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [


                            Text("${artMap["title"] ?? ""}",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.justify,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(date),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          _likeArticle(context, collectionReference, article, _user.uid);
                                          isFavorite = !isFavorite;
                                        },
                                        icon:  Icon(Icons.favorite_outline,
                                          color: article.likedBy!.contains(_user!.uid)
                                              ? Colors.blue
                                              : Colors.grey.shade700,
                                        )
                                    ),
                                    Text("${artMap["likes"]}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold

                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),


                          ],
                        ),
                      ),
                    )

                  ]
              )
          )
      )
  );
}
