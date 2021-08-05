import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moostamil/models/item/item.dart';
import 'package:moostamil/repositories/upload/upload_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  // ignore: cascade_invocations
  channel.setMockMethodCallHandler((MethodCall methodCall) async => '.');

  await Firebase.initializeApp();

  UploadRepository _uploadRepository;
  FakeFirebaseFirestore _fakeFirebaseFirestore;

  setUpAll(() async {
    _uploadRepository = UploadRepository();
    _fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  test('Add item', () async {
    const _item = Item(title: 'test item', description: 'test item to upload');
    await _uploadRepository.upload(_item, _fakeFirebaseFirestore);
  });
}
