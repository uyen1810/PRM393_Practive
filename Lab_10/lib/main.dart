import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

// Helper tạo GoogleSignIn tương thích cả Mobile lẫn Web
GoogleSignIn get _googleSignIn => GoogleSignIn(
      clientId: kIsWeb ? DefaultFirebaseOptions.webClientId : null,
    );


class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings =
          InitializationSettings(android: androidSettings);

      await _plugin.initialize(settings: initSettings);

      // Xin quyền thông báo trên Android 13+ (API 33+)
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Lỗi khởi tạo NotificationService: $e');
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'lab10_channel_id',
        'Lab 10 Notifications',
        channelDescription: 'Thông báo xác thực và hệ thống cho Lab 10',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails details =
          NotificationDetails(android: androidDetails);

      await _plugin.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('Lỗi hiển thị thông báo: $e');
    }
  }
}

bool isFirebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Local Notification (Lab 10.5)
  await NotificationService.init();

  // Khởi tạo Firebase (Lab 10.4) - Hỗ trợ cả Web & Mobile
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
  } catch (e) {
    try {
      await Firebase.initializeApp();
      isFirebaseInitialized = true;
    } catch (e2) {
      debugPrint('Firebase chưa được cấu hình đầy đủ: $e2');
    }
  }

  runApp(const Lab10FullApp());
}

