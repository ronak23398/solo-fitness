import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late DatabaseService _databaseService;
  
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  
  // Flag to track initialization
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize DatabaseService
    if (!Get.isRegistered<DatabaseService>()) {
      _databaseService = Get.put(DatabaseService());
    } else {
      _databaseService = Get.find<DatabaseService>();
    }
    
    // Start listening to auth state changes
    _initializeAuthListener();
  }
  
  void _initializeAuthListener() {
    // Bind Firebase user stream
    firebaseUser.bindStream(_auth.authStateChanges());
    
    // Handle auth state changes
    ever(firebaseUser, (User? user) async {
      if (user != null) {
        // User is logged in, fetch their data
        await _fetchUserData(user.uid);
      } else {
        // User is not logged in
        currentUser.value = null;
      }
      
      // Set initialized after handling initial auth state
      if (!isInitialized.value) {
        isInitialized.value = true;
      }
    });
  }

  // Get current Firebase user
  User? get user => firebaseUser.value;

  Future<void> _fetchUserData(String uid) async {
    try {
      final userData = await _databaseService.userService.getUser(uid);
      if (userData != null) {
        currentUser.value = userData;
        
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      
      // Create user in database
      final newUser = UserModel(
        id: credential.user?.uid,
        email: credential.user?.email,
        username: displayName,
        photoUrl: credential.user?.photoURL,
      );
      
      await _databaseService.userService.createUser(newUser);
      
      return credential;
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Check if this is a new user
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      
      if (isNewUser) {
        // Create user in database
        final newUser = UserModel(
          id: userCredential.user?.uid,
          email: userCredential.user?.email,
          username: userCredential.user?.displayName,
          photoUrl: userCredential.user?.photoURL,
        );
        
        await _databaseService.userService.createUser(newUser);
      }
      
      return userCredential;
    } catch (e) {
      print('Error during Google sign in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error during password reset: $e');
      rethrow;
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _databaseService.userService.updateUser(user);
      currentUser.value = user;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
  // Use black heart to revive
  Future<void> useBlackHeart() async {
    try {
      if (currentUser.value != null) {
        if (currentUser.value!.blackHearts > 0) {
          currentUser.value!.blackHearts--;
          currentUser.value!.isDead = false;
          await _databaseService.userService.updateUser(currentUser.value!);
        }
      }
    } catch (e) {
      print('Error using black heart: $e');
      rethrow;
    }
  }

  // Add black heart
  Future<void> addBlackHeart(int count) async {
    try {
      if (currentUser.value != null) {
        currentUser.value!.blackHearts += count;
        await _databaseService.userService.updateUser(currentUser.value!);
      }
    } catch (e) {
      print('Error adding black heart: $e');
      rethrow;
    }
  }
}