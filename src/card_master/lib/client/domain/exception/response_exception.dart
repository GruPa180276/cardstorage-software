import 'package:card_master/client/domain/types/snackbar_type.dart';

class FeedbackException implements Exception {
  final FeedbackType feedbackType;
  final String message;

  FeedbackException(this.feedbackType, this.message);

  @override
  String toString() {
    return 'Ursache: "${message}';
  }
}
