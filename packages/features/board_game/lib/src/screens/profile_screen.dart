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
  List<String> availableBanners = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _initializeProfilePictures();
    _initializeBanners();
  }

  Future<void> _initializeProfilePictures() async {
    if (_user?.displayName == null) return;
    if (mounted) setState(() => isLoading = true);

    try {
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

  Future<void> _initializeBanners() async {
    if (_user?.displayName == null) return;
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.displayName);

      final banners = await userDoc.collection('banners').get();

      if (mounted) {
        setState(() {
          availableBanners = banners.docs
              .map((doc) => doc.data()['reference'] as String)
              .toList();
        });
      }
    } catch (e) {
      log('Error loading banners: $e');
    }
  }

  Future<void> _updateProfilePicture(String newImageUrl) async {
    if (_user?.displayName == null) return;
    if (mounted) setState(() => isLoading = true);

    try {
      final batch = FirebaseFirestore.instance.batch();
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.displayName);

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
      availableBanners: availableBanners,
      onUpdatePicture: _updateProfilePicture,
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final User? user;
  final bool isLoading;
  final List<String> availablePictures;
  final List<String> availableBanners;
  final Function(String) onUpdatePicture;

  const _ProfileContent({
    required this.user,
    required this.isLoading,
    required this.availablePictures,
    required this.availableBanners,
    required this.onUpdatePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _editProfile(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 80),
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _editProfile(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context, builder: (context) => throw UnimplementedError()),
      child: const Icon(Icons.edit),
    );
  }

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

  Widget _buildEditBannerButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mode_edit_outline),
      onPressed: () => _showBannerSelectionDialog(context),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://commons.wikimedia.org/wiki/File:No_Image_Available.jpg'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showBannerSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Banner',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Expanded(
                child:
                    Center(child: Text('Banner selection to be implemented')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Profile Picture',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 400,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: availablePictures.length,
                  itemBuilder: (context, index) {
                    final imageUrl = availablePictures[index];
                    final isSelected = user?.photoURL == imageUrl;

                    return GestureDetector(
                      onTap: () {
                        onUpdatePicture(imageUrl);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 3)
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
