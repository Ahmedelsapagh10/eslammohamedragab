import 'package:dio/dio.dart';
import 'package:new_strucuture/config/themes/theme_cubit.dart';
import 'package:new_strucuture/features/login/cubit/login_cubit.dart';
import 'package:new_strucuture/features/login/data/login_repo.dart';
import 'package:new_strucuture/features/main_screen/cubit/main_cubit.dart';
import 'package:new_strucuture/features/splash/cubit/splash_cubit.dart';
import 'package:new_strucuture/features/forget_password/cubit/forget_password_cubit.dart';
import 'package:new_strucuture/features/forget_password/data/forget_password_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/base_api_consumer.dart';
import 'core/api/dio_consumer.dart';
import 'features/main_screen/data/main_repo.dart';

final serviceLocator = GetIt.instance;
void registerCubits() {
  serviceLocator.registerFactory(() => SplashCubit());

  serviceLocator.registerFactory(() => LoginCubit(serviceLocator()));
  serviceLocator.registerFactory(() => MainCubit(serviceLocator()));
  serviceLocator.registerFactory(() => ThemeCubit());
  serviceLocator.registerFactory(() => ForgetPasswordCubit(serviceLocator()));
}

void registerRepositories() {
  serviceLocator.registerLazySingleton(() => LoginRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => MainRepo(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => ForgetPasswordRepo(serviceLocator()),
  );
}

Future<void> setupDependencies() async {
  await serviceLocator.reset();
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton<BaseApiConsumer>(
    () => DioConsumer(client: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => AppInterceptors());

  serviceLocator.registerLazySingleton(
    () => Dio(
      BaseOptions(
        contentType: "application/x-www-form-urlencoded",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    ),
  );
}
