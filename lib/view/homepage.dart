import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:todowithfirebase/controller/controller.dart';
import 'package:todowithfirebase/main.dart';

import 'package:todowithfirebase/model/todomodel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  // getToken() async {
  //   final token = await FirebaseMessaging.instance.getToken();
  // }

  TextEditingController notesController = TextEditingController();

  final controller = Get.put(Controller());
  var _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
    });
    super.initState();
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TO-DO"),
      ),
      body: GetBuilder<Controller>(
          id: "update",
          builder: (controller) {
            return _getMessageList();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogogBox();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> dialogogBox() {
    return Get.defaultDialog(
      radius: 30,
      confirm: TextButton(
        onPressed: () async {
          if (titleController.isBlank!) {
            Get.snackbar("ADD NOTES", "WRITE SOMETHING",snackPosition: SnackPosition.BOTTOM);
          }
          controller.saveMessage(titleController.text);
          Get.back();
          flutterLocalNotificationsPlugin.show(
            0,
            "Added",
            "New Task Added",
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ),
          );
        },
        child: const Text("Save"),
      ),
      title: "NOTE",
      content: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: 'NOTE',
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMessageList() {
    return Column(
      children: [
        Expanded(
          child: FirebaseAnimatedList(
            controller: _scrollController,
            query: controller.getMessageQuery(),
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value;
              final message = Todomodel.fromMap(json);
              controller.todo = snapshot.children.toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.todo.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(message.title!),
                      trailing: IconButton(
                          onPressed: () {
                            controller.deleteTodo(snapshot.key!, index);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
