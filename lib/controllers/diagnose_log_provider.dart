import 'package:derma_scan/constant/datetime_function.dart';
import 'package:derma_scan/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:derma_scan/models/diagnose_result_model.dart';

class DiagnoseLogProvider extends ChangeNotifier {
  final List<DiagnoseResultModel> _dummy = List.generate(
    10,
    (index) => DiagnoseResultModel(
      id: '',
      imagePath: 'imagePath',
      predictedClass: 'predictedClasasdfasdfasdfasdfasdfs',
      confidence: 1,
      top3ConfidenceSum: 0.6,
      timeStamp: DateTime.now(),
      allPredictions: [],
    ),
  );

  List<DiagnoseResultModel> _allDiagnoseResults = [];
  List<DiagnoseResultModel> get allDiagnoseResult => _allDiagnoseResults;

  List<DiagnoseResultModel> _filteredResults = [];
  List<DiagnoseResultModel> get filteredResults => _filteredResults;

  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  /// Memuat data dari database
  Future<void> fetchLogs([bool isUseDummy = false]) async {
    if (isUseDummy) {
      _allDiagnoseResults = List.from(_dummy);
      applyFilters();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rows = await DatabaseHelper.getAllPredictions();

      _allDiagnoseResults =
          rows.map((row) {
            return DiagnoseResultModel.fromJson(row);
          }).toList();

      applyFilters();
    } catch (e) {
      print('Error loading logs: $e');
      _allDiagnoseResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Untuk refresh manual (misal saat user swipe refresh)
  Future<void> refresh() async {
    await fetchLogs();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    applyFilters();
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _startDate = range?.start;
    _endDate = range?.end;
    applyFilters();
    notifyListeners();
  }

  void applyFilters() {
    _filteredResults =
        _allDiagnoseResults.where((log) {
          final matchSearch =
              log.predictedClass.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              customDateTimeFormatter(
                log.timeStamp,
              ).toLowerCase().contains(_searchQuery.toLowerCase());

          final matchDateRange =
              (_startDate == null ||
                  log.timeStamp.isAfter(
                    _startDate!.subtract(Duration(days: 1)),
                  )) &&
              (_endDate == null ||
                  log.timeStamp.isBefore(_endDate!.add(Duration(days: 1))));

          return matchSearch && matchDateRange;
        }).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void resetFilters() {
    _startDate = null;
    _endDate = null;
    applyFilters();
    notifyListeners();
  }

  /// Untuk menambahkan log baru secara manual (jika ingin append tanpa fetch ulang)
  // void addLog(DiagnoseResultModel result) {
  //   _allDiagnoseResults.insert(0, result); // masukkan ke atas
  //   notifyListeners();
  // }

  /// Untuk hapus log tertentu
  Future<void> deleteLog(String id) async {
    await DatabaseHelper.deletePrediction(id);
    await fetchLogs();
  }
}
