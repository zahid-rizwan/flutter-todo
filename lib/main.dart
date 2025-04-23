
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_demo_1/features/tasks/presentation/bloc/task_details_bloc/task_detail_bloc.dart';

import 'core/injection/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => di.sl<TaskBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>(),
        ),
        BlocProvider<TaskDetailBloc>(
          create: (_) => di.sl<TaskDetailBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'DayTask',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
