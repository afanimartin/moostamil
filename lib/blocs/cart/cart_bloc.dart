import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/item/item.dart';
import '../../repositories/cart/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

///
class CartBloc extends Bloc<CartEvent, CartState> {
  ///
  CartBloc({@required CartRepository cartRepository, FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _cartRepository = cartRepository,
        super(const CartState());

  ///
  final CartRepository _cartRepository;

  ///
  final FirebaseAuth _firebaseAuth;

  ///
  StreamSubscription<List<Item>> _streamSubscription;

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCartItems) {
      yield* _mapLoadCartItemsToState();
    } else if (event is UpdateCartItems) {
      yield* _mapUpdateCartItemsToState(event);
    } else if (event is RemoveItemFromCart) {
      yield* _mapRemoveItemFromCartToState(event);
    } else if (event is AddItemToCart) {
      yield* _mapAddItemToCartToState(event);
    } else if (event is CheckoutItem) {
      yield* _mapSellItemToState(event);
    }
  }

  ///
  Stream<CartState> _mapLoadCartItemsToState() async* {
    await _streamSubscription?.cancel();

    _streamSubscription = _cartRepository
        .cart()
        .listen((items) => add(UpdateCartItems(items: items)));
  }

  Stream<CartState> _mapUpdateCartItemsToState(UpdateCartItems event) async* {
    yield LoadingCartItems();

    try {
      yield CartItemsLoaded(items: event.items);
    } on Exception catch (_) {}
  }

  ///
  Stream<CartState> _mapAddItemToCartToState(AddItemToCart event) async* {
    yield AddingItemToCart();

    try {
      final cartItem = Item(
          id: event.cartItem.id,
          buyerId: _firebaseAuth.currentUser.uid,
          sellerId: event.cartItem.sellerId,
          sellerPhoneNumber: event.cartItem.sellerPhoneNumber,
          title: event.cartItem.title,
          category: event.cartItem.category,
          mainImageUrl: event.cartItem.mainImageUrl,
          price: event.cartItem.price,
          createdAt: Timestamp.now());

      await _cartRepository.add(cartItem);

      yield ItemSuccessfullyAddedToCart();
    } on Exception catch (_) {}
  }

  ///
  Stream<CartState> _mapRemoveItemFromCartToState(
      RemoveItemFromCart event) async* {
    yield ItemBeingRemovedFromCart();

    try {
      await _cartRepository.delete(event.item);
    } on Exception catch (_) {}
  }

  ///
  Stream<CartState> _mapSellItemToState(CheckoutItem event) async* {
    try {
      final _sale = event.sale.copyWith(
          buyerId: _firebaseAuth.currentUser.uid,
          buyerAddress: event.sale.buyerAddress,
          buyerPhoneNumber: event.sale.buyerPhoneNumber,
          sellerId: event.sale.sellerId,
          sellerPhoneNumber: event.sale.sellerPhoneNumber,
          cartItems: event.sale.cartItems,
          createdAt: Timestamp.now());

      await _cartRepository.checkout(_sale);
    } on Exception catch (_) {}
  }

  ///
  void deleteCartItems(List<Item> cartItems) {
    for (var i = 0; i < cartItems.length; i++) {
      _cartRepository.delete(cartItems[i]);
    }
  }
}
