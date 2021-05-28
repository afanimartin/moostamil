import 'dart:io';

import '../../models/image/item_model.dart';

///
abstract class IItemRepository {
  ///
  Future<List<String>> uploadItemImagesToStorage(
      List<File> images, String userId);

  ///
  Future<void> uploadItemToFirestore(
      List<File> urlsToUpload, String userId);

  ///
  Stream<List<ItemModel>> imageStream(String userId);
}
