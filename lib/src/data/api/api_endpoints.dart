class ApiEndpoints {
  static const String baseUrl = 'https://api.leadbreak.com'; // Replace with your actual API URL
  
  // Authentication endpoints
  static String get auth => '/api/auth';
  static String get login => '/api/auth/login';
  static String get register => '/api/auth/register';
  static String get logout => '/api/auth/logout';
  
  // Contacts endpoints
  static String get contacts => '/api/contacts';
  static String contactById(String id) => '/api/contacts/$id';
  static String get createContact => '/api/contacts';
  static String updateContact(String id) => '/api/contacts/$id';
  static String deleteContact(String id) => '/api/contacts/$id';
  
  // Calls endpoints
  static String get calls => '/api/calls';
  static String get initiateCall => '/api/calls/initiate';
  static String callById(String callSid) => '/api/calls/$callSid';
  static String callStatus(String callSid) => '/api/calls/$callSid/status';
  static String callTranscript(String callSid) => '/api/calls/$callSid/transcript';
  static String callRecording(String callSid) => '/api/calls/$callSid/recording';
  static String get endCall => '/api/calls/end';
  
  // Follow-ups endpoints
  static String get followUps => '/api/follow-ups';
  static String followUpById(String id) => '/api/follow-ups/$id';
  static String get createFollowUp => '/api/follow-ups';
  static String updateFollowUp(String id) => '/api/follow-ups/$id';
  static String completeFollowUp(String id) => '/api/follow-ups/$id/complete';
  
  // Analytics endpoints
  static String get analytics => '/api/analytics';
  static String get callAnalytics => '/api/analytics/calls';
  static String get contactAnalytics => '/api/analytics/contacts';
  
  // User endpoints
  static String get profile => '/api/user/profile';
  static String get updateProfile => '/api/user/profile';
}
