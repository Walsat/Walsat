import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;
import '../models/document.dart';

/// خدمة الطباعة المباشرة
/// Direct Printing Service
class PrintService {
  static final PrintService _instance = PrintService._internal();
  factory PrintService() => _instance;
  PrintService._internal();

  /// طباعة وثيقة
  /// Print a document
  Future<bool> printDocument(Document document) async {
    try {
      final pdf = await _generatePrintablePDF(document);
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'وثيقة_${document.title}.pdf',
        format: PdfPageFormat.a4,
      );
      
      return true;
    } catch (e) {
      print('❌ خطأ في طباعة الوثيقة: $e');
      return false;
    }
  }

  /// طباعة قائمة وثائق
  /// Print multiple documents
  Future<bool> printDocumentList(List<Document> documents) async {
    try {
      final pdf = await _generateListPDF(documents);
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'قائمة_الوثائق_${DateTime.now().millisecondsSinceEpoch}.pdf',
        format: PdfPageFormat.a4,
      );
      
      return true;
    } catch (e) {
      print('❌ خطأ في طباعة قائمة الوثائق: $e');
      return false;
    }
  }

  /// معاينة الطباعة
  /// Print preview
  Future<void> showPrintPreview(Document document) async {
    try {
      final pdf = await _generatePrintablePDF(document);
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'معاينة_${document.title}.pdf',
        format: PdfPageFormat.a4,
      );
    } catch (e) {
      print('❌ خطأ في معاينة الطباعة: $e');
      rethrow;
    }
  }

  /// مشاركة PDF
  /// Share PDF
  Future<bool> sharePDF(Document document) async {
    try {
      final pdf = await _generatePrintablePDF(document);
      
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'وثيقة_${document.title}.pdf',
      );
      
      return true;
    } catch (e) {
      print('❌ خطأ في مشاركة PDF: $e');
      return false;
    }
  }

  /// إنشاء PDF للطباعة
  Future<pw.Document> _generatePrintablePDF(Document document) async {
    final pdf = pw.Document();
    
    // تحميل الخط العربي
    final arabicFont = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(arabicFont);
    
    final arabicBoldFont = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttfBold = pw.Font.ttf(arabicBoldFont);

    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // العنوان
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'وثيقة رسمية',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        font: ttfBold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      document.title,
                      style: pw.TextStyle(
                        fontSize: 18,
                        color: PdfColors.white,
                        font: ttf,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),
              
              // معلومات الوثيقة
              _buildInfoRow('النوع:', document.type, ttf, ttfBold),
              _buildInfoRow('الحالة:', document.status, ttf, ttfBold),
              _buildInfoRow('المالك:', document.ownerName ?? '', ttf, ttfBold),
              _buildInfoRow('الموقع:', document.location ?? '', ttf, ttfBold),
              _buildInfoRow('المساحة:', document.area?.toString() ?? '', ttf, ttfBold),
              _buildInfoRow(
                'التاريخ:',
                intl.DateFormat('yyyy/MM/dd').format(document.createdAt),
                ttf,
                ttfBold,
              ),
              
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              
              // الوصف
              if (document.description.isNotEmpty) ...[
                pw.Text(
                  'الوصف:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: ttfBold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Text(
                    document.description,
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: ttf,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
              
              // الوسوم
              if (document.tags.isNotEmpty) ...[
                pw.Text(
                  'الوسوم:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: ttfBold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: document.tags.map((tag) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.teal100,
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                      ),
                      child: pw.Text(
                        tag,
                        style: pw.TextStyle(
                          fontSize: 12,
                          font: ttf,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              
              pw.Spacer(),
              
              // التذييل
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'تم الطباعة بواسطة: نظام أرشيف الوثائق',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    'التاريخ: ${intl.DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                      font: ttf,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // إضافة صور الوثيقة إن وجدت
    if (document.imagePaths.isNotEmpty) {
      for (final imagePath in document.imagePaths) {
        try {
          final file = File(imagePath);
          if (await file.exists()) {
            final imageBytes = await file.readAsBytes();
            final image = pw.MemoryImage(imageBytes);
            
            pdf.addPage(
              pw.Page(
                textDirection: pw.TextDirection.rtl,
                pageFormat: PdfPageFormat.a4,
                theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
                build: (pw.Context context) {
                  return pw.Column(
                    children: [
                      pw.Text(
                        'صورة الوثيقة',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          font: ttfBold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Expanded(
                        child: pw.Image(image, fit: pw.BoxFit.contain),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        } catch (e) {
          print('⚠️ تعذر تحميل الصورة: $imagePath');
        }
      }
    }

    return pdf;
  }

  /// إنشاء PDF لقائمة الوثائق
  Future<pw.Document> _generateListPDF(List<Document> documents) async {
    final pdf = pw.Document();
    
    final arabicFont = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(arabicFont);
    
    final arabicBoldFont = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttfBold = pw.Font.ttf(arabicBoldFont);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        build: (pw.Context context) {
          return [
            // العنوان
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'قائمة الوثائق',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      font: ttfBold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'إجمالي الوثائق: ${documents.length}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.white,
                      font: ttf,
                    ),
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // جدول الوثائق
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttfBold,
                fontSize: 12,
              ),
              cellStyle: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.teal100,
              ),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
              headers: ['#', 'العنوان', 'النوع', 'الحالة', 'التاريخ'],
              data: documents.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final doc = entry.value;
                return [
                  index.toString(),
                  doc.title,
                  doc.type,
                  doc.status,
                  intl.DateFormat('yyyy/MM/dd').format(doc.createdAt),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  /// بناء صف معلومات
  pw.Widget _buildInfoRow(
    String label,
    String value,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                font: boldFont,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                font: regularFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// التحقق من توفر الطابعات
  /// Check if printers are available
  Future<bool> isPrinterAvailable() async {
    try {
      return await Printing.info() != null;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على معلومات الطابعات
  /// Get printer info
  Future<PrintingInfo?> getPrinterInfo() async {
    try {
      return await Printing.info();
    } catch (e) {
      print('❌ خطأ في الحصول على معلومات الطابعات: $e');
      return null;
    }
  }
}
