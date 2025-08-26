import 'package:uuid/uuid.dart';

var uuid = Uuid();

String generateUuid() {
  return uuid
      .v4(); // Ini akan hasilkan ID unik seperti: "c1b2f5a1-73b4-4f1b-909b-aac2fdd89c87"
}
