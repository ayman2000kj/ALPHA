import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/widgets/qcm/unified_exam_widget.dart';
import 'package:aymologypro_new/widgets/qcm/qcm_widget.dart';
import 'package:aymologypro_new/services/qcm_json_service.dart';

class BiochimieGeneraleScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const BiochimieGeneraleScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<BiochimieGeneraleScreen> createState() =>
      _BiochimieGeneraleScreenState();
}

class _BiochimieGeneraleScreenState extends State<BiochimieGeneraleScreen> {
  List<QcmQuestion> _allQuestions = [];
  List<QcmQuestion> _filteredQuestions = [];
  bool _isLoading = true;
  String? _error;
  Set<String> _selectedCategories = {};

  // Classification des questions par catégories
  final Map<String, List<int>> _questionCategories = {
    'Glucides – Généralités et Monosaccharides': [1, 2, 3, 4, 5, 6],
    'Réactions chimiques des oses': [7, 8],
    'Diholosides et oligosaccharides': [9, 10],
    'Polysaccharides': [11, 12],
    'Métabolisme des glucides - Glycolyse': [13, 14, 15, 16],
    'Métabolisme des glucides - Gluconéogenèse & Pyruvate': [17, 19],
    'Métabolisme des glucides - Cycle de Krebs': [18, 23],
    'Métabolisme des glucides - Synthèse et dégradation du glycogène': [
      20,
      21,
      22
    ],
    'Lipides – Structure et Propriétés': [24, 25, 26, 27, 28],
    'Lipides complexes': [29, 30, 31, 32, 33, 34, 35],
    'Lipoprotéines et Métabolisme lipidique': [36, 37, 38, 39],
  };

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final questions = await QcmJsonService.instance.loadBiochimieQuestions();

      setState(() {
        _allQuestions = questions;
        _filteredQuestions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des questions: $e';
        _isLoading = false;
      });
    }
  }

  void _filterQuestions() {
    if (_selectedCategories.isEmpty) {
      setState(() {
        _filteredQuestions = _allQuestions;
      });
      return;
    }

    final filteredQuestions = <QcmQuestion>[];

    for (final category in _selectedCategories) {
      final questionNumbers = _questionCategories[category];
      if (questionNumbers != null) {
        for (final questionNumber in questionNumbers) {
          if (questionNumber <= _allQuestions.length) {
            filteredQuestions.add(_allQuestions[questionNumber - 1]);
          }
        }
      }
    }

    setState(() {
      _filteredQuestions = filteredQuestions;
    });
  }

  // void _toggleCategory(String category) {
  //   setState(() {
  //     if (_selectedCategories.contains(category)) {
  //       _selectedCategories.remove(category);
  //     } else {
  //       _selectedCategories.add(category);
  //     }
  //   });
  //   _filterQuestions();
  // }

  void _selectAllCategories() {
    setState(() {
      _selectedCategories = _questionCategories.keys.toSet();
    });
    _filterQuestions();
  }

  void _clearAllCategories() {
    setState(() {
      _selectedCategories.clear();
    });
    _filterQuestions();
  }

  void _showFilterDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            width: screenWidth * 0.75,
            height: screenHeight * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête unifié
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 100),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Filtres',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Boutons de contrôle compacts
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _selectAllCategories();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.select_all, size: 16),
                        label: Text(
                          'Tout',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 50),
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _clearAllCategories();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.clear_all, size: 16),
                        label: Text(
                          'Effacer',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 50),
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Liste des catégories compacte
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _questionCategories.keys.map((category) {
                        final isSelected =
                            _selectedCategories.contains(category);
                        final questionCount =
                            _questionCategories[category]!.length;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCategories.remove(category);
                                  } else {
                                    _selectedCategories.add(category);
                                  }
                                  _filterQuestions();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 100)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 150)
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 100),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 150),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                          ),
                                          Text(
                                            '$questionCount questions',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 150),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'Erreur de chargement',
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        _error!,
                        style: GoogleFonts.montserrat(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 150),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(
                          'Réessayer',
                          style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // زر الفلترة المضغوط
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          // Compteur de questions compact
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 100),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${_filteredQuestions.length}/${_allQuestions.length}',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Bouton de filtrage compact
                          ElevatedButton.icon(
                            onPressed: () {
                              _showFilterDialog(context);
                            },
                            icon: Icon(
                              Icons.filter_list,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            label: Text(
                              'Filtrer',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Affichage des questions filtrées
                    Expanded(
                      child: _filteredQuestions.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_list_off,
                                    size: MediaQuery.of(context).size.width *
                                        0.15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 100),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                    'Aucune question trouvée',
                                    style: GoogleFonts.montserrat(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Text(
                                    'Sélectionnez une ou plusieurs catégories',
                                    style: GoogleFonts.montserrat(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : UnifiedExamWidget(
                              questions: _filteredQuestions,
                              examTitle:
                                  'Biochimie Générale - Questions Filtrées',
                              appThemeMode: widget.appThemeMode,
                              onThemeChanged: widget.onThemeChanged,
                              onExamCompleted: (answers) {
                                // معالجة النتائج هنا
                                print('Exam completed with answers: $answers');
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
