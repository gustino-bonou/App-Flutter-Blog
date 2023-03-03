
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/modele/commentaire.modele.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/botton_navigation_bar.dart';
import 'package:user_firebase/screens/widget/comment_items.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/simple_app_bar.dart';
import '../modele/carticles.dart';
import '../util/format_date.dart';

class DetailArticle extends StatefulWidget {
  String artid;
  DetailArticle({Key? key, required this.artid}) : super(key: key);

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {

  CollectionReference articlesRef = FirebaseFirestore.instance.collection("articles");
  CollectionReference? commentairesRef;

  bool isLoved = false;

  bool isFavorite = false;



  final articleValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(1, errorText: 'Content must be at least 200 digits long'),
  ]);




  TextEditingController commentController = TextEditingController();



  String? commentaire;

  final formkey = GlobalKey<FormState>();



  CollectionReference articleRef = FirebaseFirestore.instance.collection("articles");

  bool isLike = true;

  bool upComment = false;


  String? url;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      drawer: MyDrawer(),
      bottomNavigationBar: ButtonNavigation(),
      appBar: SimpleAppBar(),
      backgroundColor: Color(0xFFF6F8FF),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Text("data"),

          StreamBuilder<DocumentSnapshot>(
          stream: articleRef.doc(widget.artid).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final Article article = Article.fromDocument(snapshot.data!);

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        Center(
                          child: Text(article.title ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline2,
                            textAlign: TextAlign.justify,

                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                            child: article.imageUrl != null ? Image.network(
                                article.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                  );
                                }
                            ):Container(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        article.content != null ?
                        Text(article.content ?? "",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600

                          ),
                        ): const Text(""),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formateDate(article.datePosted!)) ,
                            Row(
                              children: [
                                IconButton(
                                    onPressed: (){

                                      _likeArticle(context, articleRef, widget.artid, user.uid);
                                      isFavorite = !isFavorite;
                                      print(isFavorite);
                                    },
                                    icon:  Icon(Icons.favorite_outline,
                                      color: article.likedBy!.contains(user!.uid)
                                          ? Colors.red
                                          : Colors.grey.shade700,
                                    )
                                ),
                                Text(article.likes.toString()),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        Form(
                          key: formkey,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            controller: commentController,
                            decoration: InputDecoration(
                                hintText: "Votre commentaire",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (formkey.currentState!
                                          .validate()) {
                                        _uploadComment(user);

                                        commentController.text = "";
                                      }
                                    },
                                    icon: const Icon(Icons.send)
                                )
                            ),
                            validator: articleValidator,

                          ),
                        ),

                      ]
                  )
              );
              }
            },
          ),
              StreamBuilder<QuerySnapshot>(
                stream: articlesRef.doc(widget.artid).collection("commentaires").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Comment> comments = snapshot.data!.docs
                        .map((doc) => Comment.fromDocument(doc))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        CollectionReference commentRef = articleRef.doc(widget.artid).collection("commentaires");
                        return buildCommentItem(context, comment, commentRef);
                      },
                    );
                  } else {
                    return const Center();
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              APropos(),

            ],
          ),
        ),
      ),
    );
  }
  Future _uploadComment(User user) async {

    setState(() {
      commentaire = commentController.text;
    });
    CollectionReference commentaireRef = articlesRef.doc(widget.artid).collection("commentaires");
    Comment comment = Comment(
      id: commentaireRef.doc().id,
      content: commentaire,
      imageUrl: user.photoURL,
      userId: user.uid,
      datePosted: Timestamp.now(),
      likes: 0,
      likedBy: []
    ) ;

    await commentaireRef.add(comment.toData()).catchError((onError)=>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 20,
            duration:  Duration(seconds: 2),
            content: Text('Une erreur s\'est produite'),
          ),
        )) ;
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

}



