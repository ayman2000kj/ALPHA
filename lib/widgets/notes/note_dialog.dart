import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note_model.dart';
import 'note_service.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class NoteDialog extends StatefulWidget {
  final String noteId; // كان questionId
  final String noteLabel; // كان questionText
  final Note? existingNote;
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const NoteDialog({
    super.key,
    required this.noteId,
    required this.noteLabel,
    required this.existingNote,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.existingNote?.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_controller.text.trim().isEmpty) {
      // إذا كانت الملاحظة فارغة، احذفها
      if (widget.existingNote != null) {
        await NoteService.deleteNote(widget.noteId);
      }
      if (mounted) {
        Navigator.of(context).pop(null);
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final note = Note(
        id: widget.existingNote?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        noteId: widget.noteId,
        content: _controller.text.trim(),
        createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await NoteService.saveNote(note);

      if (mounted) {
        Navigator.of(context).pop(note);
      }
    } catch (e) {
      if (mounted) {
        // لا نعرض رسالة خطأ حمراء، فقط نتجاهل الخطأ
        print('Erreur lors de la sauvegarde de la note: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الملاحظة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isSaving = true;
      });

      try {
        await NoteService.deleteNote(widget.noteId);
        if (mounted) {
          Navigator.of(context).pop(null);
        }
      } catch (e) {
        if (mounted) {
          // لا نعرض رسالة خطأ حمراء، فقط نتجاهل الخطأ
          print('Erreur lors de la suppression de la note: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 26),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ملاحظة للسؤال',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ThemeService().toggleTheme();
                    },
                    icon: Icon(ThemeService().currentThemeIcon),
                  ),
                ],
              ),
            ),

            // Question Text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السؤال:',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 77),
                      ),
                    ),
                    child: Text(
                      widget.noteLabel,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Note Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                maxLines: 8,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: 'اكتب ملاحظتك هنا...',
                  hintStyle: GoogleFonts.montserrat(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 128),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (widget.existingNote != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isSaving ? null : _deleteNote,
                        icon: const Icon(Icons.delete),
                        label: Text(
                          'حذف',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  if (widget.existingNote != null) const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isSaving ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'إلغاء',
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveNote,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isSaving ? 'جاري الحفظ...' : 'حفظ',
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
