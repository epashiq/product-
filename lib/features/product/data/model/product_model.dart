import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_details/features/details/data/model/details_model.dart';

class ProductModel {
  String? id;
  String product;
  String descreption;
  int prize;
  Timestamp createdAt;
  int stock;
  DetailsModel details;

  ProductModel({
    this.id,
    required this.product,
    required this.descreption,
    required this.prize,
    required this.createdAt,
    required this.stock,
    required this.details
  });

  ProductModel copyWith({
    String? id,
    String? product,
    String? descreption,
    int? prize,
    Timestamp? createdAt,
    int? stock,
    DetailsModel? details,
  }) {
    return ProductModel(
      id: id ?? this.id,
      product: product ?? this.product,
      descreption: descreption ?? this.descreption,
      prize: prize ?? this.prize,
      createdAt: createdAt ?? this.createdAt,
      stock: stock ?? this.stock,
      details: details ?? this.details
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product,
      'descreption': descreption,
      'prize': prize,
      'createdAt': createdAt,
      'stock': stock,
      'details': details.toMap(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      product: map['product'] ?? 'Unknown Product', 
      descreption: map['descreption'] ?? 'No description', 
      prize: (map['prize'] ?? 0) as int, 
      createdAt: map['createdAt'] ?? Timestamp.now(), 
      stock: (map['stock'] ?? 0) as int, 
      details: DetailsModel.fromMap(map["details"] )
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
