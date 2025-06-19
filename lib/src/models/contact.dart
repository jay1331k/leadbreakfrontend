class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? company;
  final String? title;
  final String? notes;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastCalledAt;
  final int totalCalls;
  final ContactStatus status;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.company,
    this.title,
    this.notes,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.lastCalledAt,
    this.totalCalls = 0,
    this.status = ContactStatus.active,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      company: json['company'] as String?,
      title: json['title'] as String?,
      notes: json['notes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastCalledAt: json['lastCalledAt'] != null 
          ? DateTime.parse(json['lastCalledAt'] as String) 
          : null,
      totalCalls: json['totalCalls'] as int? ?? 0,
      status: ContactStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ContactStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
      'title': title,
      'notes': notes,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastCalledAt': lastCalledAt?.toIso8601String(),
      'totalCalls': totalCalls,
      'status': status.name,
    };
  }

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? company,
    String? title,
    String? notes,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastCalledAt,
    int? totalCalls,
    ContactStatus? status,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      company: company ?? this.company,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastCalledAt: lastCalledAt ?? this.lastCalledAt,
      totalCalls: totalCalls ?? this.totalCalls,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phoneNumber: $phoneNumber)';
  }
}

enum ContactStatus {
  active,
  inactive,
  blocked,
  prospect,
  customer,
}

extension ContactStatusExtension on ContactStatus {
  String get displayName {
    switch (this) {
      case ContactStatus.active:
        return 'Active';
      case ContactStatus.inactive:
        return 'Inactive';
      case ContactStatus.blocked:
        return 'Blocked';
      case ContactStatus.prospect:
        return 'Prospect';
      case ContactStatus.customer:
        return 'Customer';
    }
  }
}
