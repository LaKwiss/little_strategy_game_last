import 'package:board_game/board_game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late String profilePictureUrl =
      'https://picsum.photos/150/150'; // Placeholder

  @override
  Widget build(BuildContext context) {
    // Listen to authentication state
    _handleAuthStateChanges(context);

    // Fetch user data
    final User? user = ref.watch(authProvider).value;
    _populateUserInfo(user);

    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _buildProfilePage(context),
    );
  }

  /// Handles redirection if the user is logged out
  void _handleAuthStateChanges(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.value == null &&
          ModalRoute.of(context)?.settings.name != '/login') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    });
  }

  /// Populates user information into the text fields
  void _populateUserInfo(User? user) {
    if (user != null) {
      usernameController.text = user.displayName ?? 'No username';
      emailController.text = user.email ?? 'No email';
      profilePictureUrl = user.photoURL ?? profilePictureUrl;
    }
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: NavigationBar(
        destinations: [
          _buildNavIcon(Icons.home, '/home', context),
          _buildNavIcon(Icons.list, '/lobby', context),
          _buildNavIcon(Icons.person, '/profile', context),
        ],
      ),
    );
  }

  /// Creates a reusable navigation icon button
  Widget _buildNavIcon(IconData icon, String route, BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(route),
      icon: Icon(icon),
    );
  }

  /// Builds the profile page body
  Widget _buildProfilePage(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24.0),
        decoration: _buildCardDecoration(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 24),
            _buildTextField('Username', usernameController),
            const SizedBox(height: 16),
            _buildTextField('Email', emailController),
          ],
        ),
      ),
    );
  }

  /// Builds the profile picture widget with change option
  Widget _buildProfilePicture() {
    final List<String> profilePictures =
        ref.watch(userProvider).profilePictures;

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profilePictureUrl),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildEditProfilePictureButton(profilePictures),
          ),
        ],
      ),
    );
  }

  /// Builds the edit profile picture button
  Widget _buildEditProfilePictureButton(List<String> profilePictures) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.camera_alt),
        onPressed: () => _showImageSelectionDialog(profilePictures),
      ),
    );
  }

  /// Shows the dialog for selecting a profile picture
  void _showImageSelectionDialog(List<String> profilePictures) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.maxFinite,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select a Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildProfilePictureGrid(profilePictures)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the grid for profile picture selection
  Widget _buildProfilePictureGrid(List<String> profilePictures) {
    return GridView.builder(
      itemCount: profilePictures.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final imageUrl = profilePictures[index];
        return _buildProfilePictureOption(imageUrl);
      },
    );
  }

  /// Builds a selectable profile picture option
  Widget _buildProfilePictureOption(String imageUrl) {
    return InkWell(
      onTap: () {
        // Implement profile picture change logic
        Navigator.of(context).pop();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text(
                  'Select',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a disabled text field
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        enabled: false,
      ),
    );
  }

  /// Builds the card-like decoration for the profile page container
  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(51),
          blurRadius: 30,
          spreadRadius: 10,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
