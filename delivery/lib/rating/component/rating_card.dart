import 'package:collection/collection.dart';
import 'package:delivery/common/const/colors.dart';
import 'package:delivery/rating/model/rating_model.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  const RatingCard(
      {Key? key,
      required this.avartarImage,
      required this.images,
      required this.rating,
      required this.email,
      required this.content})
      : super(key: key);

  final ImageProvider avartarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  factory RatingCard.fromModel({required RatingModel model}) {
    return RatingCard(
      avartarImage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avartarImage: avartarImage,
          rating: rating,
          email: email,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {Key? key,
      required this.avartarImage,
      required this.rating,
      required this.email})
      : super(key: key);

  final ImageProvider avartarImage;
  final int rating;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avartarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.content}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(color: bodyTextColor, fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  const _Images({Key? key, required this.images}) : super(key: key);

  final List<Image> images;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding:
                  EdgeInsets.only(right: index == images.length - 1 ? 0 : 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
