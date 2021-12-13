import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/application/auth/auth_bloc.dart';
import 'package:note_app/application/notes/note_actor/note_actor_bloc.dart';
import 'package:note_app/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:note_app/injection.dart';
import 'package:note_app/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:note_app/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:note_app/presentation/routes/router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(create: (context) {
          try {
            return getIt<NoteWatcherBloc>()
              ..add(const NoteWatcherEvent.watchAllStarted());
          } catch (e) {
            throw Exception();
          }
        }),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                  unauthenticated: (_) =>
                      context.router.replace(const SignInPageRoute()),
                  orElse: () {});
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    duration: const Duration(seconds: 5),
                    message: state.noteFailure.map(
                      unexpected: (_) =>
                          'Unexpected error occured while deleting, please contact support.',
                      insufficientPermission: (_) =>
                          'Insufficient permissions ❌',
                      unableToUpdate: (_) => 'Impossible error',
                    ),
                  ).show(context);
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: [
              UncompletedSwitch(),
            ],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(NoteFormPageRoute(editedNote: null));
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
