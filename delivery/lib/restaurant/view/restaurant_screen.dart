import 'package:delivery/common/const/data.dart';
import 'package:delivery/common/dio/dio.dart';
import 'package:delivery/common/model/cursor_pagination_model.dart';
import 'package:delivery/restaurant/component/restaurant_card.dart';
import 'package:delivery/restaurant/model/restaurant_model.dart';
import 'package:delivery/restaurant/repository/restaurant_repository.dart';
import 'package:delivery/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final response = await ref.watch(restaurantRepositoryProvider).paginate();
    return response.data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<RestaurantModel>>(
                future: paginateRestaurant(ref),
                builder: (context,
                    AsyncSnapshot<List<RestaurantModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    RestaurantDetailScreen(
                                      id: item.id,
                                    )));
                          },
                          child: RestaurantCard.fromModel(
                            model: item,
                          ));
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 16,
                      );
                    },
                  );
                },
              )),
        ));
  }
}
