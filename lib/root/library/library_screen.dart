import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class LibraryScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const LibraryScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'التشريح',
    'البيو كيمياء',
    'السيتولوجيا',
    'علم وظائف الأعضاء',
    'علم الأمراض',
    'علم الأدوية',
    'الطب السريري',
  ];

  final List<BookItem> _books = [
    BookItem(
      title: 'أطلس التشريح البشري',
      author: 'د. أحمد محمد',
      category: 'التشريح',
      description: 'أطلس شامل للتشريح البشري مع صور مفصلة',
      rating: 4.8,
      pages: 450,
      isAvailable: true,
      coverColor: Colors.blue,
    ),
    BookItem(
      title: 'مبادئ البيو كيمياء الطبية',
      author: 'د. فاطمة علي',
      category: 'البيو كيمياء',
      description: 'كتاب شامل في مبادئ البيو كيمياء للطلاب',
      rating: 4.6,
      pages: 320,
      isAvailable: true,
      coverColor: Colors.green,
    ),
    BookItem(
      title: 'علم الخلايا الطبية',
      author: 'د. محمد حسن',
      category: 'السيتولوجيا',
      description: 'دراسة شاملة لخلايا الجسم البشري',
      rating: 4.5,
      pages: 280,
      isAvailable: false,
      coverColor: Colors.orange,
    ),
    BookItem(
      title: 'علم وظائف الأعضاء البشرية',
      author: 'د. سارة أحمد',
      category: 'علم وظائف الأعضاء',
      description: 'كتاب شامل في علم وظائف الأعضاء',
      rating: 4.7,
      pages: 380,
      isAvailable: true,
      coverColor: Colors.purple,
    ),
    BookItem(
      title: 'أساسيات علم الأمراض',
      author: 'د. علي محمود',
      category: 'علم الأمراض',
      description: 'مقدمة في علم الأمراض للطلاب',
      rating: 4.4,
      pages: 290,
      isAvailable: true,
      coverColor: Colors.red,
    ),
    BookItem(
      title: 'علم الأدوية الأساسي',
      author: 'د. نادية كريم',
      category: 'علم الأدوية',
      description: 'أساسيات علم الأدوية والعلاج',
      rating: 4.3,
      pages: 350,
      isAvailable: false,
      coverColor: Colors.teal,
    ),
    BookItem(
      title: 'الفحص السريري',
      author: 'د. كريم سعد',
      category: 'الطب السريري',
      description: 'دليل شامل للفحص السريري',
      rating: 4.9,
      pages: 420,
      isAvailable: true,
      coverColor: Colors.indigo,
    ),
  ];

  List<BookItem> get _filteredBooks {
    return _books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'الكل' || book.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBookDetails(BookItem book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: book.coverColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.book,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    book.author,
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.description,
              style: GoogleFonts.montserrat(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${book.rating}',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Icon(Icons.pages, color: Colors.grey, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${book.pages} صفحة',
                  style: GoogleFonts.montserrat(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: book.category == 'التشريح' ? Colors.blue.withAlpha(77)
                    : book.category == 'البيو كيمياء' ? Colors.green.withAlpha(77)
                    : Colors.orange.withAlpha(77),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                book.category,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إغلاق',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: book.isAvailable ? () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم فتح الكتاب: ${book.title}',
                    style: GoogleFonts.montserrat(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } : null,
            child: Text(
              book.isAvailable ? 'قراءة' : 'غير متاح',
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Text(
          'المكتبة الرقمية',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.white.withAlpha(26), Colors.white.withAlpha(13)]
                    : [Colors.white.withAlpha(230), Colors.white.withAlpha(153)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(77)
                      : Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن كتاب أو مؤلف...',
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
                hintStyle: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
              ),
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          
          // فئات الكتب
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: GoogleFonts.montserrat(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: isDark
                        ? Colors.white.withAlpha(26)
                        : Colors.white.withAlpha(153),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // قائمة الكتب
          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد نتائج',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'جرب البحث بكلمات مختلفة',
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [Colors.white.withAlpha(26), Colors.white.withAlpha(13)]
                                : [Colors.white.withAlpha(230), Colors.white.withAlpha(153)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withAlpha(77)
                                  : Colors.black.withAlpha(26),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              color: book.coverColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.book,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            book.title,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.author,
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${book.rating}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: book.isAvailable
                                          ? Colors.green.withAlpha(77)
                                          : Colors.red.withAlpha(77),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      book.isAvailable ? 'متاح' : 'غير متاح',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        color: book.isAvailable ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                            size: 16,
                          ),
                          onTap: () => _showBookDetails(book),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BookItem {
  final String title;
  final String author;
  final String category;
  final String description;
  final double rating;
  final int pages;
  final bool isAvailable;
  final Color coverColor;

  BookItem({
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.rating,
    required this.pages,
    required this.isAvailable,
    required this.coverColor,
  });
} 
