import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/api_token.dart';
import '../model/applicant.dart';
import '../model/workflow.dart';

class OnfidoApi {
  OnfidoApi._();

  static final instance = OnfidoApi._();

  final String _baseUrl = "https://api.onfido.com";

  final _headers = {
    "Authorization": "Token token=${dotenv.get("API_TOKEN")}",
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  Future<String> getWorkflowRunId(String applicantId) async {
    final workflowId = dotenv.get("WORKFLOW_ID");
    if (workflowId.isEmpty) {
      throw Exception('Missing workflow id, please check your .env file');
    }

    final body = jsonEncode(
      {"applicant_id": applicantId, "workflow_id": workflowId},
    );

    final response = await http.post(Uri.parse("$_baseUrl/v3.5/workflow_runs"), headers: _headers, body: body);

    if (response.statusCode == 201) {
      return Workflow.fromJson(jsonDecode(response.body)).id!;
    } else {
      throw Exception('Failed to create workflow run id');
    }
  }

  Future<Applicant> createApplicant(String name, String surname, String email) async {
    final body = jsonEncode({
      "application_id": "com.onfido.onfidoFlutterExample",
      "first_name": name,
      "last_name": surname,
      "email": email
    });

    final response = await http.post(Uri.parse("$_baseUrl/v3/applicants"), headers: _headers, body: body);

    if (response.statusCode == 201) {
      return Applicant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create applicant');
    }
  }

  Future<String> createSdkToken(String applicantId) async {
    final body = jsonEncode({"application_id": "com.onfido.onfidoFlutterExample", "applicant_id": applicantId});

    final response = await http.post(Uri.parse("$_baseUrl/v3/sdk_token"), headers: _headers, body: body);

    if (response.statusCode == 200) {
      return ApiToken.fromJson(jsonDecode(response.body)).token!;
    } else {
      throw Exception('Failed to create api token');
    }
  }
}
