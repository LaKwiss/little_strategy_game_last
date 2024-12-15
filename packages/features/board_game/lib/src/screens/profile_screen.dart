import 'package:board_game/board_game.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController usernameController = TextEditingController();

  String profilePictureUrl =
      'https://picsum.photos/150/150'; // URL temporaire pour la photo de profil

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).fetchAndSetProfilePictures();
    });
    super.initState();
  }

  static void _changeProfilePicture(
      String url, WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(userProvider.notifier).setProfilePicture(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateProfile() {
    Logger('Profile').info('Updating profile');
  }

  void _viewImage(List<String> profilePictures, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return ImageViewer(profilePictures: profilePictures, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> profilePictures =
        ref.watch(userProvider).profilePictures;

    final Player? p = ref.watch(userProvider).currentPlayer;

    Logger('Profile').info('Building profile screen');
    Logger('Profile').info('Profile pictures: $profilePictures');
    Logger('Profile').info('P: $p');

    if (p != null && p.username.isNotEmpty) {
      usernameController.text = p.username;
    } else {
      usernameController.text = 'Error loading username';
    }

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        child: NavigationBar(
          destinations: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/lobby');
              },
              icon: const Icon(Icons.list),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                blurRadius: 30,
                spreadRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilePictureUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: SizedBox(
                                  height: 800,
                                  width: 600,
                                  child: GridView.builder(
                                    itemCount: profilePictures.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4),
                                    itemBuilder: (context, index) => SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: GestureDetector(
                                          onTap: () => _changeProfilePicture(
                                            profilePictures[index],
                                            ref,
                                            context,
                                          ),
                                          onLongPress: () => _viewImage(
                                              profilePictures, index),
                                          child: Image.network(
                                              profilePictures[index]),
                                        )),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BuildField(
                label: 'Username',
                controller: usernameController,
                hintText: 'Enter your username',
                isPassword: false,
                isEnabled: false,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends ConsumerStatefulWidget {
  const ImageViewer(
      {required this.profilePictures, required this.index, super.key});

  final List<String> profilePictures;
  final int index;

  @override
  ConsumerState<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends ConsumerState<ImageViewer> {
  late int i;

  @override
  void initState() {
    super.initState();
    i = widget.index;
  }

  void _incrementIndex() {
    if (i < widget.profilePictures.length - 1) {
      setState(() {
        i++;
      });
    } else {
      setState(() {
        i = 0;
      });
    }
  }

  void _decrementIndex() {
    if (i > 0) {
      setState(() {
        i--;
      });
    } else {
      setState(() {
        i = widget.profilePictures.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _decrementIndex(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      widget.profilePictures[i],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _incrementIndex(),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ProfileState._changeProfilePicture(
          widget.profilePictures[i],
          ref,
          context,
        ),
      ),
    );
  }
}
