import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  CollectionReference products= FirebaseFirestore.instance.collection('products');
String  myImage='';
  final ImagePicker picker = ImagePicker();


getImage() async{
// Pick an image.
final XFile? image = await picker.pickImage(source: ImageSource.gallery);

final Uint8List bytesImage = await image!.readAsBytes();//bytes array

        final String img64 = base64Encode(bytesImage);//base 64 string 
          setState(() {
         myImage = img64;
        //  print(bytesImage);
        //  print(myImage);
            // print("done");
       
          });
}


  Future<void> addProduct(){
    String productName = _productNameController.text;
    String productDesc = _productDescController.text;
    int productPrice =int.parse( _productPriceController.text);
    
    products.add({
      'title':productName,
      'description':productDesc,
      'price':productPrice,
      'image':myImage,
    });
    return Future.value();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Products"),),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productDescController,
              decoration: InputDecoration(
                labelText: "Product Description",
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productPriceController,
              decoration: InputDecoration(
                labelText: "Product Price",
                border: OutlineInputBorder()
              ),
            ),
          ),
          // image
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
             
                onPressed: getImage,
                child: Text("Choose Image"),
              ),
            ),
            // if image is empty then it will create text widget otherwise image
            myImage==''? Text("No image selected"):Image.memory(base64Decode(myImage),height: 100,),
        
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: addProduct, child: Text("Add Product")),
          )
        ],

      ),

    );
  }
}