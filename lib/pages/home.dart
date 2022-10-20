import 'dart:convert';

import 'package:ecommerce_frontend/apis/ecommerce_api.dart';
import 'package:ecommerce_frontend/pages/category_details.dart';
import 'package:ecommerce_frontend/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<List<dynamic>> fetchData() async {
    http.Response response = await http.get(Uri.parse(Api.productApi));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // data.forEach((toDo) {
        //   ToDo t = ToDo(
        //       id: toDo['id'],
        //       title: toDo['title'],
        //       desc: toDo['desc'],
        //       isDone: toDo['isDone'],
        //       date: toDo['date']);
        //   myToDo.add(t);
        // });

        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error');
  }

  final TextEditingController _textEditingController = TextEditingController();
  String imageUrl = '';
  bool check = false;

  @override
  Widget build(BuildContext context) {
    final RemoteService remoteService = RemoteService();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Enter product name'),
            onChanged: (value) {
              setState(() {
                value = _textEditingController.text;
                check = true;
                if (_textEditingController.text.isEmpty) {
                  check = false;
                }
              });
            },
            onSaved: (newValue) {},
          ),
          check
              ? Expanded(
                  child: FutureBuilder(
                  future:
                      remoteService.searchProduct(_textEditingController.text),
                  builder: ((context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No Such Product'));
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: ((context, index) {
                          return Card(
                              child: ListTile(
                                  title: Text(
                                      snapshot.data![index]['name'].toString()),
                                  subtitle: Image.network(
                                      snapshot.data![index]['get_image'])));
                        }));
                  }),
                ))
              : Container(),
          Container(
              margin: const EdgeInsets.all(8),
              child: const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          Container(
            height: 50,
            margin: const EdgeInsets.all(8),
            child: FutureBuilder(
                future: remoteService.fetchCategoryData(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return PageView.builder(
                      padEnds: false,
                      itemCount: snapshot.data!.length,
                      controller: PageController(viewportFraction: 0.5),
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => CategoryDetail(
                                          slug: snapshot.data![index]['slug'],
                                          categoryname: remoteService
                                              .myProduct[index].name,
                                        ))));
                          }),
                          child: Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width - 20,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  snapshot.data![index]['name'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                              )),
                        );
                      }));
                })),
          ),
          Expanded(
            child: FutureBuilder(
              future: remoteService.fetchData(),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      imageUrl = (snapshot.data![index]['get_image']);
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete_forever),
                        ),
                        onDismissed: (direction) {
                          //mydelete(snapshot.data![index]['id'].toString());
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                            fetchData();
                          });
                        },
                        key: ValueKey<int>(snapshot.data![index]['id']),
                        child: Card(
                            child: ListTile(
                                title: Text(
                                    snapshot.data![index]['name'].toString()),
                                subtitle: Image.network(
                                    snapshot.data![index]['get_image']))),
                      );
                    }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
