import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

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

  TextEditingController notesController = TextEditingController();

  final controller = Get.put(Controller());

  @override
  void initState() {
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
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text(notification.title!),
        //         content: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [Text(notification.body!)],
        //           ),
        //         ),
        //       );
        //     });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Todomodel>>(
        stream: controller.read(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            controller.todo = snapshot.data!;
            return GetBuilder<Controller>(
              id: "updated",
              builder: (controller) {
                return ListView.separated(
                  itemCount: controller.todo.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.todo[index].title.toString()),
                      trailing: IconButton(
                        onPressed: () {
                          controller
                              .delete(controller.todo[index].uid.toString());
                          controller.todo.removeAt(index);
                          controller.update(["updated"]);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            radius: 30,
            confirm: TextButton(
              onPressed: () async {
                controller.storedatabase(
                    titleController.text, notesController.text);

                Get.back();
                flutterLocalNotificationsPlugin.show(
                    0,
                    "Added",
                    "New Task Added",
                    NotificationDetails(
                        android: AndroidNotificationDetails(
                            channel.id, channel.name,
                            importance: Importance.high,
                            color: Colors.blue,
                            playSound: true,
                            icon: '@mipmap/ic_launcher')));
              },
              child: const Text("Save"),
            ),
            title: "Title",
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
                    hintText: 'Title',
                  ),
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Notes',
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
