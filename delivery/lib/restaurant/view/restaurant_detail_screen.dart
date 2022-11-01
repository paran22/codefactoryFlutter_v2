import 'package:delivery/common/layout/default_layout.dart';
import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/common/utils/pagination_utils.dart';
import 'package:delivery/product/component/product_card.dart';
import 'package:delivery/rating/component/rating_card.dart';
import 'package:delivery/rating/model/rating_model.dart';
import 'package:delivery/restaurant/component/restaurant_card.dart';
import 'package:delivery/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery/restaurant/model/restaurant_model.dart';
import 'package:delivery/restaurant/provider/restaurant_provider.dart';
import 'package:delivery/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routerName => 'restaurantDetail';

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultLayout(
      title: state.name,
      child: CustomScrollView(
        controller: controller ,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products),
          if (ratingState is CursorPagination<RatingModel>)
            renderRating(ratings: ratingState.data),
        ],
      ),
    );
  }
}

SliverPadding renderRating({required List<RatingModel> ratings}) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final model = ratings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RatingCard.fromModel(
            model: model,
          ),
        );
      }, childCount: ratings.length),
    ),
  );
}

SliverPadding renderLoading() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 16.0,
    ),
    sliver: SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
            3,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: SkeletonParagraph(
                    style: const SkeletonParagraphStyle(
                      lines: 5,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                )),
      ),
    ),
  );
}

SliverToBoxAdapter renderTop({
  required RestaurantModel model,
}) {
  return SliverToBoxAdapter(
    child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ),
  );
}

SliverPadding renderLabel() {
  return const SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '메뉴',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

SliverPadding renderProducts({
  required List<RestaurantProductModel> products,
}) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromRestaurantProductModel(model: model),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}
