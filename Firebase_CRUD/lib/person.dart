class Person {
  String? id;
  String name;
  int age;
  String city;

  Person({
     this.id,
    required this.name,
    required this.age,
    required this.city,
  });

  factory Person.fromMap(Map<String, dynamic> map, String documentId){
    return Person(id: documentId,
        name: map["name"] as String,
        age: map["age"] as int,
        city: map["city"] as String);
  }
  Map<String, dynamic> toMap(){
    return {
      "name":name,
      "age": age,
      "city" : city,
    };
  }
}