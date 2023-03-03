import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/modele/carticles.dart';

import '../../util/format_date.dart';
import '../detail_article.dart';

class PopularArticles extends StatefulWidget {
  const PopularArticles({Key? key}) : super(key: key);

  @override
  State<PopularArticles> createState() => _PopularArticlesState();
}

class _PopularArticlesState extends State<PopularArticles> {

  List<Article> _articles = [];

  CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");

  Future<List<Article>> getArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').where("category", isEqualTo: "Sports").get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles;
  }

  @override
  void initState() {
    super.initState();
    // 2. Appeler la fonction et stocker le résultat dans la variable _articles
    getArticlesFromCollection().then((articles) {
      setState(() {
        _articles = articles;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFFF6F8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Popular Articles",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            height: 300,
            child:
            ListView.separated(

              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String title = _articles[index].title!;
                if(_articles[index].title!.length>50){
                  title = _articles[index].title!.substring(0, 49);
                }
                String date  = formateDate(_articles[index].datePosted!);
                return
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailArticle(artid: _articles[index].id!),
                      ));
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300
                      ),
                      child: Column(
                        children: [
                      _articles[index].imageUrl != null ? Container(

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: MediaQuery.of(context).size.width*0.7,
                                  height: 200,
                                  // width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                      child: Image.network(
                                          _articles[index].imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                            );
                                          }
                                      )
                                  ),
                                ):Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade400
                                  ),
                                ),

                          Container (
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _articles[index].title!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  formateDate(_articles[index].datePosted!),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              },
              separatorBuilder: (context, index) => const SizedBox( width: 10,),
              itemCount: _articles.length,
            ),
          ),
        ],
      ),
    );
  }
}
