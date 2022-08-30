import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rfidapp/pages/generate/Widget/pop_up/reservate_popup.dart';

class Email {
  static Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_8undalr';
    final templateId = 'template_vplro6e';
    final userId = 'mNY4n19_gHAKfcCHy';

    //TODO use data package
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': message
          }
        }));
    print(response.body);
  }
}
