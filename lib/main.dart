import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // The ChangeNotifierProvider creates a single instance of Cart and makes it
      // available to all descendant widgets. The create function is called once,
      // so we have a single shared cart and context is passed to it so our provider
      // (Cart) knows where it is in the widget tree.
      create: (BuildContext context) {
        return Cart();
      },
      child: const MaterialApp(
        title: 'Sandwich Shop App',
        // We’ve also added debugShowCheckedModeBanner: false to remove the debug
        // banner from the app. This is a purely aesthetic change.
        debugShowCheckedModeBanner: false,
        home: OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
