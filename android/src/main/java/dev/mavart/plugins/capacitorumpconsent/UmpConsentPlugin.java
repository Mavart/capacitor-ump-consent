package dev.mavart.plugins.capacitorumpconsent;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import com.google.android.ump.ConsentRequestParameters;

@CapacitorPlugin(name = "UmpConsent")
public class UmpConsentPlugin extends Plugin {

    private UmpConsent implementation = new UmpConsent();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod()
    public void openSettings(PluginCall call) {
        ConsentRequestParameters params = new ConsentRequestParameters.Builder().build();
        call.resolve();
    }
}
