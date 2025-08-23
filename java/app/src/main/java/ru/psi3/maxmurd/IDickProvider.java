package ru.psi3.maxmurd;

public interface IDickProvider {
    public String getDick() throws DickNotFoundException, DickInaccessibleException;
}
