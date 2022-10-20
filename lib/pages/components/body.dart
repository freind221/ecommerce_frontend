import 'package:ecommerce_frontend/constants.dart';
import 'package:ecommerce_frontend/pages/detail_screen.dart';
import 'package:ecommerce_frontend/services/remote_service.dart';
import 'package:flutter/material.dart';

import 'categories.dart';
import 'item_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RemoteService remoteService = RemoteService();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "Women",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: FutureBuilder(
                future: remoteService.fetchData(),
                builder: (context, snapshot) {
                  return GridView.builder(
                      itemCount: remoteService.myProduct.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPaddin,
                        crossAxisSpacing: kDefaultPaddin,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(kDefaultPaddin),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Hero(
                                  tag:
                                      Text(remoteService.myProduct[index].name),
                                  child: Image.network(
                                    remoteService.myProduct[index].getImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPaddin / 4),
                              child: Text(
                                // products is out demo list
                                remoteService.myProduct[index].name,
                                style: const TextStyle(color: kTextLightColor),
                              ),
                            ),
                            Text(
                              "\$${remoteService.myProduct[index].price}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      });
                }),
          ),
        ),
      ],
    );
  }
}
