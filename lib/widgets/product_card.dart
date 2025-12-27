import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(child: Image.network(product.images[0], width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}