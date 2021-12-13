import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/application/auth/auth_bloc.dart';
import 'package:note_app/injection.dart';
import 'package:note_app/presentation/routes/router.gr.dart' as router;

class AppWidget extends StatelessWidget {
  final _appRouter = router.AppRouter();
  AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.green[800],
              ),
          /*appBarTheme: ThemeData.light().appBarTheme.copyWith(
                backgroundColor: Colors.orange,
              ),*/
          floatingActionButtonTheme:
              ThemeData.light().floatingActionButtonTheme.copyWith(
                    backgroundColor: Colors.blue[900],
                  ),
          inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
                fillColor: Colors.orange,
                focusColor: Colors.orange,
                hoverColor: Colors.orange,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.green.shade800,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red.shade600,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red.shade600,
                    width: 2.0,
                  ),
                ),
              ),
        ),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
