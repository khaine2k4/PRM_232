import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "app_router.dart";
import "providers/auth_provider.dart";
import "providers/cart_provider.dart";
import "providers/order_provider.dart";
import "providers/product_provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthProvider();
  await auth.loadSession();
  runApp(ShopApp(auth: auth));
}

class ShopApp extends StatefulWidget {
  final AuthProvider auth;
  const ShopApp({super.key, required this.auth});

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late final router = buildRouter(widget.auth);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.auth),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp.router(
        title: "Shop App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
