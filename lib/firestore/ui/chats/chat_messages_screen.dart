import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:restaurants/firestore/data/firestore_helper.dart';
import 'package:restaurants/firestore/models/chat.dart';
import 'package:restaurants/firestore/models/gd_user.dart';
import 'package:restaurants/firestore/models/message.dart';
import 'package:restaurants/firestore/providers/app_provider.dart';
import 'package:provider/provider.dart';

class AllChatMessagesScreen extends StatelessWidget {
  Chat chat;
  GdUser otherUser;
  AllChatMessagesScreen({this.chat, this.otherUser});
  TextEditingController textEditingController = TextEditingController();
  String setChatId() {
    String chatId;
    String myId = FirebaseAuth.instance.currentUser.uid;
    int myIdHash = myId.hashCode;
    int otherUserHash = otherUser.id.hashCode;

    if (myIdHash > otherUserHash) {
      chatId = myId + '_' + (otherUser.id);
    } else {
      chatId = (otherUser.id) + '_' + myId;
    }
    return chatId;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<AppProvider>(builder: (context, provider, x) {
      return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/back.png'),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirestoreHelper.firestoreHelper
                      .getChatMessages(chat?.chatId ?? setChatId()),
                  builder: (context, dataSnapShot) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        snapshots = dataSnapShot.data?.docs ?? [];
                    return Container(
                      child: ListView.builder(
                          itemCount: snapshots.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 2),
                              child: Row(
                                mainAxisAlignment: snapshots[index]
                                            ['senderId'] ==
                                        provider.myUser.id
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  ChatBubble(
                                    backGroundColor: snapshots[index]
                                                ['senderId'] ==
                                            provider.myUser.id
                                        ? Colors.orangeAccent
                                        : Colors.blueAccent,
                                    clipper: ChatBubbleClipper5(
                                        type: snapshots[index]['senderId'] ==
                                                provider.myUser.id
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble),
                                    child: Text(snapshots[index]['content']),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  },
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        String chatId;
                        if (otherUser != null) {
                          chatId = setChatId();
                        } else {
                          chatId = this.chat.chatId;
                        }
                        Message message = Message(
                            content: textEditingController.text,
                            senderId: provider.myUser.id,
                            chatId: chatId);
                        provider.sendMessage(message, otherUser);
                      },
                      child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(Icons.send)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
