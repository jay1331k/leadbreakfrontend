class CallData {
  final String callSid;
  final String phoneNumber;
  final String? contactId;
  final String? contactName;
  final CallStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // in seconds
  final String? recordingUrl;
  final String? transcript;
  final List<CallEntity> entities;
  final CallDirection direction;
  final double? cost;
  final String? notes;

  const CallData({
    required this.callSid,
    required this.phoneNumber,
    this.contactId,
    this.contactName,
    required this.status,
    required this.startTime,
    this.endTime,
    this.duration,
    this.recordingUrl,
    this.transcript,
    this.entities = const [],
    required this.direction,
    this.cost,
    this.notes,
  });

  factory CallData.fromJson(Map<String, dynamic> json) {
    return CallData(
      callSid: json['callSid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      status: CallStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => CallStatus.initiated,
      ),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      duration: json['duration'] as int?,
      recordingUrl: json['recordingUrl'] as String?,
      transcript: json['transcript'] as String?,
      entities: (json['entities'] as List<dynamic>?)
          ?.map((e) => CallEntity.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      direction: CallDirection.values.firstWhere(
        (direction) => direction.name == json['direction'],
        orElse: () => CallDirection.outbound,
      ),
      cost: json['cost']?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callSid': callSid,
      'phoneNumber': phoneNumber,
      'contactId': contactId,
      'contactName': contactName,
      'status': status.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'recordingUrl': recordingUrl,
      'transcript': transcript,
      'entities': entities.map((e) => e.toJson()).toList(),
      'direction': direction.name,
      'cost': cost,
      'notes': notes,
    };
  }

  CallData copyWith({
    String? callSid,
    String? phoneNumber,
    String? contactId,
    String? contactName,
    CallStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? recordingUrl,
    String? transcript,
    List<CallEntity>? entities,
    CallDirection? direction,
    double? cost,
    String? notes,
  }) {
    return CallData(
      callSid: callSid ?? this.callSid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      transcript: transcript ?? this.transcript,
      entities: entities ?? this.entities,
      direction: direction ?? this.direction,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallData && other.callSid == callSid;
  }

  @override
  int get hashCode => callSid.hashCode;

  @override
  String toString() {
    return 'CallData(callSid: $callSid, phoneNumber: $phoneNumber, status: $status)';
  }
}

class CallEntity {
  final String type;
  final String value;
  final double confidence;
  final String? category;

  const CallEntity({
    required this.type,
    required this.value,
    required this.confidence,
    this.category,
  });

  factory CallEntity.fromJson(Map<String, dynamic> json) {
    return CallEntity(
      type: json['type'] as String,
      value: json['value'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'confidence': confidence,
      'category': category,
    };
  }
}

enum CallStatus {
  initiated,
  ringing,
  inProgress,
  completed,
  busy,
  failed,
  noAnswer,
  canceled,
}

enum CallDirection {
  inbound,
  outbound,
}

extension CallStatusExtension on CallStatus {
  String get displayName {
    switch (this) {
      case CallStatus.initiated:
        return 'Initiated';
      case CallStatus.ringing:
        return 'Ringing';
      case CallStatus.inProgress:
        return 'In Progress';
      case CallStatus.completed:
        return 'Completed';
      case CallStatus.busy:
        return 'Busy';
      case CallStatus.failed:
        return 'Failed';
      case CallStatus.noAnswer:
        return 'No Answer';
      case CallStatus.canceled:
        return 'Canceled';
    }
  }
}

extension CallDirectionExtension on CallDirection {
  String get displayName {
    switch (this) {
      case CallDirection.inbound:
        return 'Inbound';
      case CallDirection.outbound:
        return 'Outbound';
    }
  }
}
