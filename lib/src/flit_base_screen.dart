import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flit_bundle.dart';
import 'flit_dependency_injector.dart';
import 'flit_state.dart';
import 'flit_viewmodel.dart';

typedef void OnStateChanged<STATE extends FlitState>(
    BuildContext context, STATE state);

@immutable
abstract class FlitBaseScreen<
    BUNDLE extends FlitBundle,
    VM extends FlitViewModel<STATE>,
    STATE extends FlitState> extends StatelessWidget {
  final BUNDLE bundle;
  final List<BlocListener> blocListeners = [];

  FlitBaseScreen(this.bundle);

  Widget buildBody(BuildContext context);
  void initViewModel(final VM viewModel);

  void addListener(OnStateChanged<STATE> stateListener) {
    this.blocListeners.add(
          BlocListener<VM, STATE>(
            listenWhen: (previousState, state) => (state != previousState),
            listener: (context, state) {
              stateListener(context, state);
            },
          ),
        );
  }

  VM provideViewModel(BuildContext context) {
    return BlocProvider.of<VM>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        key: UniqueKey(),
        create: (_) => FlitDependencyInjector.injector<VM>(),
        child: Builder(
          builder: (providerContext) {
            // init the viewmodel when it has been constructed in the context
            initViewModel(provideViewModel(providerContext));
            if (blocListeners != null && blocListeners.isNotEmpty) {
              return MultiBlocListener(
                  listeners: blocListeners, child: buildBody(providerContext));
            } else {
              return buildBody(providerContext);
            }
          },
        ));
  }
}
