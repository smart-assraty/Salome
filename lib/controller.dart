import 'dart:io' show Directory, Platform;
//import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;
import 'package:path/path.dart' as path;

class Drive extends ffi.Struct {
  external ffi.Pointer<pffi.Utf8> letter;
  @ffi.UnsignedLong()
  external int serialNumber;
}

typedef GetNumberNative = Drive Function(ffi.Int i);
typedef GetNumber = Drive Function(int i);
typedef GetNumberFromLetterNative = Drive Function(
    ffi.Pointer<pffi.Utf8> letter);
typedef GetNumberFromLetter = Drive Function(ffi.Pointer<pffi.Utf8> letter);
typedef GetLengthNative = ffi.Int Function();
typedef GetLength = int Function();
typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Bool Function(
    ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = bool Function(ffi.Pointer<pffi.Utf8> media, bool signal);
typedef CopyDirNative = ffi.Void Function(
    ffi.Pointer<pffi.Utf8> from, ffi.Pointer<pffi.Utf8> to);
typedef CopyDir = void Function(
    ffi.Pointer<pffi.Utf8> from, ffi.Pointer<pffi.Utf8> to);

/*final cppLibsPath = path.windows.join(Directory.current.path,
    'data\\flutter_assets\\assets\\cpp_libs\\process_monitor.dll');*/
//final cppLibsPath = path.windows.join(Directory.current.path, 'assets\\cpp_libs\\process_monitor.dll');
var dllpath = path.join(
    '${Directory.current.path}\\data\\flutter_assets\\assets\\cpp_libs\\process_monitor.dll');
final cppLibsDll = ffi.DynamicLibrary.open(dllpath);

class Controller {
  String processLog = "Process log";
  List<Drive> drives = [];
  Controller();

  void getButtons() {
    int length = getLength();
    for (int i = 0; i < length * 4; i += 4) {
      drives.add(getNumber(i));
    }
  }

  void getProcessLog(Drive button) {
    drives.clear();
    getButtons();
    int length = getLength();
    for (int i = 0; i < length; ++i) {
      if (drives[i].serialNumber == button.serialNumber) {
        bool mediaResult = false;
        bool acronisOnline = false;
        acronisOnline = findProc();
        String command = button.letter.toDartString()[0];
        if (acronisOnline) {
          mediaResult = manageMedia("\\\\.\\$command:", true);
          if (mediaResult) {
            mediaResult = false;
          }
          processLog = "${button.letter.toDartString()} ON $mediaResult";
        }
        if (!acronisOnline) {
          mediaResult = manageMedia("\\\\.\\$command:", false);
          if (mediaResult) {
            mediaResult = false;
          }
          processLog = "${button.letter.toDartString()} OFF $mediaResult";
        }
      }
    }
  }

  final FindMyProc find =
      cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc() {
    return find();
  }

  final Media manage =
      cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  bool manageMedia(String media, bool signal) {
    return manage(media.toNativeUtf8(), signal);
  }

  final GetNumber getnumber =
      cppLibsDll.lookupFunction<GetNumberNative, GetNumber>('getNumber');
  Drive getNumber(int i) {
    var buffer = getnumber(i);
    return buffer;
  }

  final GetNumberFromLetter getnumberfromletter =
      cppLibsDll.lookupFunction<GetNumberFromLetterNative, GetNumberFromLetter>(
          'getNumberFromLetter');
  Drive getNumberFromLetter(String letter) {
    var buffer = getnumberfromletter(letter.toNativeUtf8());
    return buffer;
  }

  final GetLength getlength =
      cppLibsDll.lookupFunction<GetLengthNative, GetLength>('getLength');
  int getLength() {
    var buffer = getlength();
    return buffer;
  }

  final CopyDir copydir =
      cppLibsDll.lookupFunction<CopyDirNative, CopyDir>('copyDir');
  void copyDir(String from, String to) {
    copydir(from.toNativeUtf8(), to.toNativeUtf8());
  }
}
