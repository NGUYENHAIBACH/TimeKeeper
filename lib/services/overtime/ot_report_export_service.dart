import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timekeeper/viewmodels/overtime/ot_report_summary.dart';

enum OtReportExportFormat { pdf, excel }

class OtReportExportService {
  const OtReportExportService();

  Future<Uri?> export({
    required OtReportSummary summary,
    required double hourlyRate,
    required OtReportExportFormat format,
  }) async {
    final isPdf = format == OtReportExportFormat.pdf;
    final bytes = isPdf
        ? await _buildPdf(summary, hourlyRate)
        : _buildExcel(summary, hourlyRate);

    return FilePicker.saveFile(
      dialogTitle: isPdf ? 'Xuất báo cáo OT PDF' : 'Xuất báo cáo OT Excel',
      fileName: 'bao-cao-ot-${summary.year}.${isPdf ? 'pdf' : 'xlsx'}',
      bytes: bytes,
      mimeType: isPdf
          ? 'application/pdf'
          : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
  }

  Future<Uint8List> _buildPdf(
    OtReportSummary summary,
    double hourlyRate,
  ) async {
    final document = pw.Document();
    final estimatedPay = summary.estimatePay(hourlyRate);

    document.addPage(
      pw.MultiPage(
        build: (_) => [
          // The built-in PDF font only supports ASCII. Keep PDF labels ASCII
          // so exported files render consistently without a bundled font.
          pw.Header(level: 0, child: pw.Text('TimeKeeper - OT Report')),
          pw.Text('Year: ${summary.year}'),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headers: const ['Metric', 'Value'],
            data: [
              ['Approved requests', '${summary.approvedCount}'],
              ['Pending requests', '${summary.pendingCount}'],
              ['Actual OT hours', _number(summary.actualHours)],
              ['Converted hours', _number(summary.paidHours)],
              ['Hourly rate (VND)', _number(hourlyRate)],
              ['Estimated OT pay (VND)', _number(estimatedPay)],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Approved OT hours by month'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['Month', 'Hours'],
            data: [
              for (var month = 0; month < summary.monthlyHours.length; month++)
                ['${month + 1}', _number(summary.monthlyHours[month])],
            ],
          ),
        ],
      ),
    );

    return document.save();
  }

  Uint8List _buildExcel(OtReportSummary summary, double hourlyRate) {
    final workbook = Excel.createExcel();
    final sheet = workbook['Báo cáo OT'];

    void append(List<CellValue> cells) => sheet.appendRow(cells);

    append([TextCellValue('TimeKeeper - Báo cáo tăng ca')]);
    append([TextCellValue('Năm'), IntCellValue(summary.year)]);
    append([]);
    append([TextCellValue('Chỉ số'), TextCellValue('Giá trị')]);
    append([
      TextCellValue('Đơn đã duyệt'),
      IntCellValue(summary.approvedCount),
    ]);
    append([
      TextCellValue('Đơn chờ duyệt'),
      IntCellValue(summary.pendingCount),
    ]);
    append([
      TextCellValue('Giờ OT thực tế'),
      DoubleCellValue(summary.actualHours),
    ]);
    append([TextCellValue('Giờ quy đổi'), DoubleCellValue(summary.paidHours)]);
    append([
      TextCellValue('Lương theo giờ (VND)'),
      DoubleCellValue(hourlyRate),
    ]);
    append([
      TextCellValue('Tiền OT ước tính (VND)'),
      DoubleCellValue(summary.estimatePay(hourlyRate)),
    ]);
    append([]);
    append([TextCellValue('Tháng'), TextCellValue('Giờ OT đã duyệt')]);
    for (var month = 0; month < summary.monthlyHours.length; month++) {
      append([
        IntCellValue(month + 1),
        DoubleCellValue(summary.monthlyHours[month]),
      ]);
    }

    workbook.delete('Sheet1');
    final encoded = workbook.encode();
    if (encoded == null) {
      throw StateError('Không thể tạo tệp Excel');
    }
    return Uint8List.fromList(encoded);
  }
}

String _number(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2);
