import 'dart:io';

import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/constant/datetime_function.dart';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/controllers/navigation_provider.dart';
import 'package:derma_scan/custom_widgets/custom_expansion_widget.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/models/diagnose_result_model.dart';
import 'package:derma_scan/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailDiagnosePage extends StatelessWidget {
  final DiagnoseResultModel result;

  const DetailDiagnosePage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    List<String> dummyData = ['acne', 'psoriasis', 'eczema'];

    File image = File(result.imagePath);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.grey.shade300,
              width: double.infinity,
              height: screenHeight * 0.75,
              child: Image.file(
                image,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 120,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 56),
              child: DraggableScrollableSheet(
                minChildSize: 0.25,

                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: PoppinsText.headlineMedium(
                              'Hasil Screening',
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: PoppinsText(
                              customDateTimeFormatter(result.timeStamp),
                              textAlign: TextAlign.right,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6F7D95),
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(color: Color(0xffE6E9EF)),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: CustomExpansionWidget(
                              allPredictions:
                                  result.allPredictions.take(3).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              right: -4,
              top: 4,
              child: PopupMenuButton(
                iconColor: Colors.white,
                onSelected: (value) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Konfirmasi',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: PoppinsText(
                            'Apakah kamu yakin ingin menghapus?',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: PoppinsText(
                                'Tidak',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<DiagnoseLogProvider>(
                                  context,
                                  listen: false,
                                ).deleteLog(result.id);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );

                                Provider.of<NavigationProvider>(
                                  context,
                                  listen: false,
                                ).setIndex(0);
                              },
                              child: PoppinsText(
                                'Ya',
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                  );
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Hapus',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
