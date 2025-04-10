import 'package:conciergego/models/chat_model.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';

/// Service exception
class OpenAIServiceException implements Exception {
  final String message;

  OpenAIServiceException(this.message);
}

/// OpenAI API service
class OpenAIService {
  static final OpenAIService _singleton = OpenAIService._internal();

  factory OpenAIService() {
    return _singleton;
  }

  OpenAIService._internal();

  /// Initialize and configure openai API
  void init(String apiKey) {
    OpenAI.apiKey = apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
    OpenAI.showLogs = true;
    OpenAI.showResponsesLogs = true;
    debugPrint("OpenAI service initialized");
  }

  Future<MessageModel> chatRequest({
    required List<MessageModel> messages,
    required String model,
    required double temperature,
    String? instructions,
  }) async {
    late MessageModel result;
    try {
      final List<OpenAIChatCompletionChoiceMessageModel> history =
          messages
              .map(
                (MessageModel message) =>
                    OpenAIChatCompletionChoiceMessageModel(
                      role:
                          message.role == "user"
                              ? OpenAIChatMessageRole.user
                              : OpenAIChatMessageRole.assistant,
                      content: [
                        OpenAIChatCompletionChoiceMessageContentItemModel.text(
                          message.content,
                        ),
                      ],
                    ),
              )
              .toList();

      late OpenAIChatCompletionModel response;

      if (instructions != null) {
        response = await OpenAI.instance.chat.create(
          model: model,
          temperature: temperature,
          messages:
              history +
              [
                OpenAIChatCompletionChoiceMessageModel(
                  content: [
                    OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      instructions,
                    ),
                  ],
                  role: OpenAIChatMessageRole.system,
                ),
              ],
        );
      } else {
        response = await OpenAI.instance.chat.create(
          model: model,
          temperature: temperature,
          messages: history,
        );
      }

      result = MessageModel(
        content: response.choices[0].message.content?.first.text ?? "",
        role: "assistant",
      );
    } on RequestFailedException catch (e) {
      throw OpenAIServiceException(e.message);
    }

    return result;
  }

  /// Send generation request to the openAI API
  Future<String> imageRequest({
    required String prompt,
    required String resolution,
    required String model,
  }) async {
    late OpenAIImageSize imageSize;

    switch (resolution) {
      case "256x256":
        imageSize = OpenAIImageSize.size256;
        break;
      case "512x512":
        imageSize = OpenAIImageSize.size512;
        break;
      case "1024x1024":
        imageSize = OpenAIImageSize.size1024;
        break;
      case "1792x1024":
        imageSize = OpenAIImageSize.size1792Horizontal;
        break;
      case "1024x1792":
        imageSize = OpenAIImageSize.size1792Vertical;
        break;
      default:
        throw OpenAIServiceException("Unsupported resolution: $resolution");
    }

    OpenAIImageModel image = await OpenAI.instance.image.create(
      model: model,
      prompt: prompt,
      n: 1,
      size: imageSize,
      responseFormat: OpenAIImageResponseFormat.b64Json,
    );

    return image.data[0].b64Json ?? "";
  }

  /// Edit request to openAI model
  Future<String> editRequest({
    required String text,
    required String instructions,
    required String model,
    required double temperature,
  }) async {
    try {
      final OpenAIEditModel response = await OpenAI.instance.edit.create(
        model: model,
        instruction: instructions,
        temperature: temperature,
        input: text,
        n: 1,
      );

      return response.choices.first.text;
    } on RequestFailedException catch (e) {
      throw OpenAIServiceException(e.message);
    }
  }
}
