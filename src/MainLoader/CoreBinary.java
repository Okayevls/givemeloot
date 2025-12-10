package MainLoader;

import com.sun.jna.*;
import com.sun.jna.win32.StdCallLibrary;

public interface CoreBinary extends StdCallLibrary {
    CoreBinary INSTANCE = Native.load("Xeno", CoreBinary.class);
    Pointer GetClients();
    Pointer Version();
    void Execute(byte[] script, int[] PIDs, int count);
    void SetSetting(int settingID, int value);
    void Attach();
    void Initialize(byte useConsole);
}
