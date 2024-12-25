import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:board_game/src/widgets/modern_text_field.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class CreateLootFormScreen extends ConsumerStatefulWidget {
  const CreateLootFormScreen({super.key});

  @override
  _CreateLootFormScreenState createState() => _CreateLootFormScreenState();
}

class _CreateLootFormScreenState extends ConsumerState<CreateLootFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final Logger _logger = Logger('LootFormScreen');

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String type = _typeController.text;
      final String name = _nameController.text;
      final String reference = _referenceController.text;
      final double weight = double.parse(_weightController.text);

      // Log the data
      _logger.info(
          'Loot created: {type: $type, name: $name, reference: $reference, weight: $weight}');

      await ref.read(lootboxProvider.notifier).createLoot(
            Loot(
              id: '1',
              type: type,
              name: name,
              reference: reference,
              weight: weight,
            ),
          );

      // Reset the form
      _formKey.currentState!.reset();
      _showSnackBar('Loot créé avec succès !');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModernTextField(
                      _typeController, 'Type', 'Veuillez entrer un type'),
                  ModernTextField(
                      _nameController, 'Nom', 'Veuillez entrer un nom'),
                  ModernTextField(_referenceController, 'Référence',
                      'Veuillez entrer une référence'),
                  ModernTextField(
                      _weightController, 'Poids', 'Veuillez entrer un poids'),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                      child: Text('Créer le loot'),
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
