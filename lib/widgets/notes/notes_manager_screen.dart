import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note_model.dart';
import 'note_service.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class NotesManagerScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const NotesManagerScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<NotesManagerScreen> createState() => _NotesManagerScreenState();
}

class _NotesManagerScreenState extends State<NotesManagerScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notes = await NoteService.getAllNotes();
      if (mounted) {
        setState(() {
          _notes = notes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _notes = []; // إرجاع قائمة فارغة في حالة الخطأ
        });
        // لا نعرض رسالة خطأ حمراء، فقط نتجاهل الخطأ
        print('Erreur lors du chargement des notes: $e');
      }
    }
  }

  Future<void> _deleteAllNotes() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
            'هل أنت متأكد من حذف جميع الملاحظات؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف الكل'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await NoteService.deleteAllNotes();
        await _loadNotes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف جميع الملاحظات بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          // لا نعرض رسالة خطأ حمراء، فقط نتجاهل الخطأ
          print('Erreur lors de la suppression des notes: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'إدارة الملاحظات',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              onPressed: _deleteAllNotes,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'حذف جميع الملاحظات',
            ),
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? _buildEmptyState()
              : _buildNotesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 80,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 77),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ملاحظات محفوظة',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 179),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإضافة ملاحظات أثناء حل الأسئلة',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 128),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return RefreshIndicator(
      onRefresh: _loadNotes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.note,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(
                note.noteId,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 204),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'آخر تحديث: ${_formatDate(note.updatedAt)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 153),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => _showNoteDetails(note),
                icon: const Icon(Icons.visibility),
                tooltip: 'عرض التفاصيل',
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNoteDetails(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ملاحظة: ${note.noteId}',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.content,
                style: GoogleFonts.montserrat(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                'تاريخ الإنشاء: ${_formatDate(note.createdAt)}',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'آخر تحديث: ${_formatDate(note.updatedAt)}',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
