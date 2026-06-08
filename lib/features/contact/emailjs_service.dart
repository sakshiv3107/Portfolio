import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/emailjs_constants.dart';

class EmailJSService {
  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends a contact form email via the EmailJS REST API.
  /// Returns [true] on success, [false] on any failure.
  Future<bool> sendEmail({
    required String fromName,
    required String fromEmail,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'service_id': EmailJSConstants.serviceId,
              'template_id': EmailJSConstants.templateId,
              'user_id': EmailJSConstants.publicKey,
              'template_params': {
                'from_name': fromName,
                'from_email': fromEmail,
                'subject': subject,
                'message': message,
                'to_email': EmailJSConstants.toEmail,
              },
            }),
          )
          .timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
