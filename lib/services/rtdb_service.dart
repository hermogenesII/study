import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RTDBService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> saveUserInfoToRTDB(User user) async {
    final DatabaseReference databaseRef = _database.ref("users/${user.uid}");

    await databaseRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'user${user.uid}',
      'photoURL': user.photoURL ?? '',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
