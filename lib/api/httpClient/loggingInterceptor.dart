import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("<<<<<<<<<<<<<< Request headers <<<<<<< \n${data.headers}");
    print("<<<<<<<<<<<<<< Request baseUrl >>>>>>>>>>>>>> \n${data.method} ${data.baseUrl}");
    print("<<<<<<<<<<<<<< Request params >>>>>>>>>>>>>> \n${data.params}");
    print("<<<<<<<<<<<<<< Request body >>>>>>>>>>>>>> \n${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("---------- Response statusCode : ${data.statusCode}");
    print("---------- Response body ---------- \n${data.body}");

    return data;
  }
}
