import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() { _allProducts = products; _filteredProducts = products; _isLoading = false; });
    } catch (e) { setState(() => _isLoading = false); }
  }

  void _search(String q) {
    setState(() { _filteredProducts = _allProducts.where((p) => p.title.toLowerCase().contains(q.toLowerCase())).toList(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laza Catalog")),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(onChanged: _search, decoration: const InputDecoration(hintText: "Search...", prefixIcon: Icon(Icons.search), border: OutlineInputBorder())),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: _filteredProducts.length,
              itemBuilder: (c, i) => ProductCard(
                product: _filteredProducts[i],
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailScreen(productId: _filteredProducts[i].id))),
              ),
            ),
          )
        ],
      ),
    );
  }
}