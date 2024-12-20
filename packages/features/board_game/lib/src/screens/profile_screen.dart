import 'dart:developer';

import 'package:board_game/board_game.dart';
import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String profilePictureUrl = 'https://picsum.photos/150/150'; // Par défaut
  List<Loot> loots = [];
  List<String> profilePictures = [];

  @override
  void initState() {
    super.initState();
    // Initialisation décalée après la phase de construction
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfilePictures();
    });
  }

  /// Initialise les images de profil en ajoutant une image par défaut
  /// dans la partie loot du `User`, puis en récupérant toutes les images disponibles
  Future<void> _initializeProfilePictures() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.displayName == null) {
        log('Utilisateur non connecté ou displayName absent');
        return;
      }

      // Ajout d'une image par défaut dans le loot de l'utilisateur
      const testImageUrl = 'https://picsum.photos/200/300'; // Image pour test
      await ref.read(lootboxProvider.notifier).addLootToUser(
            Loot(
              id: 'test_id', // ID arbitraire
              type: 'profile_picture',
              name: 'Test Image',
              reference: testImageUrl,
              weight: 0.5,
            ),
            currentUser.displayName!,
          );

      // Récupération des loots associés à l'utilisateur
      loots = await ref
          .read(lootboxProvider.notifier)
          .getLootFromUser(currentUser.displayName!);

      // Mise à jour de la liste des références d'images
      setState(() {
        profilePictures = loots.map((loot) => loot.reference).toList();
        if (profilePictures.isNotEmpty) {
          profilePictureUrl =
              profilePictures.first; // Met à jour l'image par défaut
        }
      });
    } catch (e) {
      log('Erreur lors de l\'initialisation des images de profil : $e');
    }
  }

  /// Met à jour la photo de profil dans Firebase Auth et Firestore
  Future<void> _updateProfilePicture(String newImageUrl) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.displayName == null) {
        throw Exception('Utilisateur non connecté ou displayName absent.');
      }

      // Mise à jour dans Firebase Auth
      await currentUser.updatePhotoURL(newImageUrl);
      await currentUser
          .reload(); // Recharge l'utilisateur pour valider les modifications

      // Mise à jour dans Firestore (dans la collection "users/{username}")
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.displayName!);
      await userDoc.update({'profilePictureUrl': newImageUrl});

      setState(() {
        profilePictureUrl = newImageUrl; // Met à jour localement
      });

      log('Photo de profil mise à jour avec succès.');
    } catch (e) {
      log('Erreur lors de la mise à jour de la photo de profil : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(authProvider).value;
    _populateUserInfo(user);

    return Scaffold(
      bottomNavigationBar: customBottomNavigationBar(context),
      body: _buildProfilePage(context),
      floatingActionButton: _floatingActionButton(),
    );
  }

  /// Met à jour les champs de texte avec les informations utilisateur
  void _populateUserInfo(User? user) {
    if (user != null) {
      usernameController.text = user.displayName ?? 'No username';
      emailController.text = user.email ?? 'No email';
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        profilePictureUrl = user.photoURL!;
      }
    }
  }

  /// Construit la page de profil
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

  /// Construit l'image de profil avec le bouton pour modifier
  Widget _buildProfilePicture() {
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
            child: _buildEditProfilePictureButton(),
          ),
        ],
      ),
    );
  }

  /// Construit le bouton pour modifier l'image de profil
  Widget _buildEditProfilePictureButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        onPressed: () {
          _showImageSelectionDialog(profilePictures);
        },
      ),
    );
  }

  /// Affiche une boîte de dialogue pour sélectionner une image de profil
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
                  child: _buildProfilePictureGrid(profilePictures),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construit la grille d'images pour la sélection
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
        return InkWell(
          onTap: () async {
            await _updateProfilePicture(imageUrl); // Met à jour la photo
            Navigator.of(context).pop(); // Ferme la boîte de dialogue
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  /// Construit un champ texte désactivé
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

  /// Construit le style de la carte du profil
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

  /// Construit le bouton d'action flottant
  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/open_lootbox');
      },
      child: const Icon(Icons.wallet_giftcard_outlined),
    );
  }
}
