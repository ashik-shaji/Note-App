import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/application/auth/auth_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:note_app/presentation/routes/router.gr.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            Future.delayed(const Duration(milliseconds: 1500)).then((value) =>
                context.router.replace(const NotesOverviewPageRoute()));
          },
          unauthenticated: (_) {
            Future.delayed(const Duration(milliseconds: 1500)).then(
                (value) => context.router.replace(const SignInPageRoute()));
          },
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
