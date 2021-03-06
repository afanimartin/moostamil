import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_cubit.dart';
import '../blocs/cart/cart_state.dart';
import '../models/app_tab/app_tab.dart';

///
class TabSelector extends StatefulWidget {
  ///
  const TabSelector(
      {required this.activeTab, required this.onTabSelected, Key? key})
      : super(key: key);

  ///
  final AppTab activeTab;

  ///
  final Function(AppTab) onTabSelected;

  @override
  _TabSelectorState createState() => _TabSelectorState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppTab>('activeTab', activeTab));
    // ignore: cascade_invocations
    properties.add(DiagnosticsProperty<Function(AppTab p1)>(
        'onTabSelected', onTabSelected));
  }
}

class _TabSelectorState extends State<TabSelector> {
  final double _size = 30;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
      elevation: 20,
      currentIndex: AppTab.values.indexOf(widget.activeTab),
      onTap: (index) => widget.onTabSelected(AppTab.values[index]),
      backgroundColor: Theme.of(context).accentColor,
      items: AppTab.values
          .map((tab) => BottomNavigationBarItem(
              icon: _tabIcon(tab, context),
              label: _tabLabel(tab),
              backgroundColor: Theme.of(context).primaryColor))
          .toList());

  Widget _tabIcon(AppTab tab, BuildContext context) {
    switch (tab) {
      case AppTab.home:
        return Icon(
          Icons.home_outlined,
          size: _size,
        );
      case AppTab.profile:
        return Icon(
          Icons.person_outline,
          size: _size,
        );
      case AppTab.cart:
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, state) => Stack(children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: _size,
            ),
            if (state is CartItemsLoaded)
              state.currentUserCartItems.isNotEmpty
                  ? Positioned(
                      left: 7.5,
                      top: 13,
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
        );
    }

  }

  String _tabLabel(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return 'Home';

      case AppTab.profile:
        return 'Profile';

      case AppTab.cart:
        return 'Cart';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppTab>('activeTab', widget.activeTab));
    // ignore: cascade_invocations
    properties.add(DiagnosticsProperty<Function(AppTab p1)>(
        'onTabSelected', widget.onTabSelected));
  }
}
