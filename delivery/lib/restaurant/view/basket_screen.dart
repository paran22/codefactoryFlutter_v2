import 'package:delivery/common/const/colors.dart';
import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/product/component/product_card.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
        child: Center(child: Text('장바구니가 비어있습니다 ㅠㅠ')),
      );
    }

    final productsTotal = basket.fold<int>(
        0, (prev, next) => prev + next.product.price * next.count);
    final deliveryFee = basket.first.product.restaurant.deliveryFee;
    return SafeArea(
      bottom: true,
      child: DefaultLayout(
        title: '장바구니',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return const Divider(
                      height: 32.0,
                    );
                  },
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      Text('₩' + productsTotal.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(color: bodyTextColor),
                      ),
                      if (basket.length > 0) Text('₩' + deliveryFee.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('₩' + (productsTotal + deliveryFee).toString()),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: primaryColor),
                      child: Text(
                        '결제하기',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
