import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

MediaType getMimeType(String path) {
  return MediaType.parse(lookupMimeType(path)!);
}
