import 'package:flutter/material.dart';
import 'package:product_details/features/product/data/i_product_facade.dart';
import 'package:product_details/features/product/presentation/provider/product_provider.dart';
import 'package:product_details/features/product/presentation/view/product_page.dart';
import 'package:product_details/general/di/injection.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductProvider(sl<IProductFacade>()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ProductPage(),
      ),
    );
  }
}
