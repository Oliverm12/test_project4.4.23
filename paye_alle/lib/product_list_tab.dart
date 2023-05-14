import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'model/app_state_model.dart';
import 'product_row_item.dart';

class ProductListTab extends StatelessWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final products = model.getProducts();
        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
           /* const CupertinoSliverNavigationBar(
              largeTitle: Text('Cupertino Store'),
            ),*/
          SliverAppBar(
            backgroundColor: Color(0xff388e3c),
            title: Text('PayeAlle'),
            titleTextStyle: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w500,
            ),
            actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),],
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: CupertinoListSection(
                  topMargin: 0,
                  header: Text(''),
                  children: [
                    for (var product in products)
                      ProductRowItem(
                        product: product,
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
