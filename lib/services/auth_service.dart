import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  final _client = SupabaseService().client;

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  Future<void> signInWithOtp(String phone) async {
    await _client.auth.signInWithOtp(
      phone: phone,
    );
  }

  Future<AuthResponse> verifyOTP(String phone, String token) async {
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<UserModel?> getUserProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    
    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  Future<void> createUserProfile(UserModel user) async {
    await _client.from('users').upsert(user.toJson());
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? photoUrl,
    String? address,
    double? lat,
    double? lng,
  }) async {
    final Map<String, dynamic> updates = {};
    if (fullName != null) updates['full_name'] = fullName;
    if (photoUrl != null) updates['profile_photo_url'] = photoUrl;
    if (address != null) updates['default_address'] = address;
    if (lat != null) updates['default_latitude'] = lat;
    if (lng != null) updates['default_longitude'] = lng;

    await _client.from('users').update(updates).eq('id', userId);
  }
}
