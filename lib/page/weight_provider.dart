import 'package:flutter/foundation.dart';
import 'weight_model.dart';

class WeightProvider with ChangeNotifier {
  List<WeightRecord> _weights = [];
  bool _isLoading = false;
  String? _error;

  List<WeightRecord> get weights => _weights;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  double get averageWeight => _weights.isEmpty ? 0 : 
      _weights.map((w) => w.weight).reduce((a, b) => a + b) / _weights.length;
  
  double get minWeight => _weights.isEmpty ? 0 : 
      _weights.map((w) => w.weight).reduce((a, b) => a < b ? a : b);
  
  double get maxWeight => _weights.isEmpty ? 0 : 
      _weights.map((w) => w.weight).reduce((a, b) => a > b ? a : b);
  
  double get weightVariation => maxWeight - minWeight;

  Future<void> loadWeights() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // CONTOH DATA DUMMY - GANTI DENGAN DATA ASLI ANDA
      await Future.delayed(Duration(seconds: 1)); // Simulasi loading
      
      _weights = [
        WeightRecord(date: DateTime.now().subtract(Duration(days: 8)), weight: 65),
        WeightRecord(date: DateTime.now().subtract(Duration(days: 6)), weight: 60),
        WeightRecord(date: DateTime.now().subtract(Duration(days: 4)), weight: 63),
        WeightRecord(date: DateTime.now().subtract(Duration(days: 1)), weight: 58),
        WeightRecord(date: DateTime.now(), weight: 59),
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal memuat data: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Contoh untuk Firestore
  /*
  Future<void> loadWeightsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weights')
          .orderBy('date')
          .get();
      
      _weights = snapshot.docs.map((doc) => WeightRecord.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
  */
}