import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  // REQUIREMENT 5.5: Firestore structure for Carts
  void _addToCart(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(uid)
          .collection('items')
          .doc(product.id.toString())
          .set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images[0],
        'quantity': 1, // Default quantity
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to Cart!")),
      );
    }
  }

  // REQUIREMENT 5.5: Firestore structure for Favorites
  void _addToFavorites(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(uid)
          .collection('items')
          .doc(product.id.toString())
          .set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images[0],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to Favorites!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.images[0], width: double.infinity, height: 300, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("\$${product.price}", style: const TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addToCart(context),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => _addToFavorites(context),
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}