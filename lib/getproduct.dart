import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbpractice/searchproduct.dart';
import 'package:dbpractice/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  var products = FirebaseFirestore.instance.collection("products");
TextEditingController searchController= TextEditingController();



  // Function to add a product
  void _addProduct() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await products.add({
                  "title": titleController.text,
                  "description": descController.text,
                  "price": double.parse(priceController.text),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product added successfully!")),
                );
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
}


  // Function to delete a product
  void _deleteProduct(String productId) async {
    await products.doc(productId).delete();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Product deleted successfully!")),
    );
  }

  // Function to edit a product
  void _editProduct(String productId, String currentTitle, String currentDesc, double currentPrice) {
    TextEditingController titleController = TextEditingController(text: currentTitle);
    TextEditingController descController = TextEditingController(text: currentDesc);
    TextEditingController priceController = TextEditingController(text: currentPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await products
                    .doc(productId)
                    .update({
                  "title": titleController.text,
                  "description": descController.text,
                  "price": double.parse(priceController.text),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product updated successfully!")),
                );
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetching Products Firestore"),
        actions: [
          GestureDetector(
            child: Icon(Icons.add),
            onTap: () {
              Navigator.pushNamed(context, '/add');
            },),
          GestureDetector(
            child: Icon(Icons.logout),
            onTap: () async{
                await FirebaseAuth.instance.signOut();
                   final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    print("user logged out");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signin()));
            },
          ),
        ],
      ),
   
    body: StreamBuilder(
  stream: products.snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      if (snapshot.hasData) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search Product",
                      hintText: "Search Product",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          searchController.text,
                          query: searchController.text,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                )
              ],
            ),
            // Wrap ListView in Expanded
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  var productId = doc.id;
                  return ListTile(
                    title: Text(doc["title"]),
                    subtitle: Text(doc["description"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editProduct(productId, doc["title"], doc["description"], doc["price"]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProduct(productId);
                          },
                        ),
                      ],
                    ),
                    leading: Image.memory(base64Decode(doc['image']), height: 40,),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return Center(child: Text("No products available."));
      }
    } else {
      return Center(child: Text("Data not accessible."));
    }
  },
),

    );
  }
}
