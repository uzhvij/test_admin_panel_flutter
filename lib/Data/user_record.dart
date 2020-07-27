import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String id;
  final String userName;
  final DateTime registrationDate;
  final String lastEvent;
  final String city;
  final int age;
  final DocumentReference reference;

  UserRecord.fromMap(Map<String, dynamic> map, String documentId,
      {this.reference})
      : assert(map['User Name'] != null),
        assert(map['Registration date'] != null),
        assert(map['Last event'] != null),
        assert(map['City'] != null),
        assert(map['Age'] != null),
        id = documentId,
        userName = map['User Name'],
        registrationDate = (map['Registration date'] as Timestamp).toDate(),
        lastEvent = map['Last event'],
        city = map['City'],
        age = map['Age'];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$id:$userName>";
}
