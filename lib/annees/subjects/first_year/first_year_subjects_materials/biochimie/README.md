# Biochimie - Système Modulaire

## 📁 Structure des Fichiers

### **S1 - Premier Semestre**
```
s1/
├── s1_screen.dart                    # Écran principal S1
├── unites/
│   └── BIOCHIMIEGENERALE/
│       ├── biochimie_generale_screen.dart
│       └── exams/
│           └── 2023_2024/
│               └── qcm_exam_screen.dart
└── examen_complet/
    ├── examen_complet_widget_screen.dart      # Examen complet avec widgets
    ├── examen_filter_widget_screen.dart       # Examen avec filtrage
    └── examen_correction_widget_screen.dart   # Examen avec correction
```

## 🎯 Fonctionnalités Disponibles

### **1. BIOCHIMIE GENERALE**
- **EXAMENS 2023-2024**: Examens normaux
- **EXAMENS AVEC FILTRE**: Examens avec système de filtrage

### **2. EXAMEN COMPLET**
- **EXAMEN COMPLET**: Tous les questions sans filtrage
- **EXAMEN AVEC FILTRE**: Questions filtrées par catégorie
- **EXAMEN AVEC CORRECTION**: Examen avec système de correction

## 🔧 Système de Widgets

### **Widgets Utilisées:**
1. **QcmWidget**: Affichage des questions QCM
2. **ExamFilterWidget**: Filtrage des questions par catégorie
3. **CorrectionWidget**: Système de correction et résultats
4. **NotesWidget**: Gestion des notes
5. **ThemeSwitcherButton**: Changement de thème

### **Catégories de Filtrage:**
- Glucides – Généralités et Monosaccharides
- Réactions chimiques des oses
- Diholosides et oligosaccharides
- Polysaccharides
- Métabolisme des glucides (Glycolyse, Gluconéogenèse, Cycle de Krebs, Glycogène)
- Lipides – Structure et Propriétés
- Lipides complexes
- Lipoprotéines et Métabolisme lipidique

## 📊 Système de Correction

### **Calcul des Points:**
- **Réponse correcte complète**: Points complets
- **Réponse partielle correcte**: Points proportionnels
- **Réponse incorrecte**: 0 point
- **Pas de réponse**: 0 point

### **Affichage des Résultats:**
- Note finale sur 20
- Pourcentage de réussite
- Statut (Réussi/Échoué)
- Détails par question

## 🎨 Système de Thème

### **Thèmes Disponibles:**
- **Light**: Thème clair
- **Dark**: Thème sombre
- **Modern**: Thème moderne

### **Fonctionnalités:**
- Changement automatique de couleurs
- Adaptation des styles de texte
- Cohérence visuelle dans toute l'application

## 📝 Système de Notes

### **Fonctionnalités:**
- Ajout de notes pour chaque question
- Édition des notes existantes
- Suppression des notes
- Sauvegarde automatique

### **Organisation:**
- Notes liées à `subjectId` et `questionId`
- Interface intuitive
- Support multilingue

## 🚀 Utilisation

### **Navigation:**
1. **Biochimie S1** → Choisir le type d'examen
2. **BIOCHIMIE GENERALE** → Examens normaux ou avec filtrage
3. **EXAMEN COMPLET** → Tous les types d'examens

### **Filtrage:**
1. Sélectionner une catégorie
2. Questions filtrées automatiquement
3. Affichage du nombre de questions sélectionnées

### **Correction:**
1. Répondre aux questions
2. Cliquer sur "عرض النتائج" (Afficher les résultats)
3. Consulter les résultats détaillés
4. Option de recommencer

## 🔄 Avantages du Système Modulaire

### **Réutilisabilité:**
- Widgets utilisables dans tout le projet
- Code modulaire et organisé
- Facilité de maintenance

### **Flexibilité:**
- Ajout facile de nouvelles fonctionnalités
- Personnalisation simple
- Extension du système

### **Performance:**
- Chargement optimisé
- Gestion efficace de la mémoire
- Interface fluide

## 📋 Maintenance

### **Ajout de Nouvelles Questions:**
1. Modifier `assets/data/biochimie/questions_2023_2024.json`
2. Ajouter les nouvelles questions
3. Les questions apparaissent automatiquement

### **Modification des Catégories:**
1. Modifier `ExamFilterWidget`
2. Ajouter/supprimer des catégories
3. Mettre à jour les indices des questions

### **Ajout de Nouveaux Widgets:**
1. Créer le widget dans `lib/widgets/`
2. Ajouter l'export dans `lib/widgets/index.dart`
3. Utiliser dans les écrans

## ✅ Systèmes Préservés

- **Notes System**: `lib/notes/` - Complet
- **Correction System**: `lib/correction/` - Complet
- **QCM System**: `lib/qcm/` - Complet
- **Theme System**: `lib/theme/` - Complet
- **Widgets System**: `lib/widgets/` - Nouveau et modulaire 