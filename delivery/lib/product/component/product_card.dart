import 'package:delivery/common/const/colors.dart';
import 'package:delivery/product/model/product_model.dart';
import 'package:delivery/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.detail,
      required this.price})
      : super(key: key);

  final Image image;
  final String name;
  final String detail;
  final int price;

  factory ProductCard.fromProductModel({required ProductModel model}) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  factory ProductCard.fromRestaurantProductModel({required RestaurantProductModel model}) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: bodyTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '￦$price',
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
