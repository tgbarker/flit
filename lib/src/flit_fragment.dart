import 'package:flit/flit.dart';
import 'package:flutter/cupertino.dart';

import 'flit_base_screen.dart';
import 'flit_bundle.dart';
import 'flit_state.dart';

@immutable
abstract class FlitFragment<
    BUNDLE extends FlitBundle,
    VM extends FlitViewModel<STATE>,
    STATE extends FlitState> extends FlitBaseScreen<BUNDLE, VM, STATE> {
  FlitFragment(BUNDLE bundle) : super(bundle);

  @override
  void initBuild() {}
}
