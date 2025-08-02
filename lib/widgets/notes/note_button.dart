import 'package:flutter/material.dart';
import 'note_model.dart';
import 'note_service.dart';
import 'note_dialog.dart';
import '../theme/app_theme_mode.dart';

class NoteButton extends StatefulWidget {
  final String noteId; // كان questionId
  final String noteLabel; // كان questionText
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const NoteButton({
    super.key,
    required this.noteId,
    required this.noteLabel,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  Note? _currentNote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  @override
  void didUpdateWidget(NoteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إعادة تحميل إذا تغير noteId
    if (oldWidget.noteId != widget.noteId) {
      _loadNote();
    }
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
    });

    final note = await NoteService.getNoteForQuestion(widget.noteId);

    if (mounted) {
      setState(() {
        _currentNote = note;
        _isLoading = false;
      });
    }
  }

  Future<void> _showNoteDialog() async {
    final result = await showDialog<Note?>(
      context: context,
      builder: (context) => NoteDialog(
        noteId: widget.noteId,
        noteLabel: widget.noteLabel,
        existingNote: _currentNote,
        appThemeMode: widget.appThemeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    );

    // إعادة تحميل الملاحظة بعد العودة من Dialog
    if (result != null || _currentNote != null) {
      await _loadNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final hasNote = _currentNote != null && _currentNote!.content.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: hasNote
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 100)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: hasNote
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1)
            : null,
      ),
      child: IconButton(
        onPressed: _showNoteDialog,
        icon: Icon(
          hasNote ? Icons.note : Icons.note_add,
          color: hasNote
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),
          size: 20,
        ),
        tooltip: hasNote ? 'عرض/تعديل الملاحظة' : 'إضافة ملاحظة',
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(32, 32),
        ),
      ),
    );
  }
}
