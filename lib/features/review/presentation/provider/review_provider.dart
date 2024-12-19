import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_details/features/review/data/i_review_facade.dart';
import 'package:product_details/features/review/data/model/review_model.dart';

class ReviewProvider with ChangeNotifier {
  final IReviewFacade iReviewFacade;
  ReviewProvider({required this.iReviewFacade});

  final commentController = TextEditingController();
  final ratingController = TextEditingController();

  bool isFetching = false;

  List<ReviewModel> reviewList = [];

  Future<void> addReviews({required String productId}) async {
    final rating = int.tryParse(ratingController.text.trim());
    final result = await iReviewFacade.addReview(
        productId: productId,
        reviewModel: ReviewModel(
            productId: productId,
            comment: commentController.text.trim(),
            rating: rating!,
            createdAt: Timestamp.now()));

    result.fold(
      (failure) {
        log(failure.errorMessage);
      },
      (success) {
        log('Review Added Succesfully');
        addLocally(success);
      },
    );
  }

  Future<void> fetchReviews({required String productId}) async {
    isFetching = true;
    notifyListeners();
    final result = await iReviewFacade.fetchReviews(productId: productId);

    result.fold(
      (failure) {
        log(failure.errorMessage);
      },
      (success) {
        reviewList.clear();
        reviewList.addAll(success);
      },
    );
    isFetching = false;
    notifyListeners();
  }

  void clearList() {
    reviewList = [];
    notifyListeners();
  }

  void addLocally(ReviewModel reviewModel) {
    reviewList.insert(0, reviewModel);
  }

  Future<void> deleteReviews(
      {required String productId, required String reviewId}) async {
    final result = await iReviewFacade.deleteReviews(
        productId: productId, reviewId: reviewId);

    result.fold(
      (failure) {
        log(failure.errorMessage);
      },
      (success) {
        reviewList.removeWhere((review) => review.id == reviewId);
        log('delete reviews');
        notifyListeners();
      },
    );
  }
}
