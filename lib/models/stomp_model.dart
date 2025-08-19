class StompFrame {
  final String command;
  final Map<String, String> headers;
  final String? body;

  StompFrame({
    required this.command,
    this.headers = const {},
    this.body,
  });

  String toStompString() {
    final headerString = headers.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .join('\n');

    final bodyString = body ?? '';

    return '$command\n$headerString\n\n$bodyString\u0000';
  }
}

StompFrame toStompFrame(String data) {
  final lines = data.split("\n");
  final command = lines[0];
  final Map<String, String> headers = {};
  String? body = "";
  var headerEndIndex = -1;

  for (var i = 1; i < lines.length; i++) {
  if (lines[i] == "") {
  headerEndIndex = i;
  break;
  }
  final parts = lines[i].split(":");
  final key = parts[0];
  final value = parts.sublist(1).join(":").trim();
  headers[key] = value;
  }

  if (headerEndIndex != -1) {
    body = lines.sublist(headerEndIndex + 1).join('\n').replaceAll('\u0000', '');
  }
  return StompFrame(command: command, headers: headers, body: body);
}
