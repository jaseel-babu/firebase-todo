
class Todomodel {
  String? uid;
  String? title;
  String? notes;
  Todomodel({
    this.uid,
    this.title,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'notes': notes,
    };
  }

  factory Todomodel.fromMap(Map<String, dynamic> map) {
    return Todomodel(
      uid: map['uid'],
      title: map['title'],
      notes: map['notes'],
    );
  }
}
