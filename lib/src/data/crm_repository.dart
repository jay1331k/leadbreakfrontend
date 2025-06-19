import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../models/call_data.dart';
import 'api/api_client.dart';
import 'api/api_endpoints.dart';

final crmRepositoryProvider = Provider<CrmRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CrmRepository(apiClient);
});

class CrmRepository {
  final ApiClient _apiClient;

  CrmRepository(this._apiClient);
  // Contact operations
  Future<List<Contact>> getContacts() async {
    // Mock data for development - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      Contact(
        id: '1',
        name: 'John Doe',
        phoneNumber: '+15551234567',
        email: 'john.doe@example.com',
        company: 'Tech Solutions Inc.',
        title: 'CTO',
        notes: 'Interested in our enterprise package',
        tags: ['hot-lead', 'enterprise'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        lastCalledAt: DateTime.now().subtract(const Duration(hours: 4)),
        totalCalls: 3,
        status: ContactStatus.prospect,
      ),
      Contact(
        id: '2',
        name: 'Sarah Johnson',
        phoneNumber: '+15559876543',
        email: 'sarah.j@marketing-corp.com',
        company: 'Marketing Corp',
        title: 'Marketing Director',
        notes: 'Looking for marketing automation tools',
        tags: ['marketing', 'automation'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        lastCalledAt: DateTime.now().subtract(const Duration(days: 1)),
        totalCalls: 2,
        status: ContactStatus.active,
      ),
      Contact(
        id: '3',
        name: 'Mike Wilson',
        phoneNumber: '+15556789012',
        email: 'mike.wilson@startup.io',
        company: 'Startup.io',
        title: 'Founder',
        notes: 'Early stage startup, budget conscious',
        tags: ['startup', 'budget-conscious'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        lastCalledAt: DateTime.now().subtract(const Duration(hours: 12)),
        totalCalls: 1,
        status: ContactStatus.customer,
      ),
    ];
  }
  Future<Contact> getContactById(String id) async {
    // Mock contact details - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 400));
    
    switch (id) {
      case '1':
        return Contact(
          id: '1',
          name: 'John Doe',
          phoneNumber: '+15551234567',
          email: 'john.doe@example.com',
          company: 'Tech Solutions Inc.',
          title: 'Chief Technology Officer',
          notes: 'Very interested in our enterprise package. Has budget authority and is looking to implement by Q2 2025. Key decision maker for technology purchases.',
          tags: ['hot-lead', 'enterprise', 'decision-maker'],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          lastCalledAt: DateTime.now().subtract(const Duration(hours: 4)),
          totalCalls: 3,
          status: ContactStatus.prospect,
        );
      case '2':
        return Contact(
          id: '2',
          name: 'Sarah Johnson',
          phoneNumber: '+15559876543',
          email: 'sarah.j@marketing-corp.com',
          company: 'Marketing Corp',
          title: 'Marketing Director',
          notes: 'Looking for marketing automation tools to streamline their campaign management. Budget around \$25k.',
          tags: ['marketing', 'automation', 'warm-lead'],
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          lastCalledAt: DateTime.now().subtract(const Duration(days: 1)),
          totalCalls: 2,
          status: ContactStatus.active,
        );
      case '3':
        return Contact(
          id: '3',
          name: 'Mike Wilson',
          phoneNumber: '+15556789012',
          email: 'mike.wilson@startup.io',
          company: 'Startup.io',
          title: 'Founder & CEO',
          notes: 'Early stage startup focused on fintech. Budget conscious but growing fast. Good long-term potential.',
          tags: ['startup', 'fintech', 'long-term'],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
          lastCalledAt: DateTime.now().subtract(const Duration(hours: 12)),
          totalCalls: 1,
          status: ContactStatus.customer,
        );
      default:
        throw Exception('Contact not found');
    }
  }

  Future<Contact> createContact(Contact contact) async {
    final response = await _apiClient.post(
      ApiEndpoints.createContact,
      body: contact.toJson(),
    );
    return handleApiResponse(response, Contact.fromJson);
  }

  Future<Contact> updateContact(Contact contact) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateContact(contact.id),
      body: contact.toJson(),
    );
    return handleApiResponse(response, Contact.fromJson);
  }

  Future<void> deleteContact(String id) async {
    final response = await _apiClient.delete(ApiEndpoints.deleteContact(id));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Failed to delete contact',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }

  // Call operations
  Future<List<CallData>> getCalls() async {
    final response = await _apiClient.get(ApiEndpoints.calls);
    return handleApiListResponse(response, CallData.fromJson);
  }
  Future<CallData> initiateCall(String phoneNumber, {String? contactId}) async {
    // Mock call initiation - replace with actual API call
    await Future.delayed(const Duration(seconds: 2));
    
    return CallData(
      callSid: 'call_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      contactId: contactId,
      contactName: contactId == '1' ? 'John Doe' : 
                   contactId == '2' ? 'Sarah Johnson' :
                   contactId == '3' ? 'Mike Wilson' : null,
      status: CallStatus.initiated,
      startTime: DateTime.now(),
      direction: CallDirection.outbound,
    );
  }
  Future<CallData> getCallById(String callSid) async {
    // Mock call details - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return CallData(
      callSid: callSid,
      phoneNumber: '+15551234567',
      contactId: '1',
      contactName: 'John Doe',
      status: CallStatus.completed,
      startTime: DateTime.now().subtract(const Duration(hours: 4)),
      endTime: DateTime.now().subtract(const Duration(hours: 4, minutes: -8)),
      duration: 480, // 8 minutes
      direction: CallDirection.outbound,
      recordingUrl: 'https://example.com/recording.mp3',
      transcript: 'Hi John, thanks for taking the time to speak with me today. I wanted to follow up on our previous conversation about your technology needs. Based on what you mentioned about scaling your operations, I believe our enterprise package would be a perfect fit for Tech Solutions Inc.\n\nAs we discussed, the package includes advanced analytics, 24/7 support, and seamless integration with your existing systems. The implementation timeline would be approximately 6-8 weeks, and we can have your team trained and running smoothly by Q2 2025.\n\nRegarding the budget, we\'re looking at around \$50,000 for the full implementation, which includes the first year of support. I know that\'s a significant investment, but given your projected growth, the ROI should be substantial.\n\nWhat questions do you have about the technical specifications or the implementation process?',
      entities: [
        const CallEntity(type: 'budget', value: '\$50,000', confidence: 0.95, category: 'financial'),
        const CallEntity(type: 'timeline', value: 'Q2 2025', confidence: 0.87, category: 'temporal'),
        const CallEntity(type: 'company', value: 'Tech Solutions Inc.', confidence: 0.99, category: 'organization'),
        const CallEntity(type: 'product', value: 'Enterprise Package', confidence: 0.92, category: 'product'),
        const CallEntity(type: 'implementation', value: '6-8 weeks', confidence: 0.88, category: 'temporal'),
        const CallEntity(type: 'support', value: '24/7 support', confidence: 0.94, category: 'service'),
      ],
      cost: 0.45,
      notes: 'Customer very interested. Needs to discuss with board. Schedule follow-up for next week.',
    );
  }

  Future<CallData> getCallStatus(String callSid) async {
    final response = await _apiClient.get(ApiEndpoints.callStatus(callSid));
    return handleApiResponse(response, CallData.fromJson);
  }

  Future<String> getCallTranscript(String callSid) async {
    final response = await _apiClient.get(ApiEndpoints.callTranscript(callSid));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      throw ApiException(
        'Failed to get call transcript',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }

  Future<String> getCallRecordingUrl(String callSid) async {
    final response = await _apiClient.get(ApiEndpoints.callRecording(callSid));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      throw ApiException(
        'Failed to get call recording',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }

  Future<CallData> endCall(String callSid) async {
    final response = await _apiClient.post(
      ApiEndpoints.endCall,
      body: {'callSid': callSid},
    );
    return handleApiResponse(response, CallData.fromJson);
  }

  // Analytics operations
  Future<Map<String, dynamic>> getCallAnalytics() async {
    final response = await _apiClient.get(ApiEndpoints.callAnalytics);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return handleApiResponse(response, (json) => json);
    } else {
      throw ApiException(
        'Failed to get call analytics',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }

  Future<Map<String, dynamic>> getContactAnalytics() async {
    final response = await _apiClient.get(ApiEndpoints.contactAnalytics);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return handleApiResponse(response, (json) => json);
    } else {
      throw ApiException(
        'Failed to get contact analytics',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }

  // Search operations
  Future<List<Contact>> searchContacts(String query) async {
    final response = await _apiClient.get(
      ApiEndpoints.contacts,
      queryParams: {'search': query},
    );
    return handleApiListResponse(response, Contact.fromJson);
  }
  Future<List<CallData>> getCallsForContact(String contactId) async {
    // Mock call history - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final baseTime = DateTime.now();
    
    return [
      CallData(
        callSid: 'call_001',
        phoneNumber: '+15551234567',
        contactId: contactId,
        contactName: 'John Doe',
        status: CallStatus.completed,
        startTime: baseTime.subtract(const Duration(hours: 4)),
        endTime: baseTime.subtract(const Duration(hours: 4, minutes: -8)),
        duration: 480, // 8 minutes
        direction: CallDirection.outbound,
        recordingUrl: 'https://example.com/recording1.mp3',
        transcript: 'Customer showed strong interest in our enterprise package. Discussed pricing and implementation timeline. Follow up scheduled for next week.',
        entities: [
          const CallEntity(type: 'budget', value: '\$50,000', confidence: 0.95),
          const CallEntity(type: 'timeline', value: 'Q2 2025', confidence: 0.87),
          const CallEntity(type: 'decision maker', value: 'John Doe', confidence: 0.99),
        ],
        cost: 0.45,
      ),
      CallData(
        callSid: 'call_002',
        phoneNumber: '+15551234567',
        contactId: contactId,
        contactName: 'John Doe',
        status: CallStatus.completed,
        startTime: baseTime.subtract(const Duration(days: 2)),
        endTime: baseTime.subtract(const Duration(days: 2, minutes: -5)),
        duration: 300, // 5 minutes
        direction: CallDirection.outbound,
        recordingUrl: 'https://example.com/recording2.mp3',
        transcript: 'Initial introduction call. Explained our services and benefits. Customer expressed interest.',
        entities: [
          const CallEntity(type: 'company', value: 'Tech Solutions Inc.', confidence: 0.98),
          const CallEntity(type: 'interest level', value: 'High', confidence: 0.85),
        ],
        cost: 0.28,
      ),
    ];
  }
}
