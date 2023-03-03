import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/config/global.parents.dart';
import 'package:user_firebase/main.dart';
import 'package:user_firebase/util/show_snackbar.dart';


  showMyDialog(  BuildContext context, TextEditingController commentController, CollectionReference collectionReference, String id,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: d_green,
          scrollable: true,
          title: const Text("  "),
          titleTextStyle: TextStyle(),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 150,
            child: TextFormField(
              minLines: 3,
              maxLines: 5,
              controller: commentController,
              decoration: inputDecoration("Modifier le commentaire"),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 24.0, 0.0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Retour',
                  style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Modifier', style: TextStyle(),),
                  onPressed: () {
                    print("data");
                    Navigator.of(context).pop();
                    // ignore: avoid_single_cascade_in_expression_statements
                    collectionReference.doc(id).update({
                      "content": commentController.text
                    })..then((value) {
                      Navigator.of(context).pop();
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
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }