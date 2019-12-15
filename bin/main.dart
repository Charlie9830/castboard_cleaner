import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:prompts/prompts.dart' as prompts;
import 'package:console/console.dart';

void main(List<String> arguments) {
  final cwd = Directory.current;

  final infoPen = TextPen();
  infoPen.gold();

  printInfo(
      'Please ensure that you are running this tool from inside the directory you wish to clean.');
  newLine();
  printInfo('Current directory:');
  printData(cwd.path);

  final shouldContinue = prompts.getBool('Continue?', appendYesNo: true);

  if (shouldContinue) {
    final matchingFiles = cwd.listSync(followLinks: false).where(
        (item) => path.basename(item.path).startsWith('.') && isImage(item));
    if (matchingFiles.isEmpty) {
      printInfo('No hidden files found. Squeeky clean.');
      holdClose();
    } else {
      printInfo('Found the following hidden Files');
      newLine();
      for (var entity in matchingFiles) {
        printData(path.basename(entity.path));
      }
      newLine();

      final deleteFiles =
          prompts.getBool('Delete these files?', appendYesNo: true);
      if (deleteFiles) {
        for (var entity in matchingFiles) {
          entity.deleteSync();
        }

        printInfo('Hidden files deleted.');
        printInfo('Have a nice day.');

        holdClose();
      } else {
        holdClose();
      }
    }
  }
}

bool isImage(FileSystemEntity entity) {
  return path.basename(entity.path).endsWith('.jpg') ||
      path.basename(entity.path).endsWith('.jpeg') ||
      path.basename(entity.path).endsWith('.png');
}

void printInfo(String text) {
  final pen = TextPen().gold();
  pen(text);
  pen();
}

void printData(String text) {
  final pen = TextPen().lightCyan();
  pen(text);
  pen();
}

void newLine() {
  print('');
}

void holdClose() {
  print('Press any key to exit.');
  Console.readLine();
}

void setup(Directory cwd) {}
