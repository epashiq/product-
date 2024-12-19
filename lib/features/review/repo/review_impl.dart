import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:product_details/features/review/data/i_review_facade.dart';
import 'package:product_details/features/review/data/model/review_model.dart';
import 'package:product_details/general/failure/main_failure.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IReviewFacade)
class ReviewImpl implements IReviewFacade {
  final FirebaseFirestore firebaseFirestore;
  ReviewImpl(this.firebaseFirestore);
  @override
  Future<Either<MainFailure, ReviewModel>> addReview(
      {required String productId, required ReviewModel reviewModel}) async {
    try {
      final reviewRef = firebaseFirestore.collection('product').doc(productId);

      final reviewId = const Uuid().v4();

      await reviewRef.update(
          {'review.$reviewId': reviewModel.copyWith(id: reviewId).toMap()});

      return right(reviewModel.copyWith(id: reviewId));
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, List<ReviewModel>>> fetchReviews(
      {required String productId}) async {
    try {
      final reviewRef =
          await firebaseFirestore.collection('product').doc(productId).get();

      if (reviewRef.exists) {
        final reviewData = reviewRef.data();

        final Map<String, dynamic> reviewMap =
            Map<String, dynamic>.from(reviewData?['review'] ?? {});

        List<ReviewModel> reviewList = [];
        reviewMap.forEach((key, value) {
          final review = ReviewModel.fromMap(value);
          reviewList.add(review);
        });

        return right(reviewList);
      } else {
        return right([]);
      }
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, void>> deleteReviews(
      {required String productId, required String reviewId}) async {
    try {
      final reviewRef = firebaseFirestore.collection('product').doc(productId);

      await reviewRef.update({'review.$reviewId': FieldValue.delete()});

      return right(null);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }
}
