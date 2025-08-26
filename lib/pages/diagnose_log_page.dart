import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
// ignore: unused_import
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/custom_widgets/diagnose_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiagnoseLogPage extends StatelessWidget {
  const DiagnoseLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 150,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/logo.png'),
                      ),
                      SizedBox(width: 12),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Riwayat Screening',
                              style: GoogleFonts.eduNswActFoundation(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showFilterDialog(context);
                              },
                              icon: Icon(Icons.filter_list, size: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Consumer<DiagnoseLogProvider>(
                    builder: (context, logProvider, _) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Ketik keyword...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: logProvider.setSearchQuery,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<DiagnoseLogProvider>(
          builder: (context, logProvider, _) {
            if (logProvider.isLoading) {
              return SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: 75,
                toolbarHeight: 75,
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (logProvider.allDiagnoseResult.isEmpty &&
                logProvider.filteredResults.isEmpty) {
              return SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: 75,
                toolbarHeight: 75,
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Text(
                      "Belum ada hasil diagnosa",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }

            if (logProvider.filteredResults.isEmpty) {
              return SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: 75,
                toolbarHeight: 75,
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Text(
                      "Riwayat tidak ditemukan.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: logProvider.filteredResults.length,
                (context, index) {
                  final item = logProvider.filteredResults[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DiagnoseContainer(diagnoseResult: item),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

void _showFilterDialog(BuildContext context) {
  DateTimeRange? selectedRange;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 24,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Provider.of<DiagnoseLogProvider>(
                        context,
                        listen: false,
                      ).resetFilters();
                      setState(() {
                        selectedRange = null;
                      });
                    },
                    child: Text(
                      "Reset",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.date_range),
                  label: Text(
                    selectedRange == null
                        ? "Pilih Rentang Tanggal"
                        : "${DateFormat('dd MMM yyyy').format(selectedRange!.start)} - ${DateFormat('dd MMM yyyy').format(selectedRange!.end)}",
                  ),
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange:
                          selectedRange ??
                          DateTimeRange(
                            start: DateTime.now().subtract(Duration(days: 7)),
                            end: DateTime.now(),
                          ),
                    );
                    if (range != null) {
                      setState(() {
                        selectedRange = range;
                      });
                    }
                  },
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<DiagnoseLogProvider>(
                    context,
                    listen: false,
                  ).setDateRange(selectedRange);
                  Navigator.pop(context);
                },
                child: Text("Terapkan"),
              ),
            ],
          );
        },
      );
    },
  );
}
