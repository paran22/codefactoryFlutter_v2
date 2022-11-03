import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/common/provider/pagination_provider.dart';
import 'package:delivery/order/model/order_product_model.dart';
import 'package:delivery/order/model/post_order_body.dart';
import 'package:delivery/order/repository/order_repository.dart';
import 'package:delivery/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(
    ref: ref,
    repository: repository,
  );
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();
      final state = ref.read(basketProvider);

      final postOrderBody = PostOrderBody(
        id: id,
        products: state
            .map((e) =>
                PostOrderBodyProduct(productId: e.product.id, count: e.count))
            .toList(),
        totalPrice: state.fold<int>(
            0, (prev, next) => prev + next.product.price * next.count),
        createdAt: DateTime.now().toString(),
      );

      await repository.postOrder(
        body: postOrderBody,
      );

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
