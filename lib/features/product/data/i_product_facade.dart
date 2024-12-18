

import 'package:dartz/dartz.dart';
import 'package:product_details/features/product/data/model/product_model.dart';
import 'package:product_details/general/failure/main_failure.dart';

abstract class IProductFacade {
  Future<Either<MainFailure,ProductModel>> addProducts({required ProductModel productModel,})async{
  throw UnimplementedError('error');
}

Future<Either<MainFailure,List<ProductModel>>> fetchProducts ()async{
  throw UnimplementedError('error');
}
}