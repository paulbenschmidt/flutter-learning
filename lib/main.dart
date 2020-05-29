import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screens.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            // Other providers depend on Auth, so always make Auth come first
            create: (ctx) =>
                Auth(), //normal ChangeNotifier is now create instead of builder for provider package 4 or higher
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //ChangeNotifierProxyProvider is now update instead of builder for provider package 4 or higher
            create: (_) => Products('', []),
            update: (ctx, auth, previousProducts) => Products(auth.token,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routename: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
