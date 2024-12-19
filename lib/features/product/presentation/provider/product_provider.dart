import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_details/features/details/data/model/details_model.dart';
import 'package:product_details/features/product/data/i_product_facade.dart';
import 'package:product_details/features/product/data/model/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final IProductFacade iProductFacade;
  ProductProvider(this.iProductFacade);
  final productController = TextEditingController();
  final prizeController = TextEditingController();
  final descreptionController = TextEditingController();
  final stockController = TextEditingController();
  final colourController = TextEditingController();
  final materialController = TextEditingController();

  List<ProductModel> productList = [];
  bool isLoading = false;
  bool noMoreData = false;

  Future<void> addProducts(
      {required String colour, required String material}) async {
    final prize = int.tryParse(prizeController.text.trim());
    final stock = int.tryParse(stockController.text.trim());

    final id = const Uuid().v4();
    final results = await iProductFacade.addProducts(
      productModel: ProductModel(
          product: productController.text,
          descreption: descreptionController.text,
          prize: prize!,
          createdAt: Timestamp.now(),
          stock: stock!,
          details: DetailsModel(material: material, colour: colour, id: id)),
    );

    results.fold(
      (failuere) {
        log(failuere.toString());
      },
      (success) {
        log('Add product succesfully');
        addLocally(success);
      },
    );
  }

  Future<void> fetchProducts() async {
    if(isLoading||noMoreData) return;
    isLoading = true;
    notifyListeners();

    final result = await iProductFacade.fetchProducts();

    result.fold(
      (failuer) {
        log(failuer.toString());
      },
      (success) {
        productList.addAll(success);
        log('getting product succesfully');
      },
    );
    isLoading = false;
    notifyListeners();
  }

  void addLocally(ProductModel productModel) {
    productList.insert(0, productModel);
    notifyListeners();
  }
}
