import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_cubit.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/item/item_cubit.dart';
import '../blocs/item/item_state.dart';
import '../utils/constants.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/items_grid.dart';
import '../widgets/menu_drawer_widget.dart';
import '../widgets/progress_loader.dart';
import 'cart_screen.dart';
import 'item_preview_screen.dart';

///
class MarketplaceScreen extends StatefulWidget {
  ///
  const MarketplaceScreen({Key? key}) : super(key: key);

  ///
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const MarketplaceScreen());

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          iconTheme: Theme.of(context).iconTheme,
          actions: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) => Stack(children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: Constants.iconButtonSize,
                  ),
                  color: Theme.of(context).primaryColorDark,
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const CartScreen())),
                ),
                if (state is CartItemsLoaded)
                  state.currentUserCartItems.isNotEmpty
                      ? Positioned(
                          left: 16,
                          bottom: 24,
                          child: Container(
                            height: 10,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: const SizedBox.shrink(),
                          ),
                        )
                      : const SizedBox.shrink()
              ]),
            )
          ],
        ),
        body: BlocBuilder<ItemCubit, ItemState>(builder: (context, state) {
          if (state is ItemBeingAdded) {
            return const ProgressLoader();
          }
          return state is ItemsLoaded && state.itemsForSale.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.eight),
                  child: CustomScrollView(
                    slivers: [ItemsGrid(items: state.itemsForSale)],
                  ),
                )
              : const Center(
                  child: Text(
                    'No items for sale right now. Check again later.',
                    style: TextStyle(fontSize: Constants.standardFontSize),
                  ),
                );
        }),
        drawer: const MenuDrawerWidget(),
        floatingActionButton: FloatingActionButtonWidget(
          onPressed: () {
            context.read<ItemCubit>().addImagesToState();

            Navigator.of(context).push(MaterialPageRoute<Widget>(
                builder: (_) => const ItemPreviewScreen()));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
          ),
        ),
      );
}
