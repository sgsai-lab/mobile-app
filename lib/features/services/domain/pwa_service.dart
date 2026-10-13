class PwaService {
  const PwaService({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.iconKey,
  });

  factory PwaService.fromJson(Map<String, dynamic> json) {
    final url = Uri.tryParse(json['url'] as String? ?? '');
    if (url == null || url.scheme != 'https' || url.host.isEmpty) {
      throw const FormatException('Service destinations must use HTTPS.');
    }
    return PwaService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      url: url.toString(),
      iconKey: json['icon'] as String? ?? 'grid',
    );
  }

  final String id;
  final String name;
  final String description;
  final String url;
  final String iconKey;

  Map<String, String> toJson() => <String, String>{
    'id': id,
    'name': name,
    'description': description,
    'url': url,
    'icon': iconKey,
  };

  static const List<PwaService> sampleCatalog = [
    PwaService(
      id: 'workdesk',
      name: 'WorkDesk',
      description: 'A sample workspace for team operations.',
      url: 'https://work.example.com',
      iconKey: 'work',
    ),
    PwaService(
      id: 'learnhub',
      name: 'LearnHub',
      description: 'A sample learning space for courses and resources.',
      url: 'https://learn.example.com',
      iconKey: 'learn',
    ),
    PwaService(
      id: 'helpdesk',
      name: 'HelpDesk',
      description: 'A sample support portal for service requests.',
      url: 'https://support.example.com',
      iconKey: 'support',
    ),
  ];
}
