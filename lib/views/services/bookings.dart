import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  
  final data;
  BookingScreen({super.key, this.data});

  @override
  State<BookingScreen> createState() => _BookingScreenState();

}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FirestorePagination(
                //item builder type is compulsory.
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots.data() as Map?;
                  return Container(child: Text(data!["post_title"]),);
                },
                limit: 5,
                // orderBy is compulsory to enable pagination
                query: FirebaseFirestore.instance.collection('bookings')
                .where("booker_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(10),
                //Change types accordingly
                viewType: ViewType.list,
                // to fetch real-time data
                isLive: true,
              ),
    );
  }
}
