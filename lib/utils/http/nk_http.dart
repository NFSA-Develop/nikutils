import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nikutils/utils/http/requestdata.dart';
import 'package:nikutils/utils/http/requesttype.dart';
import 'package:nikutils/utils/http/nk_response.dart';

export 'package:nikutils/utils/http/requestdata.dart';
export 'package:nikutils/utils/http/requesttype.dart';
export 'package:nikutils/utils/http/nk_response.dart';

class NkHttpService {
  /// The base uri used for all requests.
  String? _baseUrl;

  NkHttpService(String? baseUrl) {
    _baseUrl = baseUrl;
  }

  /// Method that initializes service injection using the [baseUrl] for requests.
  static void initializeHttpService({String? baseUrl}) {
    Get.put(NkHttpService(baseUrl));
  }

  /// Make a request using the [baseUrl] that
  /// was initialized at instantiation.
  ///
  /// This request must be made using the Nik Architecture API,
  /// Otherwise use [request()].
  Future<NkResponse<T>?> requestNkBase<T>(RequestData<T> requestData) async {
    try {
      var requestUri =
          _getRequestUri(requestData.route, requestData.apiUriProtocol);
      if (requestData.queryParams != null)
        requestUri = _buildQueryParams(requestData.queryParams, requestUri);

      switch (requestData.type) {
        case RequestType.get:
          final httpResponse =
              await http.get(requestUri, headers: requestData.headers);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkResponse<T> response = NkResponse<T>();
            response =
                nkResponseFromJson(httpResponse.body, requestData.fromJson);
            response.httpResponse = httpResponse;
            _validate(response);
            return response;
          } else {
            NkResponse<T> response = NkResponse<T>();
            response.success = false;
            response.httpResponse = httpResponse;
            return response;
          }

        case RequestType.post:
          if (requestData.headers == null)
            requestData.headers = {"Content-Type": requestData.contentType};
          else
            requestData.headers!
                .addAll({"Content-Type": requestData.contentType});
          final httpResponse = await http.post(requestUri,
              headers: requestData.headers,
              body: requestData.postPrefs!.body == null
                  ? jsonEncode("")
                  : jsonEncode(requestData.postPrefs!.body),
              encoding: requestData.postPrefs!.encoding);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkResponse<T> response = NkResponse<T>();
            response =
                nkResponseFromJson(httpResponse.body, requestData.fromJson);
            response.httpResponse = httpResponse;
            _validate(response);
            return response;
          } else {
            NkResponse<T> response = NkResponse<T>();
            response.success = false;
            response.httpResponse = httpResponse;
            return response;
          }

        case RequestType.put:
          final httpResponse = await http.put(requestUri,
              headers: requestData.headers,
              body: requestData.postPrefs!.body == null
                  ? ""
                  : requestData.postPrefs!.body,
              encoding: requestData.postPrefs!.encoding);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkResponse<T> response = NkResponse<T>();
            response =
                nkResponseFromJson(httpResponse.body, requestData.fromJson);
            response.httpResponse = httpResponse;
            _validate(response);
            return response;
          } else {
            NkResponse<T> response = NkResponse<T>();
            response.success = false;
            response.httpResponse = httpResponse;
            return response;
          }

        case RequestType.delete:
          final httpResponse =
              await http.delete(requestUri, headers: requestData.headers);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkResponse<T> response = NkResponse<T>();
            response =
                nkResponseFromJson(httpResponse.body, requestData.fromJson);
            response.httpResponse = httpResponse;
            _validate(response);
            return response;
          } else {
            NkResponse<T> response = NkResponse<T>();
            response.success = false;
            response.httpResponse = httpResponse;
            return response;
          }

        default:
          return null;
      }
    } catch (e) {
      var err = NkResponse<T>();
      err.success = false;
      err.exception = e;
      return err;
    }
  }

  /// Make a request using the [baseUrl] that
  /// was initialized at instantiation.
  Future<NkHttpResponse<T>?> request<T>(RequestData<T> requestData) async {
    try {
      var requestUri =
          _getRequestUri(requestData.route, requestData.apiUriProtocol);
      if (requestData.queryParams != null)
        requestUri = _buildQueryParams(requestData.queryParams, requestUri);

      switch (requestData.type) {
        case RequestType.get:
          final httpResponse =
              await http.get(requestUri, headers: requestData.headers);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.data = requestData.fromJson(httpResponse.body);
            response.httpResponse = httpResponse;
            return response;
          } else {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.httpResponse = httpResponse;
            return response;
          }

        case RequestType.post:
          final httpResponse = await http.post(requestUri,
              headers: requestData.headers,
              body: requestData.postPrefs!.body == null
                  ? jsonEncode("")
                  : jsonEncode(requestData.postPrefs!.body),
              encoding: requestData.postPrefs!.encoding);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.data = requestData.fromJson(httpResponse.body);
            response.httpResponse = httpResponse;
            return response;
          } else {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.httpResponse = httpResponse;
            return response;
          }
        case RequestType.put:
          final httpResponse = await http.put(requestUri,
              headers: requestData.headers,
              body: requestData.postPrefs!.body == null
                  ? ""
                  : requestData.postPrefs!.body,
              encoding: requestData.postPrefs!.encoding);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.data = requestData.fromJson(httpResponse.body);
            response.httpResponse = httpResponse;
            return response;
          } else {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.httpResponse = httpResponse;
            return response;
          }

        case RequestType.delete:
          final httpResponse =
              await http.delete(requestUri, headers: requestData.headers);
          if (httpResponse.statusCode >= 200 &&
              httpResponse.statusCode <= 226) {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.data = requestData.fromJson(httpResponse.body);
            response.httpResponse = httpResponse;
            return response;
          } else {
            NkHttpResponse<T> response = NkHttpResponse<T>();
            response.httpResponse = httpResponse;
            return response;
          }

        default:
          return null;
      }
    } catch (e) {
      var err = NkHttpResponse<T>();
      err.exception = e;
      return err;
    }
  }

  /// Builds the Uri according to the service specifications.
  Uri _getRequestUri(String? route, apiUriProtocol) {
    if (_baseUrl!.isNotEmpty) {
      _baseUrl!.replaceAll("http://", "");
      _baseUrl!.replaceAll("https://", "");
      _baseUrl!.replaceAll("/", "");

      if (route != null) {
        if (route.length >= 1) if ((route[route.length - 1] == '/'))
          route = route.substring(0, route.length - 1);

        if (route.isNotEmpty) if (route[0] == '/')
          route = route.substring(1, route.length);

        return Uri.parse(apiUriProtocol + _baseUrl + "/" + route);
      }
      return Uri.parse(apiUriProtocol + _baseUrl);
    } else {
      throw Exception("BaseUri is null or empty");
    }
  }

  /// Constructs the URI query parameters [queryParams] for a given Uri [uri].
  Uri _buildQueryParams(Map<String, dynamic>? queryParams, Uri uri) {
    return Uri(scheme: uri.toString(), queryParameters: queryParams);
  }

  /// Method that validates the reponse [response] of Nik Architecture.
  void _validate(NkResponse response) {
    var res = response;
    if (!response.success!) {
      response = NkResponse();
      response.success = res.success;
      response.errorData = res.errorData;
    }
  }
}
