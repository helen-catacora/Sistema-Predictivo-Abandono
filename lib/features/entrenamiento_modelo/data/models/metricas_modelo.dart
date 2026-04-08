/// Métricas de evaluación de un modelo ML.
class MetricasModelo {
  final double accuracy;
  final double precision;
  final double recall;
  final double f1Score;
  final double rocAuc;
  final List<List<int>>? confusionMatrix;

  const MetricasModelo({
    required this.accuracy,
    required this.precision,
    required this.recall,
    required this.f1Score,
    required this.rocAuc,
    this.confusionMatrix,
  });

  factory MetricasModelo.fromJson(Map<String, dynamic> json) {
    return MetricasModelo(
      accuracy: (json['accuracy'] as num).toDouble(),
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      f1Score: (json['f1_score'] as num).toDouble(),
      rocAuc: (json['roc_auc'] as num).toDouble(),
      confusionMatrix: json['confusion_matrix'] != null
          ? (json['confusion_matrix'] as List)
              .map((row) => (row as List).map((e) => (e as num).toInt()).toList())
              .toList()
          : null,
    );
  }
}
