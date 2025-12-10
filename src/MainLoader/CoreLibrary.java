package MainLoader;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.sun.jna.Pointer;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class CoreLibrary {

    public static String getVersion(CoreBinary getCoreDll) {
        Pointer ptr = getCoreDll.Version();
        if (ptr == null) {
            System.out.println("[Console] getVersion error!");
            return null;
        }
        return ptr.getString(0);
    }

    public static String getClients(CoreBinary core) {
        Pointer ptr = core.GetClients();
        return ptr.getString(0);
    }

    public static void executeScript(CoreBinary dll, String script, int[] pids) {
        if (pids == null || pids.length == 0) return;
        byte[] scriptBytes = (script + "\0").getBytes(StandardCharsets.UTF_8);
        dll.Execute(scriptBytes, pids, pids.length);
        System.out.println("[Console] Execution выполнен успешно!");
    }

    public static void initialize(CoreBinary dll) {
        dll.Initialize((byte)1);
        System.out.println("[Console] Initilization выполнен успешно!");
    }

    public static void attach(CoreBinary dll) {
        dll.Attach();
        System.out.println("[Console] Attach выполнен успешно!");
    }

    public static void setSetting(CoreBinary dll, int settingId, int value) {
        dll.SetSetting(settingId, value);
        System.out.println("[Console] setSetting выполнен успешно!");
    }
}
