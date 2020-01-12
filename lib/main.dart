import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './screens/add_task_screen.dart';
import './screens/task_list_screen.dart';
import './screens/task_details_screen.dart';
import './screens/auth_screen.dart';
import './screens/loading_screen.dart';
import './screens/settings_screen.dart';

import './providers/tasks.dart';
import './providers/auth.dart';

void main() => runApp(TaskApp());

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var _navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Tasks>(
          create: (_) => Tasks(null, [], {}),
          update: (ctx, auth, prevTasks) => prevTasks == null
              ? Tasks(auth.token, [], {})
              : Tasks(
                  auth.token,
                  prevTasks.items,
                  prevTasks.meta,
                  prevTasks.sortOptions,
                ),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                theme: ThemeData(
                  primaryColor: const Color(0xFFD9D9D9),
                  accentColor: const Color(0xFF828282),
                  textTheme: TextTheme(
                      title: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                ),
                navigatorKey: _navigatorKey,
                home: auth.isAuthenticate
                    ? TaskListScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authSnapshot) =>
                            authSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? LoadingScreen()
                                : AuthScreen(),
                      ),
                routes: {
                  TaskListScreen.routeName: (_) => TaskListScreen(),
                  AddTaskScreen.routeName: (_) => AddTaskScreen(_navigatorKey),
                  TaskDetailsScreen.routeName: (_) => TaskDetailsScreen(_navigatorKey),
                  SettingsScreen.routeName: (_) => SettingsScreen(),
                },
              )),
    );
  }
}
