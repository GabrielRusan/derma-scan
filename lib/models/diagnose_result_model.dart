import 'dart:convert';

DiagnoseResultModel diagnoseResultModelFromJson(String str) {
  final jsonData = json.decode(str);

  return DiagnoseResultModel.fromJson(jsonData);
}

String diagnoseResultModelToJson(DiagnoseResultModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class DiagnoseResultModel {
  final String id;
  final String imagePath;
  final String predictedClass;
  final double confidence;
  final double? top3ConfidenceSum;
  final DateTime timeStamp;
  final List<AllPrediction> allPredictions;

  DiagnoseResultModel({
    required this.id,
    required this.imagePath,
    required this.predictedClass,
    required this.confidence,
    required this.timeStamp,
    required this.allPredictions,
    required this.top3ConfidenceSum,
  });

  factory DiagnoseResultModel.fromJson(Map<String, dynamic> json) {
    // Pastikan format sesuai dengan struktur di database SQLite
    return DiagnoseResultModel(
      id: json["id"],
      imagePath: json["image_path"],
      predictedClass: json["predicted_class"],
      confidence: (json["confidence"] as num).toDouble(),
      timeStamp: DateTime.parse(json["created_at"]),
      allPredictions:
          (json["all_predictions"] is String)
              ? List<AllPrediction>.from(
                jsonDecode(
                  json["all_predictions"],
                ).map((x) => AllPrediction.fromJson(x)),
              )
              : [], // fallback if null or wrong format
      top3ConfidenceSum: json['top3_confidence_sum'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_path": imagePath,
    "predicted_class": predictedClass,
    "confidence": confidence,
    "top3_confidence_sum": top3ConfidenceSum,
    "created_at": timeStamp.toIso8601String(),
    "all_predictions": jsonEncode(
      allPredictions.map((x) => x.toJson()).toList(),
    ),
  };
}

class AllPrediction {
  final String predictedClass;
  final double confidence;

  AllPrediction({required this.predictedClass, required this.confidence});

  factory AllPrediction.fromJson(Map<String, dynamic> json) => AllPrediction(
    predictedClass: json["label"] ?? json["predicted_class"] ?? "",
    confidence: (json["confidence"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "predicted_class": predictedClass,
    "confidence": confidence,
  };
}
