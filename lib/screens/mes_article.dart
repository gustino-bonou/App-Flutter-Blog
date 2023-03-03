import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/main.dart';
import 'package:user_firebase/screens/modifier_article.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/botton_navigation_bar.dart';
import 'package:user_firebase/screens/widget/const_entete.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/simple_app_bar.dart';
import '../util/show_snackbar.dart';
import 'detail_article.dart';

class MesArticles extends StatefulWidget {
  @override
  _MesArticles createState() => _MesArticles();
}

class _MesArticles extends State<MesArticles> {

  bool voirDetail = false;

  DocumentSnapshot? article;

  CollectionReference articlesRef = FirebaseFirestore.instance.collection('articles');
  @override

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      bottomNavigationBar: ButtonNavigation(),
        drawer: MyDrawer(),
        backgroundColor: d_green,

      appBar: const SimpleAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            EnteteListArticle(user: _user,section: "Vos articles"),
            StreamBuilder(
              stream: articlesRef
                  .orderBy('datePosted', descending: true)
                  .where('userId', isEqualTo: _user!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Une erreur s\'est produite'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Chargement des articles...'));
                }


                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map artMap = (document.data() as Map<String, dynamic>);

                    //String date = formateDate(artMap["date"]);

                    return Container(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailArticle(artid: document.id)));
                        },
                        child: Column(
                          children: [
                            artMap["imageUrl"] != null ?   ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              child: Image.network(
                                artMap["imageUrl"],
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                                  return Container(
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            )
                        ):Container(),
                            const SizedBox(
                              height: 15,
                            ),
                            artMap["title"] != null ?
                            Text(artMap["title"],
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.justify,
                            ):const Text(""),
                            const SizedBox(
                              height: 15,
                            ),

                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonBar(
                                  children: [

                                    IconButton(
                                        onPressed: (){
                                          TextEditingController controller = TextEditingController(text: artMap['title']);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ModifierArticle(idArticle: document.id, titleArticle: artMap['title'], contentArticle: artMap['content'])));
                                        },
                                        icon: const Icon(Icons.edit),
                                    ),

                                    IconButton(
                                      onPressed: (){
                                        TextEditingController controller = TextEditingController(text: artMap['title']);
                                        deleteArticle(context, articlesRef,  document.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),

                                    TextButton(
                                        onPressed: (){
                                          setState(() {
                                            voirDetail = !voirDetail;
                                            article = document;
                                          });
                                        },
                                        child: Text("Voir contenu",
                                        style: Theme.of(context).textTheme.headline3,
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Visibility(
                                visible: voirDetail && article!.id == document.id,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      artMap["content"] != null ?
                                      Text(artMap["content"] ,
                                        textAlign: TextAlign.justify,
                                        style: Theme.of(context).textTheme.headline3,

                                      ): const Text(" "),
                                      //Text()
                                    ],
                                  ),
                                )
                            ),

                          ],
                        ),
                      ),
                    );
                  },


                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            APropos(),
          ],
        ),
      )
    );
  }

  deleteArticle(BuildContext context, CollectionReference collectionReference, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: d_green,
          scrollable: true,
          title: Text("Vouler vous supprimer cet article ?"),

          contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 24.0, 0.0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Annuler',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,

                        fontWeight: FontWeight.w700

                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Supprimer',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                      fontWeight: FontWeight.w700

                  )
                  ),
                  onPressed: () {
                    // ignore: avoid_single_cascade_in_expression_statements
                    collectionReference.doc(id).delete()..then((value) {
                      // Afficher un message de succès avec ScaffoldMessenger
                      Utils.showSnack(context, "Article supprimé avec succès");
                      Navigator.pop(context);
                    }).catchError((error) {
                      // Afficher un message d'erreur avec ScaffoldMessenger
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 20,
                          duration: const Duration(seconds: 4),
                          content: Text('Une erreur s\'est produite : $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
