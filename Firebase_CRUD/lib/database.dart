import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repract/person.dart';

class dataBase{
  final CollectionReference personsCollection =
  FirebaseFirestore.instance.collection('persons');
  //create
 Future<void> createPerson(Person person) async{
     final docRef = personsCollection.doc();
     final data = person.toMap();                  // convert person to map
     data['id'] = docRef.id;                       // include ID in data (for internal use)
     await docRef.set(data);                       // write to Firestore
   }
   //read
   Stream<List<Person>> getPersonsStream() {
     return personsCollection.snapshots().map((snapshot) {
       return snapshot.docs.map((doc) {
         return Person.fromMap(doc.data() as Map<String, dynamic>, doc.id);
       }).toList();
     });
   }
   //Edit
  Future<void> updatePerson(Person person) async {
    await personsCollection.doc(person.id).update(person.toMap());
  }
  // Delete
   Future<void> deletePerson(String id) async {
     await personsCollection.doc(id).delete();
   }
 }
