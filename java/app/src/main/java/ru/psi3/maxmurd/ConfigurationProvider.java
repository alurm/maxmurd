package ru.psi3.maxmurd;

public class ConfigurationProvider implements IConfigurationProvider {
    private final String dickLocation;

    public ConfigurationProvider(ConfigurationProviderBuilder configurationProviderBuilder) {
        this.dickLocation = configurationProviderBuilder.dickLocation;
    }

    public String getDickLocation() {
        return this.dickLocation;
    }

    public static class ConfigurationProviderBuilder {
        private String dickLocation;

        public ConfigurationProviderBuilder setDickLocation(String dickLocation) {
            this.dickLocation = dickLocation;
            return this;
        }
    }
}
