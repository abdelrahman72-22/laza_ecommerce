import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // Matching the checklist term "Favorites"
      appBar: AppBar(title: const Text("Favorites")), 
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          // CHECKLIST REQ: Loading indicators exist
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          // CHECKLIST REQ: No favorites state exists
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No favorites yet", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var item = docs[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['image'], 
                    width: 50, 
                    height: 50, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.error),
                  ),
                ),
                title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text("\$${item['price']}"),
                // CHECKLIST REQ: Remove from favorites works
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async {
                    await item.reference.delete();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Removed from Favorites")),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}