class ApiConfig {
  bool requestHeader;
  bool requestBody;
  bool responseBody;
  bool responseHeader;
  bool error;
  bool compact;
  bool request;

  ApiConfig(
      {this.requestHeader = false,
      this.requestBody = false,
      this.responseBody = false,
      this.responseHeader = false,
      this.error = false,
      this.compact = false,
      this.request = false});

  factory ApiConfig.activeAll() {
    return ApiConfig(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      request: true,
    );
  }

  factory ApiConfig.offAll() {
    return ApiConfig(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
      responseHeader: false,
      error: false,
      compact: false,
      request: false,
    );
  }

  factory ApiConfig.printResponse() {
    return ApiConfig(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
      responseHeader: false,
      error: false,
      compact: false,
      request: true,
    );
  }
}
