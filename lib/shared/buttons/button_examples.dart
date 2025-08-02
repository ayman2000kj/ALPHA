import 'package:flutter/material.dart';
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';

// Exemples d'utilisation des boutons partagés
class ButtonExamples extends StatelessWidget {
  const ButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemples de boutons partagés'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Boutons de base',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Bouton principal
            AppButton(
              title: 'Bouton principal',
              icon: Icons.star,
              onTap: () => print('Bouton principal'),
              style: AppButtonStyle.primary,
              color: Colors.blue,
            ),

            // Bouton secondaire
            AppButton(
              title: 'Bouton secondaire',
              icon: Icons.favorite,
              onTap: () => print('Bouton secondaire'),
              style: AppButtonStyle.secondary,
              color: Colors.red,
            ),

            // Bouton avec bordure
            AppButton(
              title: 'Bouton avec bordure',
              icon: Icons.settings,
              onTap: () => print('Bouton avec bordure'),
              style: AppButtonStyle.outline,
              color: Colors.green,
            ),

            // Bouton texte
            AppButton(
              title: 'Bouton texte',
              icon: Icons.info,
              onTap: () => print('Bouton texte'),
              style: AppButtonStyle.text,
              color: Colors.orange,
            ),

            const SizedBox(height: 32),
            const Text(
              'Boutons de matières',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Bouton matière
            SubjectButton(
              title: 'Anatomie',
              icon: Icons.favorite,
              color: Colors.red,
              onTap: () => print('Anatomie'),
              subtitle: 'Première année',
            ),

            const SizedBox(height: 16),
            SubjectButton(
              title: 'Biochimie',
              icon: Icons.science,
              color: Colors.blue,
              onTap: () => print('Biochimie'),
              subtitle: 'Première année',
            ),

            const SizedBox(height: 32),
            const Text(
              'Petits boutons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                CompactButton(
                  title: 'Paramètres',
                  icon: Icons.settings,
                  color: Colors.grey,
                  onTap: () => print('Paramètres'),
                ),
                const SizedBox(width: 16),
                CompactButton(
                  title: 'Aide',
                  icon: Icons.help,
                  color: Colors.orange,
                  onTap: () => print('Aide'),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              'Boutons spéciaux',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Bouton icône seulement
            AppButton(
              title: '',
              icon: Icons.add,
              onTap: () => print('Bouton icône'),
              style: AppButtonStyle.icon,
              color: Colors.purple,
              width: 60,
              height: 60,
            ),

            const SizedBox(height: 16),

            // Bouton avec flèche
            AppButton(
              title: 'Bouton avec flèche',
              icon: Icons.arrow_forward,
              onTap: () => print('Bouton avec flèche'),
              style: AppButtonStyle.primary,
              color: Colors.teal,
              showArrow: true,
            ),

            const SizedBox(height: 16),

            // Bouton avec sous-titre
            AppButton(
              title: 'Bouton avec sous-titre',
              icon: Icons.info,
              onTap: () => print('Bouton avec sous-titre'),
              style: AppButtonStyle.primary,
              color: Colors.indigo,
              subtitle: 'Ceci est un sous-titre pour le bouton',
            ),

            const SizedBox(height: 32),
            const Text(
              'Boutons désactivés',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

                         AppButton(
               title: 'Bouton désactivé',
               icon: Icons.block,
               onTap: null,
               style: AppButtonStyle.primary,
               color: Colors.grey,
               isEnabled: false,
             ),
          ],
        ),
      ),
    );
  }
}
