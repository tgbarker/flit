abstract class FlitInjectorModule<T> {
  Future<void> init(T injector);
}

abstract class FlitDependencyInjector {
  static late var injector;

  static Future<void> init<T>(
      T dependencyInjector, List<FlitInjectorModule> modules) async {
    injector = dependencyInjector;
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
