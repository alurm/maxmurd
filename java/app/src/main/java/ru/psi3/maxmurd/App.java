package ru.psi3.maxmurd;

public class App {
    public static void main(String[] args) throws DickOutputException, DickNotFoundException, DickInaccessibleException {
        IDefaultConfigurationProvider defaultConfigurationProvider = new DefaultConfigurationProvider();
        ConfigurationProvider.ConfigurationProviderBuilder configurationProviderBuilder =
            new ConfigurationProvider.ConfigurationProviderBuilder()
            .setDickLocation(defaultConfigurationProvider.getDickLocation());
        IConfigurationProvider configurationProvider = new ConfigurationProvider(configurationProviderBuilder);
        DickLocationProvider.DickLocationProviderBuilder dickLocationProviderBuilder =
            new DickLocationProvider.DickLocationProviderBuilder()
            .setDickLocation(configurationProvider.getDickLocation());
        IDickLocationProvider dickLocationProvider = new DickLocationProvider(dickLocationProviderBuilder);
        IDickProvider dickProvider = new DickProvider(dickLocationProvider);
        IDickOutput dickOutput = new DickOutput(dickProvider);
        dickOutput.outputDick();
    }
}
