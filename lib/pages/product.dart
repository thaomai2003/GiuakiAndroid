import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giuaki/services/database.dart';
import 'package:random_string/random_string.dart';

class Product extends StatefulWidget {
  const Product({super.key});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Product()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Product",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Form",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),

      // Add
      //----------------------------------------------
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            Container(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter product name",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Category",
              style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            Container(
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                    hintText: "Enter Category",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Price",
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            Container(
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(
                    hintText: "Enter price",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> ProductInfoMap = {
                    "name": nameController.text,
                    "category": categoryController.text,
                    "price": priceController.text,
                    "id": id
                  };
                  await DatabaseMethods()
                      .addProductDetails(ProductInfoMap, id)
                      .then((value) {
                    Fluttertoast.showToast(msg: "Thêm sản phẩm thành công");
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
