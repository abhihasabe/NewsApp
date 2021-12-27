import 'dart:convert';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }

}

class FetchDataException extends AppException {
  FetchDataException([String message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([String message]) : super(message, "Bad Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String message]) : super(message, "Unauthorised: ");
}

class NotFoundException extends AppException {
  NotFoundException([String message]) : super(message, "Not Found: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class TimeOutException extends AppException {
  TimeOutException([String message]) : super(message, "Time Out Exception: ");
}

class ConflictException extends AppException {
  ConflictException([String message]) : super(message, "Conflict Exception: ");
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String message]) : super(message, "Internal Server Error Exception: ");
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String message]) : super(message, "Service Unavailable Exception: ");
}