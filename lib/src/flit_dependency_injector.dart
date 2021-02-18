import 'package:get_it/get_it.dart';

abstract class FlitInjectorModule {
  Future<void> init(GetIt injector);
}

abstract class FlitDependencyInjector {
  static final injector = GetIt.instance;

  static Future<void> init(List<FlitInjectorModule> modules) async {
    modules.forEach((module) async {
      await module.init(injector);
    });
  }
}

// List<InjectorModule> modules =
//     List.of([DomainModule(), DataModule(), PresentationModule()]);
//
// Future<void> init(List<InjectorModule> modules) async {
//   modules.forEach((module) async {
//     await module.init(injector);
//   });
//
//   // specific config, probably ot good here, but to be decided where
//   // await injector<BaseDb>().init(); // init the database
//   // await injector<BaseDbStorage>().init(); // init the remote file storage
//   // await injector<PermissionsService>()
//   //     .init(List.of([Permission.camera, Permission.location]));
// }
