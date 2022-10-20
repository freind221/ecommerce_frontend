import 'package:ecommerce_frontend/services/remote_service.dart';
import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  final String slug;
  final String categoryname;
  const CategoryDetail(
      {super.key, required this.slug, required this.categoryname});

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RemoteService remoteService = RemoteService();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nakoora'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text("Category name is  ${widget.categoryname}"),
            Expanded(
              child: FutureBuilder(
                  future: remoteService.fetchCategoryDetail2(widget.slug),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('There is no data'));
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!['products'].length,
                        itemBuilder: ((context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(snapshot.data!['name']),
                              subtitle: Text(
                                  snapshot.data!['products'][index]['name']),
                            ),
                          );
                        }));
                  })),
            ),
          ],
        ));
  }
}
