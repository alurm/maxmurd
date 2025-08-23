package ru.psi3.maxmurd;

public class DickOutput implements IDickOutput {
    private final IDickProvider dickProvider;

    public DickOutput(IDickProvider dickProvider) {
        this.dickProvider = dickProvider;
    }

    public void outputDick() throws DickOutputException, DickNotFoundException, DickInaccessibleException {
        String dick = this.dickProvider.getDick();
        System.out.print(dick);
    }
}
