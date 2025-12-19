import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'success_screen.dart'; // Import the success screen we created

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // REQUIREMENT 5.5: Checkout Logic
  // 1. Clears the cart in Firestore
  // 2. Navigates to the Success Screen
  void _checkout(BuildContext context, String uid) async {
    try {
      var cartRef = FirebaseFirestore.instance
          .collection('carts')
          .doc(uid)
          .collection('items');

      var items = await cartRef.get();

      // Delete each item in the cart
      for (var doc in items.docs) {
        await doc.reference.delete();
      }

      // Requirement 5.5: Navigate to Success Screen only
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during checkout")),
      );
    }
  }

  // Helper to update quantity in Firestore (Requirement 5.5)
  void _updateQuantity(DocumentReference ref, int currentQty, int delta) {
    if (currentQty + delta > 0) {
      ref.update({'quantity': currentQty + delta});
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Listen to Firestore real-time updates
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          // Requirement 5.8: Loading Indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Requirement 5.8: Empty State for Cart
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("Your cart is empty", 
              style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          // Calculate Subtotal (Requirement 5.5)
          double subtotal = 0;
          for (var doc in docs) {
            subtotal += (doc['price'] * doc['quantity']);
          }

          return Column(
            children: [
              // List of Cart Items
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var item = docs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item['image'], 
                        width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(item['title'], 
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text("\$${item['price']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Quantity Selector (Requirement 5.5)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _updateQuantity(item.reference, item['quantity'], -1),
                          ),
                          Text("${item['quantity']}", 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _updateQuantity(item.reference, item['quantity'], 1),
                          ),
                          // Remove Item
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => item.reference.delete(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Checkout Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), 
                    blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal:", 
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                          Text("\$${subtotal.toStringAsFixed(2)}", 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Requirement 5.5: Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _checkout(context, uid),
                          child: const Text("Checkout", 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}