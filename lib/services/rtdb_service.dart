import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study/services/auth_service.dart';

class RTDBService {
  // Singleton instance
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Private constructor
  get database => _database;

  // Save user information to Realtime Database
  // After signin on Firebase Auth
  Future<void> saveUserInfoToRTDB(User user) async {
    final DatabaseReference databaseRef = _database.ref("users/${user.uid}");

    await databaseRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'user$hashCode',
      'photoURL': user.photoURL ?? '',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  //Get user information from Realtime Database
  Future<Map<String, dynamic>?> getUserInformation() async {
    final DatabaseReference databaseReference = _database.ref(
      "users/${AuthService().getCurrentUserInfo()!.uid}",
    );
    final snapshot = await databaseReference.once();
    final userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (userData != null) {
      return {
        'uid': userData['uid'],
        'email': userData['email'],
        'displayName': userData['displayName'],
      };
    }
    return null;
  }

  // Save message sent to RTDB
  Future<void> sendMessage(String message, String chatroomId) async {
    await _database.ref("chats/$chatroomId").push().set({
      'senderId': AuthService().getCurrentUserInfo()!.uid,
      'message': message,
      "createdAt": ServerValue.timestamp,
    });
  }
}
