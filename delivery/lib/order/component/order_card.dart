import 'package:delivery/common/const/colors.dart';
import 'package:delivery/order/model/order_product_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsDetail;
  final int price;

  const OrderCard({
    Key? key,
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productsDetail,
    required this.price,
  }) : super(key: key);

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    final products = model.products;
    final productsDetail = products.length < 2
        ? products.first.product.name
        : '${products.first.product.name} 외 ${products.length - 1}개';
    return OrderCard(
      orderDate: DateTime.now(),
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50.0,
        width: 50.0,
        fit: BoxFit.cover,
      ),
      name: model.restaurant.name,
      productsDetail: productsDetail,
      price: model.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
            '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료'),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '$productsDetail $price 원',
                  style: const TextStyle(
                    color: bodyTextColor,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