class Lab10FullApp extends StatelessWidget {
  const Lab10FullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 Full - Auth & Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2)); 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 80),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang kiểm tra phiên đăng nhập (Auto-Login)...'),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. MÀN HÌNH ĐĂNG NHẬP TÍCH HỢP (LAB 10.1, 10.2, 10.4)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  // Chuyển đổi giữa Lab 10.1 (Mock) và Lab 10.2 (Real API DummyJSON)
  bool _useRealApi = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fillSampleAccount();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _fillSampleAccount() {
    if (_useRealApi) {
      _userController.text = 'emilys';
      _passController.text = 'emilyspass';
    } else {
      _userController.text = 'test@example.com';
      _passController.text = '123456';
    }
  }

  Future<void> _onLoginSuccess({
    required String token,
    required String username,
    required String email,
    required String loginMethod,
    String? photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', username);
    await prefs.setString('user_email', email);
    await prefs.setString('login_method', loginMethod);
    if (photoUrl != null) {
      await prefs.setString('user_photo', photoUrl);
    } else {
      await prefs.remove('user_photo');
    }

    // Gọi thông báo cục bộ sau khi đăng nhập thành công (Yêu cầu bắt buộc Lab 10.5)
    await NotificationService.showNotification(
      title: 'Đăng nhập thành công!',
      body: 'Xin chào $username! Bạn đã đăng nhập qua $loginMethod.',
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // Xử lý Lab 10.1 (Mock Login) & Lab 10.2 (Real API Login)
  Future<void> _handleFormLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final inputUser = _userController.text.trim();
    final inputPass = _passController.text.trim();

    try {
      if (!_useRealApi) {
        // --- LAB 10.1: MOCK LOGIN ---
        await Future.delayed(const Duration(seconds: 2));
        if (inputUser == 'test@example.com' && inputPass == '123456') {
          await _onLoginSuccess(
            token: 'mock_token_xyz_123456',
            username: 'Mock User',
            email: inputUser,
            loginMethod: 'Mock Login (Lab 10.1)',
          );
        } else {
          throw Exception('Sai tài khoản Mock! Hãy dùng test@example.com / 123456');
        }
      } else {
        // --- LAB 10.2: REAL REST API LOGIN (DummyJSON) ---
        final response = await http.post(
          Uri.parse('https://dummyjson.com/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': inputUser,
            'password': inputPass,
            'expiresInMins': 60,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = (data['accessToken'] ?? data['token'] ?? '').toString();
          final fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();

          await _onLoginSuccess(
            token: token,
            username: fullName.isEmpty ? inputUser : fullName,
            email: data['email'] ?? '$inputUser@dummyjson.com',
            loginMethod: 'DummyJSON REST API (Lab 10.2)',
            photoUrl: data['image'],
          );
        } else {
          final err = jsonDecode(response.body);
          throw Exception(err['message'] ?? 'Đăng nhập API thất bại');
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Xử lý Lab 10.4 (Firebase Google Sign-In)
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      if (!isFirebaseInitialized) {
        throw Exception(
          'Firebase chưa được cấu hình (thiếu google-services.json).',
        );
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // Người dùng hủy chọn tài khoản
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _onLoginSuccess(
          token: user.uid,
          username: user.displayName ?? 'Google User',
          email: user.email ?? 'No Email',
          loginMethod: 'Firebase Google Sign-In (Lab 10.4)',
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi Google Sign-In: $e'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10 - Authentication'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_person, size: 72, color: Colors.indigo),
              const SizedBox(height: 16),
              // Công tắc chuyển đổi giữa Lab 10.1 và Lab 10.2
              Card(
                child: SwitchListTile(
                  title: Text(
                    _useRealApi
                        ? 'Chế độ: Real API (Lab 10.2)'
                        : 'Chế độ: Mock Login (Lab 10.1)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _useRealApi
                        ? 'TK mẫu: emilys / emilyspass'
                        : 'TK mẫu: test@example.com / 123456',
                  ),
                  value: _useRealApi,
                  onChanged: (val) {
                    setState(() {
                      _useRealApi = val;
                      _fillSampleAccount();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: _useRealApi ? 'Username (DummyJSON)' : 'Email (Mock)',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng không để trống trường này';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.key),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Mật khẩu phải từ 4 ký tự trở lên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                ElevatedButton.icon(
                  onPressed: _handleFormLogin,
                  icon: const Icon(Icons.login),
                  label: Text(
                    _useRealApi
                        ? 'Đăng nhập qua REST API (Lab 10.2)'
                        : 'Đăng nhập Mock (Lab 10.1)',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('HOẶC'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text('Sign in with Google (Lab 10.4)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    NotificationService.showNotification(
                      title: 'Test Notification (Lab 10.5)',
                      body: 'Thông báo cục bộ hoạt động bình thường!',
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Bấm để Test nhanh Notification (Lab 10.5)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. MÀN HÌNH HOME & LOGOUT (LAB 10.3, 10.4, 10.5)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  String _email = '';
  String _loginMethod = '';
  String _token = '';
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('user_name') ?? 'User';
      _email = prefs.getString('user_email') ?? '';
      _loginMethod = prefs.getString('login_method') ?? '';
      _token = prefs.getString('auth_token') ?? '';
      _photoUrl = prefs.getString('user_photo');
    });
  }

  Future<void> _handleLogout() async {
    // 1. Xóa SharedPreferences (Lab 10.3)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 2. Đăng xuất khỏi Firebase & Google nếu có (Lab 10.4)
    if (isFirebaseInitialized) {
      try {
        await _googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    }

    // 3. Bắn thông báo đăng xuất (Lab 10.5)
    await NotificationService.showNotification(
      title: 'Đã đăng xuất',
      body: 'Phiên đăng nhập của bạn đã được xóa thành công.',
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Thông tin phiên'),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                      _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                      child: _photoUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _username,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      _email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(_loginMethod),
                      backgroundColor: Colors.indigo.shade50,
                    ),
                    const Divider(height: 24),
                    Text(
                      'Saved Token (SharedPreferences):',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _token.length > 40
                          ? '${_token.substring(0, 40)}...'
                          : _token,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                NotificationService.showNotification(
                  title: 'Xin chào $_username!',
                  body: 'Đây là thông báo cục bộ từ màn hình Home (Lab 10.5 - LO7).',
                );
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Kích hoạt Local Notification (Lab 10.5)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: const Text(
                'Logout & Xóa Session (Lab 10.3 & 10.4)',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}