import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:note_app/domain/auth/auth_failure.dart';
import 'package:note_app/domain/auth/i_auth_facade.dart';
import 'package:note_app/domain/auth/value_objects.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        emailChanged: (e) async {
          emit(state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        passwordChanged: (e) async {
          emit(state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        registerWithEmailAndPasswordPressed: (e) async {
          Either<AuthFailure, Unit>? failureOrSuccess;

          final isEmailValid = state.emailAddress!.isValid();
          final isPasswordValid = state.password!.isValid();

          if (isEmailValid && isPasswordValid) {
            emit(state.copyWith(
              isSubmitting: true,
              authFailureOrSuccessOption: none(),
            ));

            failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
              emailAddress: state.emailAddress!,
              password: state.password!,
            );
          }

          emit(state.copyWith(
            isSubmitting: false,
            showErrorMessages: AutovalidateMode.always,
            authFailureOrSuccessOption: optionOf(failureOrSuccess),
          ));
        },
        signInWithEmailAndPasswordPressed: (e) async {
          Either<AuthFailure, Unit>? failureOrSuccess;

          final isEmailValid = state.emailAddress!.isValid();
          final isPasswordValid = state.password!.isValid();

          if (isEmailValid && isPasswordValid) {
            emit(state.copyWith(
              isSubmitting: true,
              authFailureOrSuccessOption: none(),
            ));

            failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
              emailAddress: state.emailAddress!,
              password: state.password!,
            );
          }

          emit(state.copyWith(
            isSubmitting: false,
            showErrorMessages: AutovalidateMode.always,
            authFailureOrSuccessOption: optionOf(failureOrSuccess),
          ));
        },
        signInWithGooglePressed: (e) async {
          emit(state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ));
          final failureOrSuccess = await _authFacade.signInWithGoogle();
          emit(state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: some(failureOrSuccess),
          ));
        },
      );
    });
  }
}
