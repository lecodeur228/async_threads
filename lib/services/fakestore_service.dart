import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async_thread_app/models/product.dart';

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products/'));

  if (response.statusCode == 200) {
    // parse les données
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Erreur durant le chargement des produits');
  }
}
