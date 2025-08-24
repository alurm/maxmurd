package ru.psi3.maxmurd;

public class DefaultConfigurationProvider implements IDefaultConfigurationProvider {
    private final String dickLocation = "../../README.md";

    public String getDickLocation() {
        return this.dickLocation;
    }
}
