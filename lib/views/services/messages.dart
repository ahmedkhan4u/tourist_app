import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends StatefulWidget {

final data;

 Messages({super.key, this.data});

  @override
  State<Messages> createState() => _MessagesState();
}


class _MessagesState extends State<Messages> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          width: 24, height: 24,
          padding: EdgeInsets.all(8),
          child: ClipRRect( borderRadius: BorderRadius.circular(100),
          child: Image.network(
            widget.data["rec_image"], 
            fit: BoxFit.cover,),
          ),
        ),
        title: Text("Messages"),
      ),
      body: Column(children: [
        // ignore: sort_child_properties_last
        Expanded(child: Container(
          height: Get.height * 0.8,
          width: Get.width * 1,
          child: FirestorePagination(
              //item builder type is compulsory.
              
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots.data() as Map?;
                var currentUser = FirebaseAuth.instance.currentUser!.uid;
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: currentUser == data!["sender_id"] ? 60 : 0,
                      right: currentUser == data!["sender_id"] ? 0 : 60
                      ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    padding: EdgeInsets.all(8),
                    
                    child: Column(children: [
                      Row(
                        
                        mainAxisAlignment: currentUser == data!["sender_id"] ?
                         MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(data["message"], style: TextStyle(color: Colors.white, fontSize: 16),)
                      ],
                      )
                  ,
                      SizedBox(height: 16,),
                      Text(DateTime.fromMillisecondsSinceEpoch(data!["timestamp"])
                      .toUtc().toString().substring(0,10), style: TextStyle(color: Colors.white),)
                  
                    ]),
                  ),
                );
              },
              limit: 5,
              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance.collection('chats')
              .doc(widget.data["chat_id"]).collection("messages")
              .orderBy("timestamp", descending: true),
              //.limit(5),
              //Change types accordingly
              viewType: ViewType.list,
              reverse: true,
              // to fetch real-time data
              isLive: true,
            ),), flex: 5,),
        // ignore: sort_child_properties_last
        Expanded(child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(children: [
          Expanded(child: TextFormField(
            controller: controller,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              hintText: "Type here..."
            ),
          ), 
          ),
                    IconButton(icon: Icon(Icons.send), onPressed: () async {


                      final docId = FirebaseFirestore.instance.collection("messages")
                      .doc().id;

await FirebaseFirestore.instance.collection("chats")
                      .doc(widget.data["chat_id"]).set({
                        "group": [widget.data["rec_id"],
                         FirebaseAuth.instance.currentUser!.uid ],
                        "group_id": widget.data["chat_id"],
      
                        "last_msg": controller.text,
                      
                      });
                      await FirebaseFirestore.instance.collection("chats")
                      .doc(widget.data["chat_id"]).collection("messages").doc(docId).set({
                        "message": controller.text,
                        "timestamp": DateTime.now().millisecondsSinceEpoch,
                        "sender_id": FirebaseAuth.instance.currentUser!.uid,
                        "chat_id": widget.data["chat_id"],
                        "uid": docId
                      });

                                            controller.text = "";

                      setState(() {
                        
                      });
                    },)

        ]), ), flex: 1, ),
      
      ],),
    );
  }
}