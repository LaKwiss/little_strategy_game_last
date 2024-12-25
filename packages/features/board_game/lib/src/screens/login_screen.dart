import 'package:board_game/board_game.dart';
import 'package:board_game/src/providers/user/user_state.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

enum LoginPageType { login, signUp }

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  final _logger = Logger('LoginScreen');

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  var pageType = LoginPageType.login;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void _clearFields() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
  }

  void _togglePageType() {
    _clearFields();
    setState(() {
      pageType = pageType == LoginPageType.login
          ? LoginPageType.signUp
          : LoginPageType.login;
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final userNotifier = ref.read(userNotifierProvider.notifier);

    try {
      if (pageType == LoginPageType.signUp) {
        await _handleSignUp(userNotifier, email, username, password);
      } else {
        await _handleLogin(userNotifier, email, password);
      }
    } catch (e) {
      _logger.severe('Submit error: $e');
      _showError(e.toString());
    }
  }

  Future<void> _handleSignUp(
    UserNotifier notifier,
    String email,
    String username,
    String password,
  ) async {
    if (username.isEmpty) {
      _showError('Username required');
      return;
    }
    if (password != repeatPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    final credential = await notifier.signUp(email, username, password);
    if (credential == null) {
      _showError('User already exists');
      return;
    }

    await notifier.addReferenceEmailUsername(email, username);
    await notifier.addPlayer(email, username, credential);
    _showSuccess('Account created!');
    setState(() => pageType = LoginPageType.login);
  }

  Future<void> _handleLogin(
    UserNotifier notifier,
    String email,
    String password,
  ) async {
    await notifier.login(email, password);
    _showSuccess('Login successful!');
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _showError(String message) {
    _showToast(message, Type.error);
  }

  void _showSuccess(String message) {
    _showToast(message, Type.success);
  }

  void _showToast(String message, Type type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Toast(message: message, type: type),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = pageType == LoginPageType.signUp;
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 21, 21, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Little Strategy',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...buildFields(isSignUp),
                  if (!isSignUp) buildForgotPassword(),
                  buildSubmitButton(userState),
                  if (userState.error.isNotEmpty)
                    Text(
                      userState.error,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  DividerWithText(text: 'OR'),
                  buildSocialLogin(),
                  buildToggleButton(isSignUp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildFields(bool isSignUp) => [
        buildField(
          label: 'Email',
          controller: emailController,
          hintText: 'Enter your email',
        ),
        if (isSignUp)
          buildField(
            label: 'Username',
            controller: usernameController,
            hintText: 'Enter your username',
          ),
        buildField(
          label: 'Password',
          controller: passwordController,
          hintText: 'Enter your password',
          isPassword: true,
        ),
        if (isSignUp)
          buildField(
            label: 'Repeat Password',
            controller: repeatPasswordController,
            hintText: 'Repeat your password',
            isPassword: true,
          ),
      ];

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BuildField(
        label: label,
        controller: controller,
        hintText: hintText,
        isPassword: isPassword,
      ),
    );
  }

  Widget buildForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
        child: const Text(
          'Forgot your password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(UserState state) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: state.isLoading ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                pageType == LoginPageType.signUp ? 'SIGN UP' : 'SIGN IN',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget buildSocialLogin() {
    final loginMethods = [
      'packages/board_game/assets/svg/xbox.svg',
      'packages/board_game/assets/svg/playstation.svg',
      'packages/board_game/assets/svg/nintendo.svg',
      'packages/board_game/assets/svg/steam.svg',
      'packages/board_game/assets/svg/facebook.svg',
      'packages/board_game/assets/svg/google.svg',
      'packages/board_game/assets/svg/apple.svg',
      'packages/board_game/assets/svg/lego.svg',
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          buildLoginRow(loginMethods.sublist(0, 4)),
          buildLoginRow(loginMethods.sublist(4)),
        ],
      ),
    );
  }

  Widget buildLoginRow(List<String> urls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: urls
          .map((url) => LoginMethod(
                url: url,
                fn: () => _logger.info('Social login: $url'),
              ))
          .toList(),
    );
  }

  Widget buildToggleButton(bool isSignUp) {
    return TextButton(
      onPressed: _togglePageType,
      child: Text(
        isSignUp
            ? 'Already have an account? Sign in'
            : 'Don\'t have an account? Sign up',
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}
