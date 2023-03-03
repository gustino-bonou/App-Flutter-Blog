import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/simple_app_bar.dart';

import '../config/global.parents.dart';
import '../main.dart';
import '../util/show_snackbar.dart';

class ModifierArticle extends StatefulWidget {
  String idArticle;
  String titleArticle;
  String contentArticle;
   ModifierArticle({Key? key, required this.idArticle, required this.titleArticle, required this.contentArticle}) : super(key: key);

  @override
  State<ModifierArticle> createState() => _ModifierArticleState();
}

class _ModifierArticleState extends State<ModifierArticle> {

  CollectionReference articleRef = FirebaseFirestore.instance.collection("articles");

  bool uploading = false;
  double val = 0;

  List<String> cats = ['Sports', 'Music', 'Politic'];

  final contentValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(5, errorText: 'Content must be at least 200 digits long'),
  ]);

  final titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(2, errorText: 'Title must be at least 12 digits long'),
  ]);

  void notifiedMessage(message){
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }




  String? _selected = "Sports";
  String? content;
  String? titre;
  final formkey = GlobalKey<FormState>();
  final String errorMessage = "Veuillez remplir tous les champs";

  void updateArticle(BuildContext context, title, content){
    // ignore: avoid_single_cascade_in_expression_statements
    articleRef.doc(widget.idArticle).update({
      "title":title,
      "content": content,
    })..then((value) {
      // Afficher un message de succès avec ScaffoldMessenger
      Utils.showSnack(context, "Mise à jour effectuée avec succès");
      Navigator.pop(context);
    }).catchError((error) {
      // Afficher un message d'erreur avec ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 20,
          duration: const Duration(seconds: 4),
          content: Text('Erreur lors de la mise à jour : $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    TextEditingController contentController = TextEditingController(text: widget.contentArticle);
    TextEditingController titleController = TextEditingController(text: widget.titleArticle);


    return Scaffold(
        backgroundColor: d_green,
        appBar: SimpleAppBar(),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                Text("Modifier l'article",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          minLines: 2,
                          maxLines: 2,
                          controller: titleController,
                          decoration: inputDecoration("Titre"),
                          validator: titleValidator,

                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          minLines: 3,
                          maxLines: 5,
                          controller: contentController,
                          decoration: inputDecoration("Contenu", ),
                          validator: contentValidator,
                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                      ],
                    )
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Catégorie",
                        style: Theme.of(context).textTheme.headline3
                    ),
                    DropdownButton(
                      hint:  Text(_selected!,
                          style: Theme.of(context).textTheme.headline2
                      ),
                      value: _selected,

                      onChanged: (newValue) {
                        setState(() {
                          _selected = newValue;
                        });
                      },
                      items: cats.map((categorie) {
                        return DropdownMenuItem(
                          value: categorie,
                          child: Text(categorie),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:  Text("Annuler",
                          style: Theme.of(context).textTheme.headline1,
                        )
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: (){
                          if(formkey.currentState!.validate()){
                            updateArticle(context, titleController.text, contentController.text);
                          }

                        },
                        child:  Text("Modifier",
                          style: Theme.of(context).textTheme.headline1,
                        )
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                APropos(),
              ],
            ),
          ),
        ));
  }
}
