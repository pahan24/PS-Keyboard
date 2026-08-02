import '../services/native_input_service.dart';
import '../services/storage_service.dart';
import '../services/encryption_service.dart';

class ClipboardService {
  static Future<String?> checkSystemClipboardForPSK() async {
    final clipText = await NativeInputService.getClipboardText();
    if (clipText.isNotEmpty) {
      // Save clip into history
      await StorageService.addClipboardClip(clipText);
      if (EncryptionService.isEncryptedFormat(clipText)) {
        return clipText;
      }
    }
    return null;
  }
}
