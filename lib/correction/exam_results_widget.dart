import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/correction/exam_correction_service.dart';

// Enum لحالات السؤال
enum QuestionStatus {
  correct,
  partial,
  incorrect,
  unanswered,
}

class ExamResultsWidget extends StatelessWidget {
  final ExamResult result;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const ExamResultsWidget({
    super.key,
    required this.result,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withValues(alpha: 26),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // النتيجة الرئيسية
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: result.isPassed
                  ? Colors.green.withValues(alpha: 26)
                  : Colors.red.withValues(alpha: 26),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: result.isPassed ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Note finale',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: result.isPassed
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.totalScore.toStringAsFixed(2)}/${result.maxScore}',
                  style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: result.isPassed
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFE53935),
                  ),
                ),
                Text(
                  '${result.percentage.toStringAsFixed(1)}%',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: result.isPassed
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFE53935),
                  ),
                ),
                Text(
                  result.isPassed ? 'Réussi!' : 'Échoué',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: result.isPassed
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // تفاصيل الإجابات
          _buildResultItem(
              '🎯 Réponses correctes', result.correctAnswers, Colors.green),
          _buildResultItem(
              '⚡ Réponses partielles', result.partialAnswers, Colors.orange),
          _buildResultItem(
              '💥 Réponses incorrectes', result.wrongAnswers, Colors.red),
          _buildResultItem('⏰ Questions non répondues',
              result.unansweredQuestions, Colors.grey),

          const SizedBox(height: 20),

          // معلومات النظام
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF1976D2),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Détails du système de notation:',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Points par question: ${result.pointsPerQuestion.toStringAsFixed(2)}\n'
                  '• Correction partielle négative appliquée\n'
                  '• Une mauvaise réponse annule tous les points de la question',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // أزرار التحكم
          if (onRetry != null || onBack != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                if (onRetry != null) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('Recommencer'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
                if (onRetry != null && onBack != null)
                  const SizedBox(width: 16),
                if (onBack != null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Retour'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, int count, Color color) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              count.toString(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getDarkerShade(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDarkerShade(Color color) {
    if (color == Colors.green) return const Color(0xFF388E3C);
    if (color == Colors.orange) return const Color(0xFFF57C00);
    if (color == Colors.red) return const Color(0xFFD32F2F);
    if (color == Colors.grey) return const Color(0xFF616161);
    return color;
  }
}

class QuestionResultWidget extends StatelessWidget {
  final QuestionResult questionResult;
  final int questionIndex;

  const QuestionResultWidget({
    super.key,
    required this.questionResult,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    String statusText;

    if (questionResult.isUnanswered) {
      backgroundColor = Colors.grey.withValues(alpha: 26);
      textColor = const Color(0xFF616161);
      borderColor = Colors.grey;
      statusText = '⏰ Non répondu';
    } else if (questionResult.hasWrongAnswer) {
      backgroundColor = Colors.red.withValues(alpha: 26);
      textColor = const Color(0xFFD32F2F);
      borderColor = Colors.red;
      statusText = '💥 Incorrect';
    } else if (questionResult.isCorrect) {
      backgroundColor = Colors.green.withValues(alpha: 26);
      textColor = const Color(0xFF388E3C);
      borderColor = Colors.green;
      statusText = '🎯 Correct';
    } else if (questionResult.isPartial) {
      backgroundColor = Colors.orange.withValues(alpha: 26);
      textColor = const Color(0xFFF57C00);
      borderColor = Colors.orange;
      statusText = '⚡ Partiel';
    } else {
      backgroundColor = Colors.red.withValues(alpha: 26);
      textColor = const Color(0xFFD32F2F);
      borderColor = Colors.red;
      statusText = '💥 Incorrect';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question ${questionIndex + 1}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                statusText,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${questionResult.score.toStringAsFixed(2)}/${questionResult.maxScore}',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (questionResult.correctSelected > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Réponses correctes sélectionnées: ${questionResult.correctSelected}/${questionResult.totalCorrect}',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 179),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
