import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Flirtifier {
  // boilerplate src: https://pub.dev/packages/google_generative_ai

  late final GenerativeModel model;
  final String instructions =
      "transform this message such that it has a flirting tone. don't include any AI commentary; just return the converted message.";

  Flirtifier._privateConstructor() {
    String apiKey = dotenv.env['GEMINI_API'] ?? "";

    assert(apiKey.isNotEmpty);

    model = GenerativeModel(
      model: "gemini-1.5-flash-latest",
      apiKey: apiKey,
    );
  }

  Future<String> addFlirt(String message) async {
    String prompt = '$instructions\n"""\n$message\n"""';
    var response = await model.generateContent([Content.text(prompt)]);

    assert(response.text != null);
    String responseText = response.text as String;

    return responseText;
  }

  static final Flirtifier _instance = Flirtifier._privateConstructor();

  factory Flirtifier() {
    return _instance;
  }
}
