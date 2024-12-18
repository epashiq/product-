import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:product_details/features/product/data/i_product_facade.dart';
import 'package:product_details/features/product/data/model/product_model.dart';
import 'package:product_details/general/failure/main_failure.dart';

@LazySingleton(as: IProductFacade)
class IProductImpl implements IProductFacade {
  final FirebaseFirestore firestore;
  IProductImpl({required this.firestore});

  DocumentSnapshot? lastDocument;
  bool noMoreData = false;

  @override
  Future<Either<MainFailure, ProductModel>> addProducts(
      {required ProductModel productModel,}) async {
    try {
      final productRef = firestore.collection('product');
      final id = productRef.doc().id;
      final product = productModel.copyWith(id: id);
      await productRef.doc(id).set(product.toMap());

      return right(product);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, List<ProductModel>>> fetchProducts() async {
    if (noMoreData) return right([]);
    try {
      Query query =
          firestore.collection('product').orderBy('product', descending: false);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.limit(10).get();

      if (querySnapshot.docs.length < 10) {
        noMoreData = true;
      } else {
        lastDocument = querySnapshot.docs.last;
      }

      final newList = querySnapshot.docs
          .map(
              (pro) => ProductModel.fromMap(pro.data() as Map<String, dynamic>))
          .toList();

      return right(newList);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }
}
