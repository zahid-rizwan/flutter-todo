import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_local_datasources.dart';
import '../../features/auth/data/datasources/auth_remote_datasources.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/profile/data/datasources/profile_local_datasources.dart';
import '../../features/profile/data/datasources/profile_remote_datasources.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/domain/usecases/update_user_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/tasks/data/datasources/task_local_datasources.dart';
import '../../features/tasks/data/datasources/task_remote_datasources.dart';
import '../../features/tasks/data/repositories/task_repositories_impl.dart';
import '../../features/tasks/domian/repositories/task_repositories.dart';
import '../../features/tasks/domian/usecases/add_task_details.dart';
import '../../features/tasks/domian/usecases/delete_task.dart';
import '../../features/tasks/domian/usecases/get_complete_tasks.dart';
import '../../features/tasks/domian/usecases/get_ongoing_task.dart';
import '../../features/tasks/domian/usecases/get_task_details.dart';
import '../../features/tasks/domian/usecases/update_task.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';
import '../../features/tasks/presentation/bloc/task_details_bloc/task_detail_bloc.dart';
import '../network/network_info.dart';
import '../services/supabase_service.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  final supabaseClient = SupabaseService().client;
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);


  sl.registerFactory(
        () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          supabaseClient: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
            supabaseClient: sl()

        ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Tasks
  // Bloc
  sl.registerFactory(
        () => TaskBloc(repository: sl()
     
    ),
  );

  sl.registerFactory(
        () => TaskDetailBloc(
      getTaskDetails: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCompletedTasks(sl()));
  sl.registerLazySingleton(() => GetOngoingTasks(sl()));
  sl.registerLazySingleton(() => GetTaskDetails(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(), supabaseClient: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
        () => TaskRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<TaskLocalDataSource>(
        () => TaskLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Profile
  // Bloc
  sl.registerFactory(
        () => ProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());}