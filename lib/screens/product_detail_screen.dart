import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  // REQ: Fetch specific details by ID
  void _fetchDetails() async {
    try {
      final res = await ApiService().fetchProductById(widget.productId);
      setState(() { product = res; isLoading = false; });
    } catch (e) { setState(() => isLoading = false); }
  }

  void _addToCart() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('carts').doc(uid).collection('items').doc(product!.id.toString()).set({
      'id': product!.id, 'title': product!.title, 'price': product!.price, 'image': product!.images[0], 'quantity': 1,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added!")));
  }

  void _addToFav() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('favorites').doc(uid).collection('items').doc(product!.id.toString()).set({
      'id': product!.id, 'title': product!.title, 'price': product!.price, 'image': product!.images[0],
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Favorited!")));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (product == null) return const Scaffold(body: Center(child: Text("Error")));

    return Scaffold(
      appBar: AppBar(title: Text(product!.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product!.images[0], height: 300, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("\$${product!.price}", style: const TextStyle(fontSize: 18, color: Colors.deepPurple)),
                  const SizedBox(height: 15),
                  Text(product!.description),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton(onPressed: _addToCart, child: const Text("Add to Cart"))),
                      IconButton(onPressed: _addToFav, icon: const Icon(Icons.favorite_border, color: Colors.red)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}