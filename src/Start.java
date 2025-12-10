import MainLoader.CoreBinary;
import MainLoader.CoreInitilizator;
import MainLoader.CoreLibrary;
import com.sun.jna.NativeLibrary;
import com.sun.jna.Pointer;

import java.util.List;

public class Start extends CoreInitilizator {

    public static void main(String[] args) {
        CoreBinary dll = CoreInitilizator.dll();

        try {
            System.out.println("Version: " + dll.Version().getString(0));
        } catch (Throwable t) {
            System.out.println("Version FAILED:");
            t.printStackTrace();
        }

        try {
            System.out.println("Calling Initialize...");
            dll.Initialize((byte)1);
            System.out.println("Initialize OK");
        } catch (Throwable t) {
            System.out.println("Initialize FAILED:");
            t.printStackTrace();
        }
    }

}