import 'dart:convert';

import 'package:chatbot/data/message.dart';
import 'package:http/http.dart' as http;
 

class TextToImage {
  Future<Message> fetchImage({required String text}) async {
   const apiUrl =
        "https://api-inference.huggingface.co/models/ZB-Tech/Text-to-Image";
    const headers = {
      "Authorization": "Bearer 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",
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode({"inputs": "$text"}),
    );

    if (response.statusCode == 200) {
      final imageBytes = response.bodyBytes;
      final image = base64Encode(imageBytes);
      print(imageBytes);
      return Message(text: image, isYour: false);
    } else {
      return Message(text: "Failed to load image", isYour: true);
    }
  }
}
