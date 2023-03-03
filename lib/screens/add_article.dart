import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:user_firebase/config/global.parents.dart';
import 'package:user_firebase/modele/carticles.dart';
import 'package:user_firebase/screens/widget/a_propos.dart';
import 'package:user_firebase/screens/widget/mydrawer.dart';
import 'package:user_firebase/screens/widget/simple_app_bar.dart';


class AddArticlePage extends StatefulWidget {
  User user;

  AddArticlePage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddArticlePage> createState() => _TestAddPageState();
}

class _TestAddPageState extends State<AddArticlePage> {
  bool uploading = false;
  double val = 0;
  CollectionReference? articles;
  firebase_storage.Reference? ref;

  List<String> cats = ['Sports', 'Music', 'Politic'];

  final picker = ImagePicker();

  final articleValidator = MultiValidator([
    RequiredValidator(errorText: 'Content is required'),
    MinLengthValidator(5, errorText: 'Content must be at least 200 digits long'),
  ]);

  final titleValidator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(2, errorText: 'Title must be at least 12 digits long'),
  ]);

  final imageNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Image name is required'),
  ]);

  void notifiedMessage(message){
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController articleController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController imageNameController = TextEditingController();

  String? _selected = "Sports";
  String? content;
  String? titre;
  String? imageName;
  final formkey = GlobalKey<FormState>();
  final String errorMessage = "Veuillez remplir tous les champs";

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool loading = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Color(0xFFF6F8FF),
        appBar: SimpleAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                 Text("Ajouter un article",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [

                        TextFormField(
                          minLines: 2,
                          maxLines: 2,
                          controller: titleController,
                          decoration: inputDecoration("Proposez un titre à votre articles"),
                          validator: titleValidator,

                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        TextFormField(
                          minLines: 3,
                          maxLines: 5,
                          controller: articleController,
                          decoration: inputDecoration("Le contenu de l'article", ),
                          validator: articleValidator,
                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),

                        ),


                        const SizedBox(
                          height: 15,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(

                                onPressed: selectFile,
                                child:  Text("Choisir une image",
                                style: Theme.of(context).textTheme.headline3
                                )
                            ),
                            IconButton(
                                onPressed: selectFile,
                                icon: const Icon(Icons.add)
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                if(pickedFile != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage((File(pickedFile!.path!)),)
                      ),
                       const SizedBox(
                         width: 8,
                       ),
                       Expanded(
                        child: TextFormField(
                          controller: imageNameController,
                          decoration: inputDecoration("Nom de l'image"),
                          validator: imageNameValidator,
                          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black54),
                        )
                      ),

                    ],
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
                        child:  Text("Retour",
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

                            try {

                              _displayDialog(context);

                            } catch (e) {
                              notifiedMessage("Une erreur s'est produite");
                            }

                          }

                        },
                        child:  Text("Publier",
                          style: Theme.of(context).textTheme.headline1,
                        )
                    )
                  ],
                ),
                APropos(),
              ],
            ),
          ),
        ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return null;

    setState(() {
      pickedFile = result.files.first;
    });
  }


  Future uploadFileData(User user) async {

    content = articleController.text;
    titre = titleController.text;

    if(pickedFile!=null) {
      final pathi = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filei = File(pickedFile!.path!);


      imageName = imageNameController.text;

      final ref = FirebaseStorage.instance.ref().child(pathi);
      setState(() {
        uploadTask = ref.putFile(filei);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

     final urlDownload = await snapshot.ref.getDownloadURL();

     /*
      imageArticle?.add({
        "imageId": idig,
        'imageName': imageName,
        "urlImage": urlDownload,
        "dateImage": DateTime.now(),
      });
      */
      Article articleImg = Article(
        id: articles?.doc().id,
        title: titre,
        content: content,
        imageUrl: urlDownload,
        category: _selected,
        userId: user.uid,
        datePosted: Timestamp.now(),
        likes: 0,
        likedBy: [],
      );

        await articles?.add(articleImg.toData()).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration:  Duration(seconds: 2),
            content: Text('Article Publié avec succès'),
          ),
        )).catchError((onError)=>
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
        duration:  Duration(seconds: 4),
        content: Text('Une erreur s\'est produite'),
        ),
        )) ;
    }else {
      Article articleImg = Article(
        id: articles?.doc().id,
        title: titre,
        content: content,
        category: _selected,
        userId: user.uid,
        datePosted: Timestamp.now(),
        likes: 0,
        likedBy: [],
      );

      await articles?.add(articleImg.toDataWI()).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration:  Duration(seconds: 4),
          content: Text('Article Publié avec succès'),
        ),
      )).catchError((onError)=>
          // ignore: invalid_return_type_for_catch_error
          ScaffoldMessenger.of(context).showSnackBar(
           const  SnackBar(
              duration:  Duration(seconds: 4),
              content: Text('Une erreur s\'est produite'),
            ),
          )) ;
    }
    // setState(() {
    //   uploadTask = null;
    // });

  }



  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context){
          return Container(
            height: 200,
            child: AlertDialog(
              content: const Text("Voulez-vous vraiment publier ce article ?"),
              actions: <Widget>[
                isLoading ? TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ):Container(),
                TextButton(
                  onPressed: (){

                      uploadFileData(widget.user);
                      notifiedMessage("Chargement...");

                    setState(() {
                      pickedFile == null;
                      titleController.text = "";
                      articleController.text = "";
                      imageNameController.text = "";
                    });
                    Navigator.pop(context);
                   // uploadFilet(widget.user).whenComplete(() => Navigator.of(context).pushNamed("/controlPage"));
                  },
                  child: const Text("Confirm"),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    articles = FirebaseFirestore.instance.collection("articles");
  }
}
