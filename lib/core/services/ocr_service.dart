import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class OCRService {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  // Take photo using camera and process odometer reading
  Future<String?> scanOdometerFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return null;
      return await _processImage(image.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Pick image from gallery and process
  Future<String?> scanOdometerFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return null;
      return await _processImage(image.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<String?> _processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      String rawText = recognizedText.text;
      
      // Basic extraction: find sequences of digits that look like a reasonable odometer
      // Remove spaces, dots, and commas to parse just numbers
      String cleanedText = rawText.replaceAll(RegExp(r'[\s.,]'), '');
      
      // Match 3 to 7 digit numbers (e.g. 100 to 9999999 km)
      RegExp regExp = RegExp(r'\b\d{3,7}\b');
      Iterable<RegExpMatch> matches = regExp.allMatches(cleanedText);

      // We'll trust the longest match or the first one if it makes sense, or just return all text as fallback
      if (matches.isNotEmpty) {
        // Find longest number sequence
        String bestMatch = '';
        for (final match in matches) {
          final s = match.group(0) ?? '';
          if (s.length > bestMatch.length) {
            bestMatch = s;
          }
        }
        if (bestMatch.isNotEmpty) {
          return bestMatch;
        }
      }

      // Fallback: extract any digits
      String finalDigits = cleanedText.replaceAll(RegExp(r'\D'), '');
      if (finalDigits.isNotEmpty) return finalDigits;

      return rawText.isEmpty ? null : rawText;
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
