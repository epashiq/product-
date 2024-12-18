import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DetailsModel {
  String? id;
  String material;
  String colour;
  DetailsModel({
    this.id,
    required this.material,
    required this.colour,
  });

  DetailsModel copyWith({
    String? id,
    String? productId,
    String? material,
    String? colour,
  }) {
    return DetailsModel(
      id: id ?? this.id,
      material: material ?? this.material,
      colour: colour ?? this.colour,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'material': material,
      'colour': colour,
    };
  }

  factory DetailsModel.fromMap(Map<String, dynamic> map) {
    return DetailsModel(
      id: map['id'] != null ? map['id'] as String : null,
      material: map['material'] as String,
      colour: map['colour'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsModel.fromJson(String source) => DetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
