import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

String dataDirectory;

Future<void> getPermission() async{
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    //pt(permissionStatus);
    if (permissionStatus != PermissionStatus.granted) {
      Map<PermissionGroup,
          PermissionStatus> permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage])
          .then((onError) {
            if(onError.containsValue(PermissionStatus.denied)){
              Fluttertoast.showToast(msg: 'Some Functions may not work properly') ;
            }
            return onError;
      });
    }
}
int homeMaxLength = 90;
int randomMaxLength = 90;
int homeItems = 10;
int randomItems = 10;
