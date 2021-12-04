import 'package:auto_route/annotations.dart';
import 'package:note_app/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:note_app/presentation/sign_in/sign_in_page.dart';
import 'package:note_app/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
    AutoRoute(page: NotesOverviewPage),
  ],
)
class $AppRouter {}
