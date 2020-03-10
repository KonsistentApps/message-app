import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/dialog_service.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => FirestoreService());


}
