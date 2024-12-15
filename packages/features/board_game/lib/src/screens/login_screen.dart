import 'package:logging/logging.dart';
import 'package:board_game/board_game.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  LoginPageType pageType = LoginPageType.login;
  final Logger _logger = Logger('LoginScreen');

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

  void _alternatePageType() {
    _clearFields();
    setState(() {
      pageType = pageType == LoginPageType.login
          ? LoginPageType.signUp
          : LoginPageType.login;
      _logger.info(pageType == LoginPageType.login
          ? 'Switched to login screen.'
          : 'Switched to sign-up screen.');
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _logger.warning('Invalid form submission');
      return;
    }

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final repeatPassword = repeatPasswordController.text;
    final userNotifier = ref.read(userProvider.notifier);

    try {
      if (pageType == LoginPageType.signUp) {
        await _handleSignUp(
            userNotifier, email, username, password, repeatPassword);
      } else {
        await _handleLogin(userNotifier, email, password);
      }
    } catch (e) {
      _logger.severe('Error during form submission: $e');
      _showSnackbar('Error: ${e.toString()}');
    }
  }

  Future<void> _handleSignUp(
    UserNotifier userNotifier,
    String email,
    String username,
    String password,
    String repeatPassword,
  ) async {
    if (username.isEmpty) {
      _logger.warning('Sign-up failed: username is missing.');
      _showSnackbar('Username is required');
      return;
    }
    if (password != repeatPassword) {
      _logger.warning('Sign-up failed: passwords do not match.');
      _showSnackbar('Passwords do not match');
      return;
    }

    final credential = await userNotifier.signUp(email, username, password);
    if (credential == null) {
      _logger.warning('Sign-up failed: user already exists.');
      _showSnackbar('User already exists');
    } else {
      _logger.info('Sign-up successful for $email');
      await userNotifier.addReferenceEmailUsername(email, username);
      await userNotifier.addPlayer(email, username, credential);
      _showSnackbar('Account created successfully!');
      setState(() => pageType = LoginPageType.login);
    }
  }

  Future<void> _handleLogin(
      UserNotifier userNotifier, String email, String password) async {
    final credential = await userNotifier.login(email, password);
    if (credential.isNotEmpty) {
      final username = await userNotifier.findUsernameByEmail(email);
      _logger.info('Login successful for $username');
      _showSnackbar('Login successful!');
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = pageType == LoginPageType.signUp;
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 21, 21, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32.0),
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
                  _buildTitle(),
                  const SizedBox(height: 16),
                  ..._buildFormFields(isSignUp),
                  _buildForgotPassword(isSignUp),
                  _buildSubmitButton(userState),
                  const SizedBox(height: 16),
                  _buildErrorMessage(userState),
                  const DividerWithText(),
                  _buildSocialLoginButtons(),
                  _buildTogglePageTypeButton(isSignUp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Little Strategy',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _buildFormFields(bool isSignUp) {
    return [
      _buildField(
        label: 'Email',
        controller: emailController,
        hintText: 'Enter your email',
        isPassword: false,
      ),
      if (isSignUp)
        _buildField(
          label: 'Username',
          controller: usernameController,
          hintText: 'Enter your username',
          isPassword: false,
        ),
      _buildField(
        label: 'Password',
        controller: passwordController,
        hintText: 'Enter your password',
        isPassword: true,
      ),
      if (isSignUp)
        _buildField(
          label: 'Repeat Password',
          controller: repeatPasswordController,
          hintText: 'Repeat your password',
          isPassword: true,
        ),
    ];
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BuildField(
        label: label,
        controller: controller,
        hintText: hintText,
        isPassword: isPassword,
      ),
    );
  }

  Widget _buildForgotPassword(bool isSignUp) {
    if (isSignUp) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: GestureDetector(
        onTap: () {
          _logger.info('Forgot password clicked.');
          Navigator.of(context).pushNamed('/forgot-password');
        },
        child: const Text(
          'Forgot your password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(UserState userState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed:
            userState.status == UserStateStatus.loading ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: userState.status == UserStateStatus.loading
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

  Widget _buildErrorMessage(UserState userState) {
    if (userState.status != UserStateStatus.error) {
      return const SizedBox.shrink();
    }
    return Text(
      userState.errorMessage ?? 'An error occurred.',
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSocialLoginButtons() {
    final loginMethodsUrl = [
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildSocialLoginRow(loginMethodsUrl.sublist(0, 4)),
          _buildSocialLoginRow(loginMethodsUrl.sublist(4)),
        ],
      ),
    );
  }

  Widget _buildSocialLoginRow(List<String> urls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: urls
          .map((url) => LoginMethod(
                url: url,
                fn: () => _logger.info('Social login attempted: $url'),
              ))
          .toList(),
    );
  }

  Widget _buildTogglePageTypeButton(bool isSignUp) {
    return TextButton(
      onPressed: _alternatePageType,
      child: Text(
        isSignUp
            ? 'Already have an account? Sign in'
            : 'Don\'t have an account? Sign up',
        style: GoogleFonts.lato(fontSize: 14, color: Colors.lightBlue),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Text('    or sign in with    '),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}
