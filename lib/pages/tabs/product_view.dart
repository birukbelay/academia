import 'package:academia1/pages/tabs/product_edit.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatelessWidget {
  Function updateProduct;
  Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductViewPage(this.products, this.updateProduct, this.deleteProduct);

//========================= Widget EditButton ====================
  Widget _editButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage(
            product: products[index],
            updateProduct: updateProduct,
            productIndex: index,
          );
        }));
      },
    );
  }

//  =========================   Widget _listProduct ====================
  Widget _listProduct(context, index) {
    return Dismissible(
      key: Key(products[index]['title']),
      background: Container(
        color: Colors.red,
      ),

//      ================ onDismissed Function -------------------

      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          deleteProduct(index);
        }
      },
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(products[index]['image']),
            ),
            title: Text(products[index]['title']),
            subtitle: Text('\$${products[index]['price']}'),
            trailing: _editButton(context, index),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          _listProduct(context, index),
      itemCount: products.length,
    );
  }
}
