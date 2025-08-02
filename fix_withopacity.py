#!/usr/bin/env python3
"""
سكريبت لإصلاح مشاكل withOpacity في ملفات Dart
يستبدل withOpacity بـ withValues(alpha: ...)
"""

import os
import re
import glob

def fix_withopacity_in_file(file_path):
    """إصلاح مشاكل withOpacity في ملف واحد"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # استبدال withOpacity بـ withValues
        pattern = r'\.withOpacity\(([^)]+)\)'
        replacement = r'.withValues(alpha: \1)'
        
        new_content = re.sub(pattern, replacement, content)
        
        if new_content != content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"✅ تم إصلاح {file_path}")
            return True
        return False
    except Exception as e:
        print(f"❌ خطأ في {file_path}: {e}")
        return False

def main():
    """الدالة الرئيسية"""
    print("🔧 بدء إصلاح مشاكل withOpacity...")
    
    # البحث عن جميع ملفات Dart
    dart_files = glob.glob("lib/**/*.dart", recursive=True)
    dart_files.extend(glob.glob("test/**/*.dart", recursive=True))
    
    fixed_count = 0
    total_files = len(dart_files)
    
    for file_path in dart_files:
        if fix_withopacity_in_file(file_path):
            fixed_count += 1
    
    print(f"\n📊 النتائج:")
    print(f"   - إجمالي الملفات: {total_files}")
    print(f"   - الملفات المصلحة: {fixed_count}")
    print(f"   - الملفات التي لم تحتاج إصلاح: {total_files - fixed_count}")
    
    if fixed_count > 0:
        print("\n✅ تم إصلاح جميع مشاكل withOpacity بنجاح!")
    else:
        print("\nℹ️ لم يتم العثور على مشاكل withOpacity")

if __name__ == "__main__":
    main() 