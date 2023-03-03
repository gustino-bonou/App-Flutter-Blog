import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_firebase/modele/carticles.dart';
import 'package:user_firebase/screens/detail_article.dart';

import '../../util/format_date.dart';

class ImageWithText extends StatefulWidget {
  final Future<Article> Function() articleFunction;

  ImageWithText({required this.articleFunction});

  @override
  State<ImageWithText> createState() => _ImageWithTextState();
}

class _ImageWithTextState extends State<ImageWithText> {

  Future<Article> getLateArticlesFromCollection() async {
    List<Article> articles = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('articles').orderBy("datePosted", descending: true).get();
    querySnapshot.docs.forEach((article) {
      //articles.add(article.data());
      articles.add(Article.fromDocument(article));
    });
    return articles[0];
  }


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
      future: widget.articleFunction(),
        builder: (BuildContext context, AsyncSnapshot<Article> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if(snapshot.hasError) {
          return Container();
        }else {
          String title = snapshot.data!.title!;
          if(title.length>55 ){
            title = title.substring(0, 49);
          }
          return
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailArticle(artid: snapshot.data!.id!),
                ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    snapshot.data!.imageUrl != null ? Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      // width: double.infinity,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          child: Image.network(
                              snapshot.data!.imageUrl!,
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
                        Text(
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
                        Text(
                          formateDate(snapshot.data!.datePosted!),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
        }
        }
        );
  }
}


// InkWell(
// onTap: (){
// Navigator.push(context,
// MaterialPageRoute(builder: (context)=>
// DetailArticle(artid: snapshot.data!.id!)
// ));
// },
// child: Container(
// padding: EdgeInsets.all(15),
// height: 200,
// decoration: BoxDecoration(
// //border: Border.all(),
// borderRadius: BorderRadius.circular(10),
// boxShadow: const [
// BoxShadow(
// color: Color(0xFF5F67EA),
// spreadRadius: 0,
// blurRadius: 0,
// //offset: Offset(0, 5),
// ),
// ],
// ),
// child: Container(
// padding: EdgeInsets.only(top: 15, left: 15, right: 15),
// decoration: BoxDecoration(
// color: Color(0xFFF6F8FF),
// borderRadius: BorderRadius.circular(15),
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// //padding: EdgeInsets.only(left: 5, right: 5, top: 5),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(25)
// ),
// height: 200,
// // ajustez la hauteur de l'image selon vos besoins
// width: double.infinity,
// child: snapshot.data!.imageUrl != null ? ClipRRect(
// borderRadius: const BorderRadius.only(
// topRight: Radius.circular(15),
// topLeft: Radius.circular(15)),
// child: Image.network(snapshot.data!.imageUrl!, fit: BoxFit.cover,
//
// ),
// ):Container(
// color: CupertinoColors.systemGrey2,
// ),
// ),
// Container(
// height: 100,
// //color: Colors.grey[200],
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('$title...',
// style: GoogleFonts.merriweather(
// fontSize: 26,
// fontWeight: FontWeight.w700,
// ),
// textAlign: TextAlign.justify,
// ),
// Text(formateDate(snapshot.data!.datePosted!).toString(),
// style: GoogleFonts.merriweatherSans(
// fontSize: 20,
// fontWeight: FontWeight.w300,
//
// ),
// ),
// ],
// ),
//
// ],
// ),
// )
// ],
// ),
// ),
// ),
// );