// Client hub models (home docs/api.md). Parsing is defensive: unknown enum
// values degrade gracefully and launch addresses must be HTTPS.

String _string(Object? value, [String fallback = '']) =>
    value is String ? value : fallback;

String? _optional(Object? value) =>
    value is String && value.isNotEmpty ? value : null;

Uri? _https(Object? value) {
  final uri = value is String ? Uri.tryParse(value) : null;
  return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
      ? uri
      : null;
}

enum Sector {
  business('Business'),
  education('Education');

  const Sector(this.label);
  final String label;

  static Sector? parse(Object? value) =>
      Sector.values.where((sector) => sector.name == value).firstOrNull;
}

enum WorkspaceRole {
  viewer('Viewer'),
  member('Member'),
  admin('Admin'),
  owner('Owner');

  const WorkspaceRole(this.label);
  final String label;

  static WorkspaceRole parse(Object? value) => WorkspaceRole.values.firstWhere(
    (role) => role.name == value,
    orElse: () => viewer,
  );
}

class Membership {
  const Membership({
    required this.clientId,
    required this.clientName,
    required this.role,
    this.sector,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    clientId: _string(json['client_id']),
    clientName: _string(json['client_name'], 'Workspace'),
    role: WorkspaceRole.parse(json['role'] ?? json['my_role']),
    sector: Sector.parse(json['primary_sector']),
  );

  final String clientId;
  final String clientName;
  final WorkspaceRole role;
  final Sector? sector;
}

/// The signed-in user as returned by `/users/me`.
class Me {
  const Me({
    required this.id,
    required this.fullName,
    required this.email,
    required this.isSgsAdmin,
    required this.memberships,
    this.defaultClientId,
  });

  factory Me.fromJson(Map<String, dynamic> json) => Me(
    id: _string(json['id']),
    fullName: _string(json['full_name']),
    email: _string(json['email']),
    isSgsAdmin: json['role'] == 'admin',
    defaultClientId: _optional(json['default_client_id']),
    memberships: (json['memberships'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(Membership.fromJson)
        .toList(growable: false),
  );

  final String id;
  final String fullName;
  final String email;
  final bool isSgsAdmin;
  final List<Membership> memberships;
  final String? defaultClientId;
}

class Client {
  const Client({
    required this.id,
    required this.name,
    required this.role,
    this.sector,
    this.logoAssetId,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: _string(json['id']),
    name: _string(json['name'], 'Workspace'),
    role: WorkspaceRole.parse(json['my_role']),
    sector: Sector.parse(json['primary_sector']),
    logoAssetId: _optional(
      (json['branding'] as Map<String, dynamic>?)?['logo_asset_id'],
    ),
  );

  final String id;
  final String name;
  final WorkspaceRole role;
  final Sector? sector;
  final String? logoAssetId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'my_role': role.name,
    'primary_sector': sector?.name,
    'branding': {'logo_asset_id': logoAssetId},
  };
}

enum ProjectStatus {
  draft('Draft'),
  discovery('Discovery'),
  inProgress('In progress'),
  onHold('On hold'),
  delivered('Delivered'),
  archived('Archived');

  const ProjectStatus(this.label);
  final String label;

  String get wire => this == inProgress
      ? 'in_progress'
      : this == onHold
      ? 'on_hold'
      : name;

  static ProjectStatus parse(Object? value) => ProjectStatus.values.firstWhere(
    (status) => status.wire == value,
    orElse: () => draft,
  );
}

class Milestone {
  const Milestone({required this.title, required this.done, this.due});

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
    title: _string(json['title']),
    done: json['done'] == true,
    due: DateTime.tryParse(_string(json['due'])),
  );

  final String title;
  final bool done;
  final DateTime? due;

  bool isOverdue(DateTime today) =>
      !done &&
      due != null &&
      due!.isBefore(DateTime(today.year, today.month, today.day));

  Map<String, dynamic> toJson() => {
    'title': title,
    'done': done,
    'due': due == null
        ? null
        : '${due!.year.toString().padLeft(4, '0')}-'
              '${due!.month.toString().padLeft(2, '0')}-'
              '${due!.day.toString().padLeft(2, '0')}',
  };
}

class Project {
  const Project({
    required this.id,
    required this.clientId,
    required this.name,
    required this.status,
    required this.milestones,
    this.summary,
    this.sector,
    this.subtitle = '',
    this.startDate,
    this.endDate,
    this.coverAssetId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    final sector = Sector.parse(json['sector']);
    final profile = json['sector_profile'] as Map<String, dynamic>? ?? const {};
    final details = sector == Sector.education
        ? [profile['programme'], profile['cohort'], profile['academic_year']]
        : [profile['department']];
    return Project(
      id: _string(json['id']),
      clientId: _string(json['client_id']),
      name: _string(json['name'], 'Project'),
      status: ProjectStatus.parse(json['status']),
      summary: _optional(json['summary']),
      sector: sector,
      subtitle: [
        sector?.label,
        ...details,
      ].whereType<String>().where((part) => part.isNotEmpty).join(' · '),
      startDate: DateTime.tryParse(_string(json['start_date'])),
      endDate: DateTime.tryParse(_string(json['end_date'])),
      coverAssetId: _optional(json['cover_asset_id']),
      milestones: (json['milestones'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(Milestone.fromJson)
          .toList(growable: false),
    );
  }

  final String id;
  final String clientId;
  final String name;
  final ProjectStatus status;
  final String? summary;
  final Sector? sector;
  final String subtitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? coverAssetId;
  final List<Milestone> milestones;

  Milestone? get nextMilestone =>
      milestones.where((milestone) => !milestone.done).firstOrNull;

  Map<String, dynamic> toJson() => {
    'id': id,
    'client_id': clientId,
    'name': name,
    'status': status.wire,
    'summary': summary,
    'sector': sector?.name,
    'start_date': startDate?.toIso8601String().substring(0, 10),
    'end_date': endDate?.toIso8601String().substring(0, 10),
    'cover_asset_id': coverAssetId,
    'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
  };
}

enum ProductKind {
  pwa('Web app'),
  web('Website'),
  android('Android app'),
  ios('iOS app'),
  service('Service');

  const ProductKind(this.label);
  final String label;

  static ProductKind parse(Object? value) => ProductKind.values.firstWhere(
    (kind) => kind.name == value,
    orElse: () => service,
  );
}

enum ProductStatus {
  planned('Planned'),
  beta('Beta'),
  live('Live'),
  retired('Retired');

  const ProductStatus(this.label);
  final String label;

  static ProductStatus parse(Object? value) => ProductStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => planned,
  );
}

class Product {
  const Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.kind,
    required this.status,
    this.clientId = '',
    this.projectId,
    this.summary,
    this.launchUrl,
    this.androidStoreUrl,
    this.iosStoreUrl,
    this.iconAssetId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final stores = json['store_urls'] as Map<String, dynamic>? ?? const {};
    return Product(
      id: _string(json['id']),
      clientId: _string(json['client_id']),
      projectId: _optional(json['project_id']),
      slug: _string(json['slug']),
      name: _string(json['name'], 'App'),
      kind: ProductKind.parse(json['kind']),
      status: ProductStatus.parse(json['status']),
      summary: _optional(json['summary']),
      launchUrl: _https(json['launch_url']),
      androidStoreUrl: _https(stores['android']),
      iosStoreUrl: _https(stores['ios']),
      iconAssetId: _optional(json['icon_asset_id']),
    );
  }

  final String id;
  final String clientId;
  final String? projectId;
  final String slug;
  final String name;
  final ProductKind kind;
  final ProductStatus status;
  final String? summary;
  final Uri? launchUrl;
  final Uri? androidStoreUrl;
  final Uri? iosStoreUrl;
  final String? iconAssetId;

  bool get isRetired => status == ProductStatus.retired;

  /// Shown to members: planned apps are not ready to open yet.
  bool get isListed => status != ProductStatus.planned;

  Map<String, dynamic> toJson() => {
    'id': id,
    'client_id': clientId,
    'project_id': projectId,
    'slug': slug,
    'name': name,
    'kind': kind.name,
    'status': status.name,
    'summary': summary,
    'launch_url': launchUrl?.toString(),
    'store_urls': {
      'android': androidStoreUrl?.toString(),
      'ios': iosStoreUrl?.toString(),
    },
    'icon_asset_id': iconAssetId,
  };
}

class TeamMember {
  const TeamMember({required this.fullName, required this.role});

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    fullName: _string(json['full_name'], 'Member'),
    role: WorkspaceRole.parse(json['role']),
  );

