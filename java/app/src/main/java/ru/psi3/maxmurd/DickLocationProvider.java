package ru.psi3.maxmurd;

public class DickLocationProvider implements IDickLocationProvider {
    private final String currentDickLocation;

    public DickLocationProvider(DickLocationProviderBuilder dickLocationProviderBuilder) {
        this.currentDickLocation = dickLocationProviderBuilder.dickLocation;
    }

    public String getCurrentDickLocation() {
        return this.currentDickLocation;
    }

    public static class DickLocationProviderBuilder {
        private String dickLocation;

        public DickLocationProviderBuilder setDickLocation(String dickLocation) {
            this.dickLocation = dickLocation;
            return this;
        }
    }
}
