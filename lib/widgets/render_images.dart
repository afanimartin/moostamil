import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:give_now/blocs/image/image_bloc.dart';
import 'package:give_now/blocs/image/image_state.dart';
import 'package:give_now/models/image/image_model.dart';
import 'package:give_now/screens/image_detail_screen.dart';
import 'package:give_now/widgets/progress_loader.dart';

class RenderImages extends StatefulWidget {
  const RenderImages({Key key}) : super(key: key);
  
  @override
  _RenderImagesState createState() => _RenderImagesState();
}

class _RenderImagesState extends State<RenderImages> {
  @override
  Widget build(BuildContext context) => BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImagesUpdated) {
            return state.currentUserImages.isEmpty
                ? Center(child: Text('No images to load'))
                : ListView.builder(
                    itemCount: state.currentUserImages.length,
                    itemBuilder: (context, index) {
                      final image = state.currentUserImages[index];
                      return _RenderImage(image: image);
                    });
          }
          return const ProgressLoader();
        },
      );
}

class _RenderImage extends StatelessWidget {
  final ImageModel image;

  const _RenderImage({@required this.image, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 6, right: 10, bottom: 6),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ImageDetailScreen(image: image))),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: CachedNetworkImage(
              imageUrl: image.mainImageUrl,
            ),
          ),
        ),
      ));
}