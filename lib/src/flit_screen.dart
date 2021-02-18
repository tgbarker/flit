import 'package:flutter/cupertino.dart';

import 'flit_base_screen.dart';
import 'flit_bundle.dart';
import 'flit_state.dart';
import 'flit_viewmodel.dart';

@immutable
abstract class FlitScreen<
    BUNDLE extends FlitBundle,
    VM extends FlitViewModel<STATE>,
    STATE extends FlitState> extends FlitBaseScreen<BUNDLE, VM, STATE> {
  FlitScreen(FlitBundle bundle) : super(bundle);
}
