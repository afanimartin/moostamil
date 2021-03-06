import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:permission_handler/permission_handler.dart';

///
Future<List<Asset>>? imagesToPreview() async {
  ///
  var images = <Asset>[];

  final permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    try {
      images = await MultiImagePicker.pickImages(
          maxImages: 6, selectedAssets: images);
    } on Exception catch (_) {}
  } else {
    await Permission.photos.request();
  }

  return images;
}
