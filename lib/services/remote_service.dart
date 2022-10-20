import 'dart:convert';

import 'package:ecommerce_frontend/apis/ecommerce_api.dart';
import 'package:ecommerce_frontend/models/product_model.dart' as model;
import 'package:ecommerce_frontend/utilis/utilis.dart';

import 'package:http/http.dart' as http;

class RemoteService {
  List<model.Product> myProduct = [];
  Future<List<dynamic>> fetchData() async {
    http.Response response = await http.get(Uri.parse(Api.productApi));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data.forEach((toDo) {
          model.Product t = model.Product(
              id: toDo['id'].toString(),
              name: toDo['name'],
              category: toDo['category'],
              getAbsoluteUrl: toDo['get_absolute_url'],
              description: toDo['description'],
              price: toDo['price'],
              getImage: toDo['get_image'],
              getThumbnail: toDo['get_thumbnail']);
          myProduct.add(t);
        });

        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error');
  }

  Future<void> postProduct(String title, String desc) async {
    try {
      final response = await http.post(
        Uri.parse(Api.productApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"title": title, "desc": desc, "isDone": false}),
      );

      if (response.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        fetchData();
      } else {
        throw Exception('Failed to create album.');
      }
    } catch (e) {
      Utilis.toatsMessage(e.toString());
    }
  }

  Future<void> updateProductData(
      String title, String desc, int index, int id) async {
    try {
      final response = await http.put(
        Uri.parse('${Api.productApi}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "title": title,
          "desc": desc,
          "isDone": index == 1 ? false : true
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        fetchData();
      } else {
        throw Exception('Failed to create album.');
      }
    } catch (e) {
      Utilis.toatsMessage(e.toString());
    }
  }

  mydelete(String id) async {
    try {
      await http.delete(Uri.parse('${Api.productApi}/$id'));
    } catch (e) {
      Utilis.toatsMessage(e.toString());
    }
  }

  Future<List<dynamic>> fetchCategoryData() async {
    http.Response response = await http.get(Uri.parse(Api.categoryApi));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      Utilis.toatsMessage(e.toString());
    }
    throw Exception('Error');
  }

  Future<List<dynamic>> fetchCategoryDetail(String slug) async {
    http.Response response =
        await http.get(Uri.parse(Api.categoryDetails + slug));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));

        return data['products'];
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error');
  }

  Future<Map<String, dynamic>> fetchCategoryDetail2(String slug) async {
    http.Response response =
        await http.get(Uri.parse(Api.categoryDetails + slug));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));

        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error');
  }

  Future<List<dynamic>> searchProduct(String title) async {
    try {
      final response = await http.post(
        Uri.parse(Api.searchProduct),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"query": title}),
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error');
  }
}
