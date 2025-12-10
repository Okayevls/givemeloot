package MainLoader;

import com.sun.jna.Native;

public class CoreInitilizator extends CoreLibrary {

    static {
        System.loadLibrary("msvcp140");
        System.loadLibrary("msvcp140_1");
        System.loadLibrary("vcruntime140");
        System.loadLibrary("vcruntime140_1");
        System.loadLibrary("concrt140");
        System.loadLibrary("libcrypto-3-x64");
        System.loadLibrary("libssl-3-x64");
        System.loadLibrary("Xeno");
    }
    public static CoreBinary dll() {
        System.setProperty("jna.debug_load", "true");
        System.setProperty("jna.debug_load.jna", "true");
        return CoreBinary.INSTANCE;
    }
}
