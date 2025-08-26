import 'package:intl/intl.dart';

class DateTimeConverter {
  /// Converts a datetime string from one format to another with comprehensive error handling
  ///
  /// [inputDateTime] - The input datetime string to be converted
  /// [inputFormat] - The format of the input datetime string
  /// [outputFormat] - The desired output format
  ///
  /// Returns the converted datetime string
  static String convertDateTime(
    String inputDateTime, {
    String inputFormat = 'EEE, dd MMM yyyy HH:mm:ss zzz',
    String outputFormat = 'HH:mm a',
  }) {
    try {
      // Trim any leading or trailing whitespace
      inputDateTime = inputDateTime.trim();

      // Validate input is not null or empty
      if (inputDateTime.isEmpty) {
        throw const FormatException('Input datetime string cannot be empty');
      }

      // Create a date format for parsing with more flexible parsing
      final dateParser = DateFormat(inputFormat, 'en_US');

      // Parse the input datetime
      final parsedDateTime = dateParser.parse(inputDateTime);

      // Create a date format for output
      final dateFormatter = DateFormat(outputFormat);

      // Convert to desired output format
      return dateFormatter.format(parsedDateTime);
    } on FormatException catch (e) {
      // Handle format parsing errors with more detailed debugging
      print('Parsing error: ${e.message}');
      print('Input datetime: "$inputDateTime"');
      print('Expected input format: $inputFormat');

      // If standard format fails, try alternative parsing strategies
      try {
        // Alternative parsing strategy
        final alternativeParser = DateFormat(
          'EEE, dd MMM yyyy HH:mm:ss z',
          'en_US',
        );
        final alternativeParsedDateTime = alternativeParser.parse(
          inputDateTime,
        );

        // Create a date format for output
        final dateFormatter = DateFormat(outputFormat);

        // Convert to desired output format
        return dateFormatter.format(alternativeParsedDateTime);
      } catch (alternativeParseError) {
        throw const DateTimeConversionException(
          'Failed to parse datetime. Check input format and string.',
        );
      }
    } catch (e) {
      // Catch any unexpected errors
      print('Unexpected error during datetime conversion: $e');
      throw const DateTimeConversionException(
        'Unexpected error in datetime conversion',
      );
    }
  }

  /// Parse timestamp from server response
  static String parseTimestampFromResponse(String timestampUTC) {
    try {
      return convertDateTime(timestampUTC);
    } catch (e) {
      print('Failed to parse timestamp: $timestampUTC');
      return 'Invalid Time';
    }
  }
}

/// Custom exception for datetime conversion errors
class DateTimeConversionException implements Exception {
  final String message;

  const DateTimeConversionException(this.message);

  @override
  String toString() => 'DateTimeConversionException: $message';
}
