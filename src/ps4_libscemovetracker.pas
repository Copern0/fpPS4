unit ps4_libSceMoveTracker;

{$mode ObjFPC}{$H+}

interface

uses
  ps4_program;

const
 SCE_MOVE_TRACKER_ERROR_INVALID_ARG=-2131820541; //0x80EF0003

 SCE_MOVE_MAX_CONTROLLERS=4;
 SCE_MOVE_MAX_CONTROLLERS_PER_PLAYER=2;

type
 pSceMoveButtonData=^SceMoveButtonData;
 SceMoveButtonData=packed record
  digitalButtons,analogT:Word;
 end;

 pSceMoveExtensionPortData=^SceMoveExtensionPortData;
 SceMoveExtensionPortData=packed record
  status      :Word;
  digital1    :Word;
  digital2    :Word;
  analogRightX:Word;
  analogRightY:Word;
  analogLeftX :Word;
  analogLeftY :Word;
  custom      :array[0..5] of Byte;
 end;

 pSceMoveData=^SceMoveData;
 SceMoveData=packed record
  accelerometer:array[0..2] of single;
  gyro         :array[0..2] of single;
  pad          :SceMoveButtonData;
  ext          :SceMoveExtensionPortData;
  timestamp    :Int64;
  counter      :Integer;
  temperature  :single;
 end;

 pSceMoveTrackerControllerInput=^SceMoveTrackerControllerInput;
 SceMoveTrackerControllerInput=packed record
  handle:Integer;
  _align:Integer;
  data:pSceMoveData;
  num:Integer;
 end;  

implementation

function ps4_sceMoveTrackerGetWorkingMemorySize(onionSize,garlicSize:PInteger):Integer; SysV_ABI_CDecl;
begin
 if (onionSize=nil) or (garlicSize=nil) then Exit(SCE_MOVE_TRACKER_ERROR_INVALID_ARG);
 onionSize^ :=$800000 + $200000;
 garlicSize^:=$800000;
 Result:=0;
end;

function ps4_sceMoveTrackerInit(onionMemory,garlicMemory:Pointer;pipeId,queueId:Integer):Integer; SysV_ABI_CDecl;
begin
 if (onionMemory=nil) or (garlicMemory=nil) then Exit(SCE_MOVE_TRACKER_ERROR_INVALID_ARG);
 Result:=0;
end;

function ps4_sceMoveTrackerControllersUpdate(controllerInputs:pSceMoveTrackerControllerInput):Integer; SysV_ABI_CDecl;
begin
 //controllerInputs[SCE_MOVE_MAX_CONTROLLERS]
 Result:=0;
end;

function Load_libSceMoveTracker(Const name:RawByteString):TElf_node;
var
 lib:PLIBRARY;
begin
 Result:=TElf_node.Create;
 Result.pFileName:=name;

 lib:=Result._add_lib('libSceMoveTracker');
 lib^.set_proc($820D5DE0AB32555B,@ps4_sceMoveTrackerGetWorkingMemorySize);
 lib^.set_proc($178C366ADC06E36F,@ps4_sceMoveTrackerInit);
 lib^.set_proc($FD8F2194C801B2BE,@ps4_sceMoveTrackerControllersUpdate);
end;

initialization
 ps4_app.RegistredPreLoad('libSceMoveTracker.prx',@Load_libSceMoveTracker);

end.

