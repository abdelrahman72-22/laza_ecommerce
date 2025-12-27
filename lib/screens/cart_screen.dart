import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // CHECKLIST REQ: Update quantity works
  void _updateQty(DocumentReference doc, int currentQty, int change) {
    if (currentQty + change > 0) {
      doc.update({'quantity': currentQty + change});
    }
  }

  // CHECKLIST REQ: Cart clears after checkout
  void _checkout(BuildContext context, String uid) async {
    var items = await FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .collection('items')
        .get();
        
    for (var doc in items.docs) {
      await doc.reference.delete();
    }
    
    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const SuccessScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("Cart is empty")); // REQ: Empty state

          double subtotal = 0;
          for (var d in docs) {
            subtotal += (d['price'] * d['quantity']);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var item = docs[index];
                    return ListTile(
                      leading: Image.network(item['image'], width: 50),
                      title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text("\$${item['price']}"),
                      // CHECKLIST REQ: Update quantity + Remove item
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _updateQty(item.reference, item['quantity'], -1),
                          ),
                          Text("${item['quantity']}"),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _updateQty(item.reference, item['quantity'], 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => item.reference.delete(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // CHECKLIST REQ: Cart screen shows subtotal
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal:", style: TextStyle(fontSize: 18)),
                        Text("\$${subtotal.toStringAsFixed(2)}", 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _checkout(context, uid),
                        child: const Text("Checkout"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}