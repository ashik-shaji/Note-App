import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/domain/auth/user.dart';
import 'package:note_app/domain/core/value_objects.dart';

extension FirebaseUserDomainX on User {
  AppUser toDomain() {
    return AppUser(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
