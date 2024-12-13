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

  void _alternatePageType() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    repeatPasswordController.clear();

    setState(() {
      if (pageType == LoginPageType.login) {
        _logger.info('Passage à l\'écran d\'inscription.');
        pageType = LoginPageType.signUp;
      } else {
        _logger.info('Passage à l\'écran de connexion.');
        pageType = LoginPageType.login;
      }
    });
  }

  Future<void> _onSubmit() async {
    final String email = emailController.text.trim();
    final String username = usernameController.text.trim();
    final String password = passwordController.text;
    final String repeatPassword = repeatPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _logger.warning('Tentative de soumission sans email ou mot de passe.');
      _showSnackbar('Email and Password are required');
      return;
    }

    final userNotifier = ref.read(userProvider.notifier);

    try {
      if (pageType == LoginPageType.signUp) {
        _logger.info('Tentative de création de compte pour $email.');
        if (username.isEmpty) {
          _logger
              .warning('Nom d\'utilisateur manquant lors de l\'inscription.');
          _showSnackbar('Username is required');
          return;
        }
        if (password != repeatPassword) {
          _logger
              .warning('Les mots de passe ne correspondent pas pour $email.');
          _showSnackbar('Passwords do not match');
          return;
        }

        final String? credential =
            await userNotifier.addUser(email, username, password);

        if (credential == null) {
          _logger.warning(
              'Échec de la création du compte, l\'utilisateur existe déjà: $email');
          _showSnackbar('User already exists');
        } else {
          _logger.info('Compte créé avec succès: $email, $username');
          await userNotifier.addPlayer(email, username, credential);
          _showSnackbar('Account created successfully!');
          setState(() => pageType = LoginPageType.login);
        }
      } else {
        _logger.info('Tentative de connexion de l\'utilisateur: $email');
        await userNotifier.login(email, password);
        _logger.info('Connexion réussie: $email');
        _showSnackbar('Login successful!');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _logger.severe('Erreur lors de la soumission du formulaire: $e');
      _showSnackbar('Error: ${e.toString()}');
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

    final List<String> loginMethodsUrl = [
      'packages/board_game/assets/svg/xbox.svg',
      'packages/board_game/assets/svg/playstation.svg',
      'packages/board_game/assets/svg/nintendo.svg',
      'packages/board_game/assets/svg/steam.svg',
      'packages/board_game/assets/svg/facebook.svg',
      'packages/board_game/assets/svg/google.svg',
      'packages/board_game/assets/svg/apple.svg',
      'packages/board_game/assets/svg/lego.svg',
    ];

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
                  const Text(
                    'Little Strategy',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildField(
                      label: 'Email',
                      controller: emailController,
                      hintText: 'Enter your email',
                      isPassword: false,
                    ),
                  ),
                  if (isSignUp)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuildField(
                        label: 'Username',
                        controller: usernameController,
                        hintText: 'Enter your username',
                        isPassword: false,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildField(
                      label: 'Password',
                      controller: passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                    ),
                  ),
                  if (!isSignUp)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            _logger.info(
                                'L\'utilisateur demande la réinitialisation de son mot de passe.');
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
                      ),
                    ),
                  if (isSignUp)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuildField(
                        label: 'Repeat Password',
                        controller: repeatPasswordController,
                        hintText: 'Repeat your password',
                        isPassword: true,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: userState.status == UserStateStatus.loading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                _logger.info(
                                    'Formulaire valide, tentative de soumission.');
                                await _onSubmit();
                              } else {
                                _logger.warning(
                                    'Formulaire invalide, vérifiez les champs.');
                              }
                            },
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
                              isSignUp ? 'SIGN UP' : 'SIGN IN',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (userState.status == UserStateStatus.error)
                    Text(
                      userState.errorMessage ?? 'An error occurred.',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  else
                    const SizedBox.shrink(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Text('    or sign in with    '),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LoginMethod(
                              url: loginMethodsUrl[0],
                              fn: () async {
                                _logger
                                    .info('Tentative de connexion via Xbox.');
                              },
                            ),
                            LoginMethod(
                              url: loginMethodsUrl[1],
                              fn: () async {
                                _logger.info(
                                    'Tentative de connexion via Playstation.');
                              },
                            ),
                            LoginMethod(
                                fn: () async {
                                  _logger.info(
                                      'Tentative de connexion via Nintendo.');
                                },
                                url: loginMethodsUrl[2]),
                            LoginMethod(
                              url: loginMethodsUrl[3],
                              fn: () async {
                                _logger
                                    .info('Tentative de connexion via Steam.');
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LoginMethod(
                              url: loginMethodsUrl[4],
                              fn: () async {
                                _logger.info(
                                    'Tentative de connexion via Facebook.');
                              },
                            ),
                            LoginMethod(
                              url: loginMethodsUrl[5],
                              fn: () async {
                                _logger
                                    .info('Tentative de connexion via Google.');
                              },
                            ),
                            LoginMethod(
                              url: loginMethodsUrl[6],
                              fn: () async {
                                _logger
                                    .info('Tentative de connexion via Apple.');
                              },
                            ),
                            LoginMethod(
                              url: loginMethodsUrl[7],
                              fn: () async {
                                _logger
                                    .info('Tentative de connexion via Lego.');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _alternatePageType,
                    child: Text(
                      isSignUp
                          ? 'Already have an account? Sign in'
                          : 'Don\'t have an account? Sign up',
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
