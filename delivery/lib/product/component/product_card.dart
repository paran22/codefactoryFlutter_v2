import 'package:delivery/common/const/colors.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbUrl = '/img/스테이크/등심스테이크.jpg';
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'http://$ip${thumbUrl}',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '떡볶이',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              Text(
                '스테끼에는 역시 감자칩이 진리! 겉은 바삭바삭하게 구워지고 속은 촉촉하게 미디엄레어로 구워진 스테이크와함께 소금과 후추가 듬뿍 뿌려진 짭짤한 감자칩을 같이 먹어볼 수 있는 세트메뉴!',
                style: TextStyle(
                  fontSize: 14.0,
                  color: bodyTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '￦10000',
                style: TextStyle(
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
