import 'package:dartz/dartz.dart';
import 'package:product_details/features/review/data/model/review_model.dart';
import 'package:product_details/general/failure/main_failure.dart';

abstract class IReviewFacade {
  Future<Either<MainFailure, ReviewModel>> addReview(
      {required String productId, required ReviewModel reviewModel}) async {
    throw UnimplementedError('error');
  }

  Future<Either<MainFailure, List<ReviewModel>>> fetchReviews(
      {required String productId}) async {
    throw UnimplementedError('error');
  }

  Future<Either<MainFailure, void>> deleteReviews(
      {required String productId, required String reviewId}) async {
    throw UnimplementedError('error');
  }
}
