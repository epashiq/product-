import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_details/features/product/presentation/provider/product_provider.dart';
import 'package:product_details/features/review/presentation/view/review_page.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.fetchProducts();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!productProvider.isLoading && !productProvider.noMoreData) {
          productProvider.fetchProducts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ProductProvider>(
        builder: (context, proProvider, child) {
          if (proProvider.isLoading && proProvider.productList.isEmpty) {
            return const CircularProgressIndicator();
          } else if (proProvider.productList.isEmpty) {
            return const Text('No product available');
          } else {
            return GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: proProvider.productList.length,
              itemBuilder: (context, index) {
                final pro = proProvider.productList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            productId: pro.id!,
                          ),
                        ));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product : ${pro.product}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("Prize : ₹${pro.prize}"),
                          const SizedBox(height: 5),
                          Text(
                            pro.descreption,
                          ),
                          Text("Stock: ${pro.stock}"),
                          Text('Colour : ${pro.details.colour}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add products"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: productProvider.productController,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: productProvider.prizeController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Prize",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: productProvider.descreptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: productProvider.stockController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Stock",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: productProvider.colourController,
                      decoration: InputDecoration(
                        labelText: "Color",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: productProvider.materialController,
                      decoration: InputDecoration(
                        labelText: "Material",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await productProvider.addProducts(
                        colour: productProvider.colourController.text,
                        material: productProvider.materialController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
