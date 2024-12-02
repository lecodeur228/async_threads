import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:async_thread_app/widgets/appbar.dart';
import 'package:async_thread_app/services/fakestore_service.dart';
import 'package:async_thread_app/widgets/productcard.dart';
import 'package:async_thread_app/models/product.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts =
        fetchProducts(); // Récupérer les produits lors du démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Async-Threads'),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer(); // Affiche le shimmer pendant le chargement des produits
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun produit disponible'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de colonnes
                crossAxisSpacing: 8.0, // Espacement entre les colonnes
                mainAxisSpacing: 8.0, // Espacement entre les lignes
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ProductCard(
                  image: product.image,
                  title: product.title,
                  category: product.category,
                  price: product.price,
                );
              },
            );
          }
        },
      ),
    );
  }

  // Méthode pour afficher un shimmer pendant le chargement des produits
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 10, // Nombre d'éléments à afficher
        itemBuilder: (context, index) {
          return _buildShimmerCard();
        },
      ),
    );
  }

  //construire un widget shimer pour un produit
  Widget _buildShimmerCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image
          Container(
            width: double.infinity,
            height: 120,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          //titre
          Container(
            width: double.infinity,
            height: 14,
            color: Colors.white,
          ),
          SizedBox(height: 4),
          //catégorie
          Container(
            width: 100,
            height: 12,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          //le prix
          Container(
            width: 80,
            height: 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
