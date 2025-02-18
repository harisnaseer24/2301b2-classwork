import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
   String query='';
   SearchPage(String text, {super.key, required this.query});
        Stream<QuerySnapshot> searchresult= FirebaseFirestore.instance.collection("products").where('title', isEqualTo: '').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("products").where('title', isEqualTo: query).snapshots(), builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              DocumentSnapshot products = snapshot.data!.docs[index];
              return ListTile(
                title: Text(products['title']),
                subtitle: Text(products['description']),
                trailing: Text(products['price'].toString()),
              );
            },
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      }),
    );
  }
}