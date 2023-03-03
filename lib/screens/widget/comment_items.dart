import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/modele/commentaire.modele.dart';

import '../../services/dialogModified.dart';
import '../../util/format_date.dart';

Widget buildCommentItem(BuildContext context, Comment comment, CollectionReference collectionReference) {
  final _user = Provider.of<User?>(context);
  TextEditingController contentController = TextEditingController(text: comment.content);
  String date = formateDate(comment.datePosted!);
  Map commMap = comment.toData() ;
  bool isFavorite = false;
  return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commMap["imageUrl"] != null ?
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(commMap["imageUrl"]),
                    ):Container(),
                    const SizedBox(
                      width: 5,
                    ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(commMap["content"],
                                style: Theme.of(context).textTheme.headlineSmall,
                                textAlign: TextAlign.justify,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(date,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                  commMap["userId"] == _user!.uid ?
                                      TextButton(
                                          onPressed: (){
                                            showMyDialog(context, contentController, collectionReference, comment.id!, );
                                          },
                                          child: const Text("Modifier",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                          )
                                      ):Container(),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){
                                            _likeComment(context, collectionReference, comment, _user.uid);
                                            isFavorite = !isFavorite;
                                          },
                                          icon:  Icon(Icons.favorite_outline,
                                            color: comment.likedBy!.contains(_user!.uid)
                                                ? Colors.red
                                                : Colors.grey.shade700,
                                          )
                                      ),
                                      Text("${commMap["likes"]}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold

                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ]
          )
      )
  );
}
Future<void> _likeComment(BuildContext context,CollectionReference collection, Comment comment, currentUserId) async {
  Map artMap = comment.toData() ;
  final articleRef = collection.doc(comment.id);
  articleRef.get().then((doc) {
    final article = Comment.fromDocument(doc);
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