import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_firebase/modele/carticles.dart';

Future<void> likeArticle(BuildContext context,CollectionReference collection,  articleid, currentUserId) async {
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