  final String fullName;
  final WorkspaceRole role;

  Map<String, dynamic> toJson() => {'full_name': fullName, 'role': role.name};
}

class Deliverable {
  const Deliverable({
    required this.id,
    required this.filename,
    required this.kind,
    required this.sizeBytes,
  });

  factory Deliverable.fromJson(Map<String, dynamic> json) => Deliverable(
    id: _string(json['id']),
    filename: _string(json['filename'], 'File'),
    kind: _string(json['kind'], 'document'),
    sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
  );

  final String id;
  final String filename;
  final String kind;
  final int sizeBytes;
}

/// Everything the home screen shows for one workspace.
class WorkspaceSnapshot {
  const WorkspaceSnapshot({
    required this.client,
    required this.projects,
    required this.products,
    required this.team,
    required this.savedAt,
    this.offline = false,
  });

  factory WorkspaceSnapshot.fromJson(Map<String, dynamic> json) =>
      WorkspaceSnapshot(
        client: Client.fromJson(json['client'] as Map<String, dynamic>),
        projects: _list(json['projects'], Project.fromJson),
        products: _list(json['products'], Product.fromJson),
        team: _list(json['team'], TeamMember.fromJson),
        savedAt: DateTime.tryParse(_string(json['saved_at'])) ?? DateTime(2000),
        offline: true,
      );

  final Client client;
  final List<Project> projects;
  final List<Product> products;
  final List<TeamMember> team;
  final DateTime savedAt;

  /// True when rendered from the device cache because the network failed.
  final bool offline;

  Map<String, dynamic> toJson() => {
    'client': client.toJson(),
    'projects': projects.map((project) => project.toJson()).toList(),
    'products': products.map((product) => product.toJson()).toList(),
    'team': team.map((member) => member.toJson()).toList(),
    'saved_at': savedAt.toUtc().toIso8601String(),
  };
}

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parse) =>
    (value as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(parse)
        .toList(growable: false);
