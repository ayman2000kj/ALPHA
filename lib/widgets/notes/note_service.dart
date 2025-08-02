import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

class NoteService {
  static const String _notesKey = 'user_notes';

  // حفظ ملاحظة جديدة أو تحديثها
  static Future<void> saveNote(Note note) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList(_notesKey) ?? [];

      // البحث عن الملاحظة الموجودة
      final existingIndex = notesJson.indexWhere((json) {
        try {
          final existingNote = Note.fromJson(jsonDecode(json));
          return existingNote.noteId == note.noteId;
        } catch (e) {
          return false;
        }
      });

      if (existingIndex != -1) {
        // تحديث الملاحظة الموجودة
        notesJson[existingIndex] = jsonEncode(note.toJson());
      } else {
        // إضافة ملاحظة جديدة
        notesJson.add(jsonEncode(note.toJson()));
      }

      await prefs.setStringList(_notesKey, notesJson);
    } catch (e) {
      // تجاهل الأخطاء في حفظ الملاحظات لتجنب تعطيل التطبيق
      print('Erreur lors de la sauvegarde de la note: $e');
    }
  }

  // تحميل ملاحظة لسؤال معين
  static Future<Note?> getNoteForQuestion(String noteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList(_notesKey) ?? [];

      for (final json in notesJson) {
        try {
          final note = Note.fromJson(jsonDecode(json));
          if (note.noteId == noteId) {
            return note;
          }
        } catch (e) {
          // تجاهل الملاحظات التالفة
          continue;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // تحميل جميع الملاحظات
  static Future<List<Note>> getAllNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList(_notesKey) ?? [];

      return notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      // في حالة حدوث خطأ، إرجاع قائمة فارغة بدلاً من رمي استثناء
      return [];
    }
  }

  // حذف ملاحظة
  static Future<void> deleteNote(String noteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList(_notesKey) ?? [];

      final filteredNotes = notesJson.where((json) {
        try {
          final note = Note.fromJson(jsonDecode(json));
          return note.noteId != noteId;
        } catch (e) {
          return true; // احتفظ بالملاحظات التالفة
        }
      }).toList();

      await prefs.setStringList(_notesKey, filteredNotes);
    } catch (e) {
      print('Erreur lors de la suppression de la note: $e');
    }
  }

  // حذف جميع الملاحظات
  static Future<void> deleteAllNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notesKey);
    } catch (e) {
      print('Erreur lors de la suppression de toutes les notes: $e');
    }
  }
}
