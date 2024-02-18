import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/colors.dart';

class CaseChat extends StatefulWidget {
  final String id;
  const CaseChat(this.id, {Key? key}) : super(key: key);

  @override
  _CasechatState createState() => _CasechatState();
}

class _CasechatState extends State<CaseChat> {
  TextEditingController chatmessage = TextEditingController();

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      try {
        Reference storageRef = FirebaseStorage.instance
            .ref('chat_files/${widget.id}')
            .child(DateTime.now().toString() + file.name);
        UploadTask uploadTask = storageRef.putFile(File(file.path!));
        await uploadTask.whenComplete(
          () async {
            await FirebaseFirestore.instance
                .collection('cases')
                .doc(widget.id)
                .collection('chat')
                .add(
              {
                'sender': await FirebaseAuth.instance.currentUser!.uid,
                'message': chatmessage.text + file.name,
                'time': DateTime.now(),
                'url': await storageRef.getDownloadURL(),
                'content': 'file',
              },
            );
            chatmessage.clear();

            setState(() {});
          },
        );
      } catch (e) {
        print('Error uploading file: $e');
      }
    } else {
      print('User canceled file picker');
      Get.snackbar('Error', 'User canceled file picker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 100,
        title: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                      color: thirdColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WhistleIt",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "Chat",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cases')
              .doc(widget.id)
              .collection('chat')
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    if (documentSnapshot['sender'] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            height: 45,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (documentSnapshot['content'] == 'file') {
                                      launchUrlString(documentSnapshot['url']);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        documentSnapshot['message'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  DateFormat('dd-MM-yyy kk:mm').format(
                                    documentSnapshot['time'].toDate(),
                                  ),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            height: 40,
                            decoration: BoxDecoration(
                                color: thirdColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (documentSnapshot['content'] == 'file') {
                                      launchUrlString(documentSnapshot['url']);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        documentSnapshot['message'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  DateFormat('dd-MM-yyy kk:mm').format(
                                    documentSnapshot['time'].toDate(),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  });
            }
          }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: MediaQuery.of(context).viewInsets,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatmessage,
                cursorColor: Colors.black,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Enter Message to Send...',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: secondaryColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pickFile();
              },
              child: Icon(
                Icons.attach_file_outlined,
                color: secondaryColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () async {
                if (chatmessage.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('cases')
                      .doc(widget.id)
                      .collection('chat')
                      .add(
                    {
                      'sender': FirebaseAuth.instance.currentUser!.uid,
                      'url': '',
                      'message': chatmessage.text,
                      'time': DateTime.now(),
                      'content': 'text',
                    },
                  );
                  chatmessage.clear();
                }
              },
              child: Icon(
                Icons.send_rounded,
                color: secondaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
