// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String productId;
  String comment;
  int rating;
  Timestamp createdAt;
  ReviewModel({
    this.id,
    required this.productId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? productId,
    String? comment,
    int? rating,
    Timestamp? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] != null ? map['id'] as String : null,
      productId: map['productId'] as String,
      comment: map['comment'] as String,
      rating: map['rating'] as int,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
