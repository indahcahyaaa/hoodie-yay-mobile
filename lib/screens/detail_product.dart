import 'package:flutter/material.dart';
import 'package:hoodie_yay/models/product_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.fields.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: ${product.fields.price}",
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 10),
            Text(
              "Description: ${product.fields.description}",
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 10),
            Text(
              "Stock: ${product.fields.stock}",
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}