class Note {
  final String id;
  final String noteId; // كان questionId
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({required this.id, required this.noteId, required this.content, required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noteId': noteId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      noteId: json['questionId'] ?? json['noteId'], // دعم التوافقية القديمة
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Note copyWith({
    String? id,
    String? noteId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 
