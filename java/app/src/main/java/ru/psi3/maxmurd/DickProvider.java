package ru.psi3.maxmurd;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileInputStream;
import java.io.IOException;

public class DickProvider implements IDickProvider {
    private final IDickLocationProvider dickLocationProvider;

    public DickProvider(IDickLocationProvider dickLocationProvider) {
        this.dickLocationProvider = dickLocationProvider;
    }

    public String getDick() throws DickNotFoundException, DickInaccessibleException {
        String currentDickLocation = this.dickLocationProvider.getCurrentDickLocation();
        try {
            File dickFile = new File(currentDickLocation);
            FileInputStream dickFileInputStream = new FileInputStream(dickFile);
            byte[] dickBinaryContents = new byte[(int)dickFile.length()];
            dickFileInputStream.read(dickBinaryContents);
            dickFileInputStream.close();
            String dickString = new String(dickBinaryContents, "UTF-8");
            return dickString;
        } catch(FileNotFoundException e) {
            throw new DickNotFoundException();
        } catch(IOException e) {
            throw new DickInaccessibleException();
        }
    }
}
