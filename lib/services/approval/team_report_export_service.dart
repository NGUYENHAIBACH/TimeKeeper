import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_report_export_service.g.dart';

/// Tạo file báo cáo Team Dashboard, tách biệt khỏi Repository dữ liệu.
class TeamReportExportService {
  const TeamReportExportService();

  /// Xuất [rows] thành PDF khi [pdf] là true, ngược lại xuất Excel.
  Future<String> export(List<Map<String, dynamic>> rows, bool pdf) async {
    final directory = await getApplicationDocumentsDirectory();
    final extension = pdf ? 'pdf' : 'xlsx';
    final file = File(
      '${directory.path}/team-${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    final data = rows
        .map(
          (row) => [
            '${row['employee_id']}',
            row['kind'] == 'Đi muộn' ? 'Late' : 'Leave',
            '${row['late_minutes'] ?? ''}',
          ],
        )
        .toList();

    if (pdf) {
      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          build: (_) => [
            pw.Text('TimeKeeper - Team report'),
            pw.TableHelper.fromTextArray(
              headers: ['Employee ID', 'Status', 'Late minutes'],
              data: data,
            ),
          ],
        ),
      );
      await file.writeAsBytes(await document.save());
    } else {
      final book = Excel.createExcel();
      final sheet = book['Team'];
      for (final row in [
        ['Employee ID', 'Status', 'Late minutes'],
        ...data,
      ]) {
        sheet.appendRow(row.map(TextCellValue.new).toList());
      }
      book.delete('Sheet1');
      await file.writeAsBytes(book.encode()!);
    }
    return file.path;
  }
}

@Riverpod(keepAlive: true)
TeamReportExportService teamReportExportService(Ref ref) =>
    const TeamReportExportService();
