import 'package:board_game/board_game.dart';
import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget principal du profil utilisateur
/// Gère l'état et les animations avec Riverpod et TickerProvider
class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile>
    with SingleTickerProviderStateMixin {
  /// Clé globale pour le formulaire
  final _formKey = GlobalKey<FormState>();

  /// Contrôleur pour l'animation de brillance
  late final AnimationController _glowController;

  /// État local du profil
  ProfileData _profile = ProfileData.initial();

  /// Liste des récompenses de l'utilisateur
  List<Loot> _loots = [];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  /// Initialisation asynchrone de l'état
  Future<void> _initState() async {
    _initControllers();
    await WidgetsBinding.instance.endOfFrame;
    await _loadProfile();
  }

  /// Initialisation des contrôleurs d'animation
  void _initControllers() {
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  /// Charge le profil de l'utilisateur depuis Firebase
  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _initProfilePicture(user.displayName);
  }

  /// Initialise la photo de profil
  Future<void> _initProfilePicture(String? username) async {
    if (username == null) return;

    await _fetchUserLoots(username);
  }

  /// Récupère les récompenses de l'utilisateur
  Future<void> _fetchUserLoots(String username) async {
    final loots =
        await ref.read(lootboxProvider.notifier).getLootFromUser(username);
    if (!mounted) return;

    setState(() {
      _loots = loots;
      _profile = _profile.copyWith(
        profilePictures: loots.map((loot) => loot.reference).toList(),
      );
    });
  }

  /// Met à jour la photo de profil de l'utilisateur
  Future<void> _updateProfilePicture(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName == null) return;

    await user?.updatePhotoURL(imageUrl);
    await user?.reload();
    await ref.read(userNotifierProvider.notifier).setProfilePicture(imageUrl);

    setState(() => _profile = _profile.copyWith(profilePictureUrl: imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      backgroundColor: const Color(0xFF2C1518),
      body: Stack(
        children: [
          /// Fond dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3A1D21),
                  Color(0xFF2C1518),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                /// Bannière avec bouton d'édition
                ModernBanner(
                  url: _profile.bannerUrl,
                  onEdit: () => _showEditDialog(context),
                ),

                /// Carte de profil avec décalage vers le haut
                Transform.translate(
                  offset: const Offset(0, -50),
                  child: ModernProfileCard(
                    formKey: _formKey,
                    profile: _profile,
                    user: FirebaseAuth.instance.currentUser,
                    glowController: _glowController,
                    onSelectImage: () => _showImagePickerDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche le dialogue d'édition du profil
  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ModernEditDialog(
        onSelectImage: () {
          Navigator.pop(dialogContext);
          _showImagePickerDialog(context);
        },
        onSelectBackground: () {
          Navigator.pop(dialogContext);
          _showBackgroundColorDialog(context);
        },
        onSelectBanner: () {
          Navigator.pop(dialogContext);
          _showBannerDialog(context);
        },
      ),
    );
  }

  /// Affiche le sélecteur d'images
  void _showImagePickerDialog(BuildContext context) {
    if (_profile.profilePictures.isEmpty) {
      _showNoImagesDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => ModernImagePickerDialog(
        onBack: () {
          Navigator.pop(dialogContext);
          _showEditDialog(context);
        },
        pictures: _profile.profilePictures,
        onSelect: _updateProfilePicture,
      ),
    );
  }

  /// Affiche un message si aucune image n'est disponible
  void _showNoImagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ModernAlertDialog(
        title: 'No Images Available',
        content: 'There are no profile pictures available to select.',
        onBack: () {
          Navigator.pop(dialogContext);
          _showEditDialog(context);
        },
      ),
    );
  }

  /// Affiche le sélecteur de couleur de fond (non implémenté)
  void _showBackgroundColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ModernAlertDialog(
        title: 'Background Color',
        content: 'Color selection not implemented.',
        onBack: () {
          Navigator.pop(dialogContext);
          _showEditDialog(context);
        },
      ),
    );
  }

  /// Affiche le sélecteur de bannière (non implémenté)
  void _showBannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ModernAlertDialog(
        title: 'Banner Selection',
        content: 'Banner selection not implemented.',
        onBack: () {
          Navigator.pop(dialogContext);
          _showEditDialog(context);
        },
      ),
    );
  }
}
