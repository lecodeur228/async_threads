import 'package:async_thread_app/models/product.dart';
import 'package:async_thread_app/models/user.dart';
import 'package:async_thread_app/services/fakestore_service.dart';
import 'package:async_thread_app/widgets/product_card.dart';
import 'package:flutter/material.dart';

class BackgroundIsolate extends StatefulWidget {
  const BackgroundIsolate({super.key});

  @override
  State<BackgroundIsolate> createState() => _BackgroundIsolateState();
}

class _BackgroundIsolateState extends State<BackgroundIsolate> {
  List<Product> products = [];
  List<User> users = [];
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        fetchInIsolate(fetchProducts, 'https://fakestoreapi.com/products/'),
        fetchInIsolate(fetchUsers, 'https://randomuser.me/api/'),
      ]);
      print(results);
      setState(() {
        products = results[0] as List<Product>;
        users = results[1] as List<User>;
      });
    } catch (e) {
      print("Erreur : $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          title: const Text(
            "Async-Threads",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "Produits"),
              Tab(text: "Utilisateurs"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // Section 1 : Affichage des produits
                  products.isEmpty
                      ? const Center(
                          child: Text("Aucun produit disponible."),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Nombre de colonnes
                            crossAxisSpacing:
                                8.0, // Espacement entre les colonnes
                            mainAxisSpacing: 8.0, // Espacement entre les lignes
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                            );
                          },
                        ),
                  // Section 2 : Affichage des utilisateurs
                  users.isEmpty
                      ? const Center(
                          child: Text("Aucun utilisateur disponible."),
                        )
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.image),
                                  radius: 30,
                                  onBackgroundImageError: (error, stackTrace) =>
                                      const Icon(Icons.person, size: 30),
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(user.phone),
                              ),
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
