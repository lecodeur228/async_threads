import 'dart:convert';
import 'package:async_thread_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:async_thread_app/models/product.dart';

Future<List<Product>> fetchProducts(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // parse les données
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Erreur durant le chargement des produits');
  }
}

Future<List<User>> fetchUsers(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // parse les données
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> results =
        data['results']; // La liste se trouve sous la clé 'results'

    return results.map((item) {
      return User.fromJson({
        "name": item['login']['username'],
        "phone": item['phone'],
        "image": item['picture']['thumbnail'],
      });
    }).toList();
  } else {
    throw Exception('Erreur durant le chargement des produits');
  }
}

Future<List<dynamic>> fetchInIsolate(
    ComputeCallback<String, List<dynamic>> fetchFunction, String url) async {
  return compute(fetchFunction, url);
}
