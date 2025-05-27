class Language {
  final String code;
  final String name;

  Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Country {
  final String name;
  final String nativeName;
  final String capital;
  final String emoji;
  final String currency;
  final List<Language> languages;

  Country({
    required this.name,
    required this.nativeName,
    required this.capital,
    required this.emoji,
    required this.currency,
    required this.languages,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    var langsJson = json['languages'] as List<dynamic>? ?? [];
    List<Language> langs =
        langsJson.map((lang) => Language.fromJson(lang)).toList();

    return Country(
      name: json['name'] ?? '',
      nativeName: json['native'] ?? '',
      capital: json['capital'] ?? '',
      emoji: json['emoji'] ?? '',
      currency: json['currency'] ?? '',
      languages: langs,
    );
  }
}
