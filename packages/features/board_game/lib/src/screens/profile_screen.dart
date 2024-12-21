import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  List<String> availablePictures = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _initializeProfilePictures();
  }

  Future<void> _initializeProfilePictures() async {
    if (_user?.displayName == null) return;

    if (mounted) setState(() => isLoading = true);

    try {
      // Ajout d'une image par défaut si absente
      final defaultPicture = 'https://picsum.photos/150/150';
      final defaultLoot = {
        'type': 'profile_picture',
        'reference': defaultPicture,
      };

      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.displayName);

      final lootRef =
          userDoc.collection('loots').doc('default_profile_picture');

      await lootRef.set(defaultLoot, SetOptions(merge: true));

      // Récupération des loots
      final loots = await userDoc
          .collection('loots')
          .where('type', isEqualTo: 'profile_picture')
          .get();

      if (mounted) {
        setState(() {
          availablePictures = loots.docs
              .map((doc) => doc.data()['reference'] as String)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      log('Error: $e');
    }
  }

  Future<void> _updateProfilePicture(String newImageUrl) async {
    // Si l'utilisateur ou son displayName est null, on arrête.
    if (_user?.displayName == null) return;

    if (mounted) setState(() => isLoading = true);

    try {
      final batch = FirebaseFirestore.instance.batch();
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.displayName);

      // On met à jour le document utilisateur dans Firestore
      batch.update(userDoc, {
        'profilePictureUrl': newImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await Future.wait([
        _user!.updatePhotoURL(newImageUrl),
        batch.commit(),
      ]);

      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      log('Error updating profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileContent(
      user: _user,
      isLoading: isLoading,
      availablePictures: availablePictures,
      onUpdatePicture: _updateProfilePicture,
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final User? user;
  final bool isLoading;
  final List<String> availablePictures;
  final Function(String) onUpdatePicture;

  const _ProfileContent({
    required this.user,
    required this.isLoading,
    required this.availablePictures,
    required this.onUpdatePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 80),
            _buildProfileInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/open_lootbox'),
        child: const Icon(Icons.wallet_giftcard_outlined),
      ),
    );
  }

  /// --------------------------------------------------------------------------
  ///  HEADER
  /// --------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: _buildProfilePicture(context),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.photoURL ??
                'https://commons.wikimedia.org/wiki/File:No_Image_Available.jpg'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildEditProfilePictureButton(context),
          ),
        ],
      ),
    );
  }

  /// Construit le bouton pour modifier l'image de profil
  Widget _buildEditProfilePictureButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        onPressed: () {
          _showImageSelectionDialog(context);
        },
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSelectionDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              // offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _showImageSelectionDialog(BuildContext context) {
    log('clicked');
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select a Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    itemCount: availablePictures.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final imageUrl = availablePictures[index];
                      return InkWell(
                        onTap: () {
                          onUpdatePicture(imageUrl);
                          Navigator.of(context).pop();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// --------------------------------------------------------------------------
  ///  PROFILE INFOS
  /// --------------------------------------------------------------------------
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTextField('Username', user?.displayName ?? 'No username'),
          const SizedBox(height: 16),
          _buildTextField('Email', user?.email ?? 'No email'),
        ],
      ),
    );
  }

  /// Ici, on force explicitement la width à 400 pour chaque champ.
  Widget _buildTextField(String label, String value) {
    return SizedBox(
      width: 400,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
