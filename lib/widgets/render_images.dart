import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../blocs/item/item_cubit.dart';
import '../blocs/item/item_state.dart';
import '../models/item/item.dart';
import '../screens/item_detail_screen.dart';
import '../utils/constants.dart';
import 'progress_loader.dart';

///
class RenderImages extends StatefulWidget {
  ///
  const RenderImages({Key? key}) : super(key: key);

  @override
  _RenderImagesState createState() => _RenderImagesState();
}

class _RenderImagesState extends State<RenderImages> {
  @override
  Widget build(BuildContext context) => BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state is ItemsLoaded) {
            return state.items.isEmpty
                ? const Center(child: Text('No items to load'))
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final image = state.items[index];
                      return _RenderImage(image: image);
                    });
          }
          return const ProgressLoader();
        },
      );
}

class _RenderImage extends StatelessWidget {
  ///
  const _RenderImage({required this.image, Key? key}) : super(key: key);
  final Item image;

  @override
  Widget build(BuildContext context) => SizedBox(
          child: Padding(
        padding: const EdgeInsets.only(
            left: Constants.ten,
            top: Constants.six,
            right: Constants.ten,
            bottom: Constants.six),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => ItemDetailScreen(item: image))),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Constants.circularBorderRadius)),
            elevation: Constants.elevation,
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: image.mainImageUrl!,
                  height: Constants.threeHundred,
                  width: Constants.fourHundred,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(Constants.paddingAll),
                  child: Text(timeago.format(image.createdAt!.toDate())),
                )
              ],
            ),
          ),
        ),
      ));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Item>('image', image));
  }
}
