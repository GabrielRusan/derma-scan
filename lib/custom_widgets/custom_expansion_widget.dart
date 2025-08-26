import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/constant/diseases_data.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/models/diagnose_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomExpansionWidget extends StatefulWidget {
  final List<AllPrediction> allPredictions;
  const CustomExpansionWidget({super.key, required this.allPredictions});

  @override
  State<CustomExpansionWidget> createState() => _CustomExpansionWidgetState();
}

class _CustomExpansionWidgetState extends State<CustomExpansionWidget> {
  bool isOnlyOne =
      false; // flag kalo misal hanya cuman satu confidence score yang di atas 5 persen
  @override
  void initState() {
    int count = 0;
    for (var e in widget.allPredictions) {
      final confidence = e.confidence;
      if (confidence <= 0.05) count++;
    }
    if (count > 1) {
      isOnlyOne = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.allPredictions.asMap().entries.map((entry) {
          int index = entry.key;
          bool initialyExpand = index == 0;
          final prediction = entry.value;
          final predictedClass = prediction.predictedClass;
          final confidence = prediction.confidence;

          if (confidence < 0.05) return SizedBox();

          final diseaseInformation = diseaseData[predictedClass.toLowerCase()];
          final diseaseDescription = diseaseInformation?['description'];
          List<String> diseaseCause = diseaseInformation?['cause'];
          List<String> diseasePrevention = diseaseInformation?['prevention'];
          List<String> diseaseTreatment = diseaseInformation?['treatment'];
          String urgency = diseaseInformation?['urgency'];

          return Container(
            margin: EdgeInsets.only(bottom: 16, left: 2, right: 2),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: ExpansionTileTheme(
              data: ExpansionTileThemeData(
                shape: Border(), // hilangkan border saat collapsed
                collapsedShape: Border(), // hilangkan border saat collapsed
              ),
              child: ExpansionTile(
                initiallyExpanded: initialyExpand,
                enabled: index != 0 ? true : !isOnlyOne,
                leading: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color(0xffBAD6FC),
                  ),
                  child: Center(
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: PoppinsText.headlineSmall(
                    prediction.predictedClass,
                    textAlign: TextAlign.center,
                    // fontWeight: FontWeight.w600,
                  ),
                ),

                children: <Widget>[
                  SizedBox(height: 16),
                  DiseaseDecriptionAndIndicator(
                    diseaseDescription: diseaseDescription,
                    confidence: confidence,
                  ),

                  SizedBox(height: 6),
                  Divider(color: Color(0xffE6E9EF)),
                  SizedBox(height: 6),
                  DiseaseUrgencyWidget(urgency: urgency),
                  SizedBox(height: 6),
                  Divider(color: Color(0xffE6E9EF)),
                  SizedBox(height: 6),
                  DiseaseInformationList(
                    header: 'Penyebab',
                    dataList: diseaseCause,
                    icon: Icon(Icons.check, color: Colors.black, size: 18),
                  ),
                  SizedBox(height: 6),
                  Divider(color: Color(0xffE6E9EF)),
                  SizedBox(height: 6),
                  DiseaseInformationList(
                    header: 'Pencegahan',
                    dataList: diseasePrevention,
                    icon: Icon(
                      Icons.verified_user,
                      color: Colors.teal,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Divider(color: Color(0xffE6E9EF)),
                  SizedBox(height: 6),
                  DiseaseInformationList(
                    header: 'Pengobatan',
                    dataList: diseaseTreatment,
                    icon: Icon(
                      FlutterRemix.capsule_fill,
                      color: Colors.teal,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class DiseaseUrgencyWidget extends StatelessWidget {
  const DiseaseUrgencyWidget({super.key, required this.urgency});

  final String urgency;

  @override
  Widget build(BuildContext context) {
    String kataKata =
        urgency == 'high'
            ? 'Harus segera diperiksakan ke dokter. Kondisi beresiko tinggi.'
            : urgency == 'medium'
            ? 'Perlu konsultasi dokter, tidak darurat namun sebaiknya segera ditangani.'
            : 'Ringan/observasi. Lakukan perawatan mandiri, periksa bila memburuk.';
    Color warnaUrgency =
        urgency == 'high'
            ? Colors.red
            : urgency == 'medium'
            ? Colors.yellow
            : Colors.green;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PoppinsText.headlineSmall('Urgensi'),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: warnaUrgency,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(child: PoppinsText.bodyMedium(kataKata)),
            ],
          ),
        ],
      ),
    );
  }
}

class DiseaseInformationList extends StatelessWidget {
  const DiseaseInformationList({
    super.key,
    required this.header,
    required this.dataList,
    this.icon,
  });

  final List<String> dataList;
  final String header;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PoppinsText.headlineSmall(header, textAlign: TextAlign.left),
            SizedBox(height: 8),
            ...dataList.asMap().entries.map((entry) {
              int index = entry.key;
              String data = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index + 1 == dataList.length ? 0 : 8.0,
                ),
                child: Row(
                  children: [
                    icon ??
                        Icon(
                          Icons.verified_user,
                          color: Colors.green,
                          // size: 20,
                        ),
                    SizedBox(width: 8),
                    Expanded(child: PoppinsText.bodyMedium(data)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DiseaseDecriptionAndIndicator extends StatelessWidget {
  const DiseaseDecriptionAndIndicator({
    super.key,
    required this.diseaseDescription,
    required this.confidence,
  });

  final dynamic diseaseDescription;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //   child: Column(
    //     children: [],
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PoppinsText.bodyMedium(
              '$diseaseDescription',
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(width: 32),
          Column(
            children: [
              // SizedBox(height: 8),
              PoppinsText(
                'Skor Keyakinan',
                size: 11,
                // fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 12),
              CircularPercentIndicator(
                radius: 38.0,
                lineWidth: 12.0,
                percent: confidence,
                center: PoppinsText(
                  "${(confidence * 100).toStringAsFixed(0)}%",
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  size: 16,
                ),
                progressColor: primary,
                backgroundColor: Colors.grey.shade300,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
