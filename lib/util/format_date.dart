

import 'package:cloud_firestore/cloud_firestore.dart';

String formateDate(Timestamp timestamp) {
  var date = timestamp.toDate();

  String formattedDate;

  if(date.day == Timestamp.now().toDate().day && date.month == Timestamp.now().toDate().month && date.year == Timestamp.now().toDate().year){
    formattedDate = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }else{
    formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}     ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  return formattedDate;

}
