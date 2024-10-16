import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giuaki/pages/product.dart';
import 'package:giuaki/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Stream? productStream;

  getontheload() async {
    productStream = await DatabaseMethods().getProductDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  //lấy dữ liệu từ firebase vào home
  // ----------------------------------------------
  Widget allProductDetails() {
    return StreamBuilder(
      stream: productStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Name: " + ds["name"],
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  nameController.text = ds["name"];
                                  categoryController.text = ds["category"];
                                  priceController.text = ds["price"];
                                  EditProductDetail(ds["id"]);
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.pink,
                                )),
                            SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Xác nhận"),
                                      content: Text(
                                          "Bạn có chắc chắn muốn xóa sản phẩm này?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Hủy"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            DatabaseMethods()
                                                .deleteProductDetails(ds["id"]);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Category: " + ds["category"],
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Price: " + ds["price"],
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

//Edit dữ liệu từ firebase
// ----------------------------------------------
  Future EditProductDetail(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      "Edit Product",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter product name",
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "Enter product category",
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    hintText: "Enter product price",
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> updateInfo = {
                      "name": nameController.text,
                      "category": categoryController.text,
                      "price": priceController.text,
                      "id": id
                    };
                    await DatabaseMethods()
                        .updateProductDetails(id, updateInfo)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      );

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
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Management",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            Expanded(child: allProductDetails()),
          ],
        ),
      ),
    );
  }
}
