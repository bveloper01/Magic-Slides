class PresentationRequestModel {
  final String topic;
  final String? extraInfoSource;
  final String email;
  final String accessId;
  final String template;
  final String language;
  final int slideCount;
  final bool aiImages;
  final bool imageForEachSlide;
  final bool googleImage;
  final bool googleText;
  final String model;
  final String presentationFor;
  final WatermarkModel? watermark;

  PresentationRequestModel({
    required this.topic,
    this.extraInfoSource,
    required this.email,
    required this.accessId,
    this.template = 'bullet-point1',
    this.language = 'en',
    this.slideCount = 10,
    this.aiImages = false,
    this.imageForEachSlide = true,
    this.googleImage = false,
    this.googleText = false,
    this.model = 'gpt-4',
    this.presentationFor = 'general audience',
    this.watermark,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'topic': topic,
      'email': email,
      'accessId': accessId,
      'template': template,
      'language': language,
      'slideCount': slideCount,
      'aiImages': aiImages,
      'imageForEachSlide': imageForEachSlide,
      'googleImage': googleImage,
      'googleText': googleText,
      'model': model,
      'presentationFor': presentationFor,
    };

    if (extraInfoSource != null && extraInfoSource!.isNotEmpty) {
      map['extraInfoSource'] = extraInfoSource!;
    }

    if (watermark != null) {
      map['watermark'] = watermark!.toJson();
    }

    return map;
  }
}

class WatermarkModel {
  final String width;
  final String height;
  final String brandURL;
  final String position;

  WatermarkModel({
    required this.width,
    required this.height,
    required this.brandURL,
    required this.position,
  });

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'brandURL': brandURL,
      'position': position,
    };
  }
}