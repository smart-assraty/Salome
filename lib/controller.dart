import 'dart:io' show Directory;
import 'package:path/path.dart' as path;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pffi;

class Drive extends ffi.Struct{
  external ffi.Pointer<pffi.Utf8> letter;
  @ffi.UnsignedLong()
  external int serialNumber;
}

typedef GetNumberNative = Drive Function(ffi.Int i);
typedef GetNumber =  Drive Function(int i);
typedef GetLengthNative = ffi.Int Function();
typedef GetLength =  int Function();
typedef FindMyProcNative = ffi.Bool Function();
typedef FindMyProc = bool Function();
typedef MediaNative = ffi.Bool Function(ffi.Pointer<pffi.Utf8> media, ffi.Bool signal);
typedef Media = bool Function(ffi.Pointer<pffi.Utf8> media, bool signal);

//final cppLibsPath = path.windows.join(Directory.current.path, 'lib', 'cpp_libs', 'process_monitor.dll'); 
final cppLibsPath = path.windows.join(Directory.current.path, 'cpp_libs', 'process_monitor.dll');

final cppLibsDll = ffi.DynamicLibrary.open(cppLibsPath);

class Controller{
  String processLog = "Process log";
  List<Drive> drives = [];
  Controller();

  void getButtons(){
    int length = getLength();
    for(int i = 0; i < length*4; i += 4){
      drives.add(getNumber(i));
    }
  }

  void getProcessLog(Drive button){
    drives.clear();
    getButtons();
    int length = getLength();
    for(int i = 0; i < length; ++i){
      if(drives[i].serialNumber == button.serialNumber){
        bool mediaResult = false;
        bool acronisOnline = false;
        acronisOnline = findProc();
        String command = button.letter.toDartString()[0];
        if(acronisOnline){
          mediaResult = manageMedia("\\\\.\\$command:", true);
          if(mediaResult) {
            mediaResult = false;
          }
          processLog = "${button.letter.toDartString()} ON $mediaResult";
        }
        if(!acronisOnline){
          mediaResult = manageMedia("\\\\.\\$command:", false);
          if(mediaResult){
            mediaResult = false;
          }  
          processLog = "${button.letter.toDartString()} OFF $mediaResult";
        }
      }

      }
    }

  final FindMyProc find = cppLibsDll.lookupFunction<FindMyProcNative, FindMyProc>('findMyProc');
  bool findProc(){
    return find();
  }

  final Media manage = cppLibsDll.lookupFunction<MediaNative, Media>('manageMedia');
  bool manageMedia(String media, bool signal){
    return manage(media.toNativeUtf8(), signal);
  }

  final GetNumber getnumber = cppLibsDll.lookupFunction<GetNumberNative, GetNumber>('getNumber');
  Drive getNumber(int i){
    var buffer = getnumber(i);
    return buffer;
  }

  final GetLength getlength = cppLibsDll.lookupFunction<GetLengthNative, GetLength>('getLength');
  int getLength(){
    var buffer = getlength();
    return buffer;
  }
}