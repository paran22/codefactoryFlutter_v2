import 'package:delivery/user/model/basket_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class PostOrderBody {
  final String id;
  final List<BasketItemModel> products;
  final int totalPrice;
  final String createAt;

  const PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createAt,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
  _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}
