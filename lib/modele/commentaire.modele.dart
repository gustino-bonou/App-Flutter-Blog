import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  String? id;
  String? content;
  String? imageUrl;
  String? userId;
  Timestamp? datePosted;
  int? likes;
  List<String>? likedBy;

  Comment({
    this.datePosted,
    required this.id,
    this.content,
    this.imageUrl,
    this.userId,
    this.likes,
    this.likedBy,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      content: doc['content'],
      imageUrl: doc['imageUrl'],
      datePosted: doc['datePosted'],
      userId: doc["userId"],
      likes: doc['likes'],
      likedBy: List<String>.from(doc['likedBy']),
    );
  }

  Map<String, dynamic> toData() => {
    'content': content,
    'imageUrl': imageUrl,
    'datePosted': datePosted,
    'userId': userId,
    'likes': likes,
    'likedBy': likedBy,
  };
  Map<String, dynamic> toDataWI() => {
    'content': content,
    'imageUrl': imageUrl,
    'datePosted': datePosted,
    'userId': userId,
    'likes': likes,
    'likedBy': likedBy,
  };
}