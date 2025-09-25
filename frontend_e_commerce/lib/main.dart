import 'package:flutter/material.dart';
import 'package:frontend_e_commerce/controllers/cart_controller.dart';
import 'package:frontend_e_commerce/controllers/customer_controller.dart';
import 'package:frontend_e_commerce/controllers/invoice_controller.dart';
import 'package:frontend_e_commerce/controllers/item_controller.dart';
import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:frontend_e_commerce/models/item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend_e_commerce/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(InvoiceItemsAdapter());
  Hive.registerAdapter(ItemAdapter());

  await Hive.openBox<InvoiceItems>('cartBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemController()),
        ChangeNotifierProvider(create: (_) => CustomerController()..loadCustomers()),
        ChangeNotifierProvider(create: (_) => InvoiceController()),
        ChangeNotifierProvider(
          create: (_) =>
              CartController(cartBox: Hive.box<InvoiceItems>('cartBox'))
                ..loadCart(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      routerConfig: AppRouter.router,
    );
  }
}
