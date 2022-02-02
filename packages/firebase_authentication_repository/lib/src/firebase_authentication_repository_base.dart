import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:google_sign_in/google_sign_in.dart';

import 'models/user.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpWithEmailAndPasswordFailure implements Exception {
  String message;
  String? code;

  SignUpWithEmailAndPasswordFailure({required this.message, this.code});
}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {
  String message;
  String? code;

  LogInWithEmailAndPasswordFailure({required this.message, this.code});
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// Thown during phone login
class PhoneLoginFailure implements Exception {}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class FirebaseAuthenticationRepository {
  FirebaseAuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  @visibleForTesting
  static const userCacheKey = 'auth_user';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      return user;
    });
  }

  /// Returns the current authenticated user
  User get currentUser {
    User user = _firebaseAuth.currentUser?.toUser ?? User.empty;
    return user;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      String failureMessage = "";
      switch (e.code) {
        case "email-already-in-use":
          failureMessage = "The email is already in use.";
          break;
        case "invalid-email":
          failureMessage = "The email entered is invalid.";
          break;
        case "operation-not-allowed":
          failureMessage = "email/password accounts are not enabled. Contact admin";
          break;
        case "weak-password":
          failureMessage = "weak password, please follow the password instrucions.";
          break;
        default:
          failureMessage = "Ops! looks like something went wrong";
      }

      throw SignUpWithEmailAndPasswordFailure(message: failureMessage, code: e.code);
    } catch (e) {
      throw SignUpWithEmailAndPasswordFailure(
          message: "Unexpected failure occured at login. Please try again after sometime.");
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(e);
      String failureMessage = "";
      switch (e.code) {
        case "invalid-email":
          failureMessage = "The email provided is not registered.";
          break;
        case "user-disabled":
          failureMessage = "The user corresponding to the given email has been disabled.";
          break;
        case "user-not-found":
          failureMessage = "No user found for that email.";
          break;
        case "wrong-password":
          failureMessage = "Wrong password provided for that user.";
          break;
        default:
          failureMessage = "Ops! looks like something went wrong. Please check your internet connection";
      }
      throw LogInWithEmailAndPasswordFailure(message: failureMessage, code: e.code);
    } catch (e) {
      throw LogInWithEmailAndPasswordFailure(
          message: "Unexpected failure occured at login. Please try again after sometime.");
    }
  }

  // Request verification code for the given phone number
  Future<firebase_auth.ConfirmationResult> signInWithPhoneNumber({required String phone}) async {
    try {
      firebase_auth.ConfirmationResult confirmationResult = await _firebaseAuth.signInWithPhoneNumber(phone);
      return confirmationResult;
    } catch (e) {
      throw PhoneLoginFailure();
    }
  }

  Future<firebase_auth.UserCredential> confirmationPhoneVerificationCode(
      {required String code, required firebase_auth.ConfirmationResult confirmationResult}) async {
    try {
      firebase_auth.UserCredential userCredential = await confirmationResult.confirm(code);
      return userCredential;
    } catch (e) {
      throw PhoneLoginFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<bool> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      bool isNewUser = false;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        isNewUser = userCredential.additionalUserInfo!.isNewUser;
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (!isWeb) {
        isNewUser = userCredential.additionalUserInfo!.isNewUser;
      }
      return isNewUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    String? firstName = displayName;
    String? lastName = displayName;
    if (displayName != null && displayName!.contains(",")) {
      firstName = displayName!.split(",")[0];
      lastName = displayName!.split(",")[1];
    }
    return User(id: uid, email: email, firstName: firstName, lastName: lastName, photo: photoURL);
  }
}
