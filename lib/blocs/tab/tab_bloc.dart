import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/app_tab/app_tab.dart';

import 'tab_event.dart';

///
class TabBloc extends Bloc<TabEvent, AppTab> {
  ///
  TabBloc() : super(AppTab.home);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
