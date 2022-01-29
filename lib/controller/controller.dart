import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:todowithfirebase/model/todomodel.dart';

class Controller extends GetxController {
  List todo = [];
  Todomodel todomodel = Todomodel();

  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');
  void saveMessage(String title) {
    _messagesRef.push().set({"title": title});
  }

  Query getMessageQuery() {
    return _messagesRef;
  }

  deleteTodo(String todoId, int index) {
    print(todoId);
    _messagesRef.child(todoId).remove();
    update(["update"]);

    todo.removeAt(index);
  }
}
