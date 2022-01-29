
class Todomodel {
  String? uid;
  String? title;
  
  Todomodel({
    this.uid,
    this.title,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
     
    };
  }

  factory Todomodel.fromMap(dynamic map) {
    return Todomodel(
      uid: map['uid'],
      title: map['title'],
     
    );
  }
}
