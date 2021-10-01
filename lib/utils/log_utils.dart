import 'package:logger/logger.dart';

final logger = Logger();
const mainTag = 'SmartBeehive';

void logError(String message, {String? tag}) =>
    logger.e((tag ?? mainTag).toString() + ' => $message');

void logDebug(String message, {String? tag}) =>
    logger.d((tag ?? mainTag).toString() + ' => $message');

void logWtf(String message, {String? tag}) =>
    logger.wtf((tag ?? mainTag).toString() + ' => $message');

void logVerbose(String message, {String? tag}) =>
    logger.v((tag ?? mainTag).toString() + ' => $message');

void logInfo(String message, {String? tag}) =>
    logger.i((tag ?? mainTag).toString() + ' => $message');

void logWarning(String message, {String? tag}) =>
    logger.w((tag ?? mainTag).toString() + ' => $message');
