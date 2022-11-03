import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/order/component/order_card.dart';
import 'package:delivery/order/model/order_product_model.dart';
import 'package:delivery/order/provider/order_provider.dart';
import 'package:delivery/product/component/pagination_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
