import 'package:collection/collection.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:delivery/product/model/product_model.dart';
import 'package:delivery/user/model/basket_item_model.dart';
import 'package:delivery/user/model/patch_basket_body.dart';
import 'package:delivery/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    const Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketProvider({
    required this.repository,
  }) : super([]) {
    updateBasketDebounce.values.listen(
      (state) {
        patchBasket();
      },
    );
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
            basket: state
                .map((e) => PatchBasketBodyBasket(
                    productId: e.product.id, count: e.count))
                .toList()));
  }

  Future<void> addToBasket({required ProductModel product}) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }

    // Optimistic Response (긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트 함
    updateBasketDebounce.setValue(null);
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      final existingProduct =
          state.firstWhere((e) => e.product.id == product.id);
      if (existingProduct.count == 1 || isDelete) {
        state = state.where((e) => e.product.id != product.id).toList();
      } else {
        state = state
            .map((e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
            .toList();
      }
    } else {
      return;
    }

    updateBasketDebounce.setValue(null);
  }
}
