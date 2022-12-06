import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app/views/services/messages.dart';

class Chats extends StatefulWidget {
  final data;
   Chats({super.key, this.data});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width * 1,
        height: Get.height * 1,
        padding: EdgeInsets.all(16),
        child: FirestorePagination(
                //item builder type is compulsory.
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots.data() as Map?;
                  return InkWell(
                    onTap: () {
                      var chatId = "";

                                if (widget.data["user_id"].hashCode > data["user_id"].hashCode) {
                                  chatId = "${widget.data["user_id"]}-${data["user_id"]}";
                                } else {
                                  chatId = "${data["user_id"]}-${widget.data["user_id"]}";
                                  print("Here");
                                }

                            

                                Get.to(() => Messages(data: {"chat_id": chatId, 
                                "rec_id": data["user_id"],
                                "rec_image":data["image"], "rec_name": data["name"]},));
                    },
                    child: Column(children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                            
                            
                              data!["image"],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                  
                          
                          ),
                          SizedBox(width: 16,),
                          Text(data["name"]),
                          
                        ],
                      ),

                      SizedBox(height: 16,),
                          Container(height: 1, color: Colors.blueGrey,),
                                                SizedBox(height: 16,),

    
                    ],),
                  );
                },
                limit: 5,
                // orderBy is compulsory to enable pagination
                query: kIsWeb ? FirebaseFirestore.instance.collection('users')
                .limit(5) : FirebaseFirestore.instance.collection('users')
                .where("user_id",  isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(5),
                //Change types accordingly
                viewType: ViewType.list,
                // to fetch real-time data
                isLive: true,
              ),
        
        ),
    );
  }
}