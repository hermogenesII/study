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

  //Update User information to RealTime Database
  Future<void> updateUserInfoToRTDB(
    String? displayName,
    String? fullName,
    dateOfBirth,
  ) async {
    final DatabaseReference databaseRef = _database.ref(
      "users/${AuthService().getCurrentUserInfo()!.uid}",
    );

    await databaseRef.update({
      'displayName': displayName,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
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
        'photoURL': userData['photoURL'],
        'fullName': userData['fullName'],
        'dateOfBirth': userData['dateOfBirth'],
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOthersUserInformation(String uid) async {
    final DatabaseReference databaseReference = _database.ref("users/uid");
    final snapshot = await databaseReference.once();
    final userData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (userData != null) {
      return {
        'uid': userData['uid'],
        'email': userData['email'],
        'displayName': userData['displayName'],
        'photoURL': userData['photoURL'],
        'fullName': userData['fullName'],
        'dateOfBirth': userData['dateOfBirth'],
      };
    }
    return null;
  }

  // Check account presence

  // Save message sent to RTDB
  Future<void> sendMessage(String message, String chatroomId) async {
    await _database.ref("chats/$chatroomId").push().set({
      'senderId': AuthService().getCurrentUserInfo()!.uid,
      'message': message,
      "createdAt": ServerValue.timestamp,
    });
  }

  //
  final databaseRef = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  // Set up presence for the user
  setupPresence() {
    final userStatusDatabaseRef = databaseRef.child(
      'users/${user!.uid}/status',
    );

    final isOfflineForDatabase = {
      "state": "offline",
      "last_changed": ServerValue.timestamp,
    };

    final isOnlineForDatabase = {
      "state": "online",
      "last_changed": ServerValue.timestamp,
    };

    final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        userStatusDatabaseRef.onDisconnect().set(isOfflineForDatabase).then((
          _,
        ) {
          userStatusDatabaseRef.set(isOnlineForDatabase);
        });
      }
    });
  }

  // Explicitly set user status to offline
  Future<void> setUserOffline() async {
    if (user != null) {
      final userStatusDatabaseRef = databaseRef.child(
        'users/${user!.uid}/status',
      );
      final isOfflineForDatabase = {
        "state": "offline",
        "last_changed": ServerValue.timestamp,
      };
      await userStatusDatabaseRef.set(isOfflineForDatabase);
    }
  }
}
