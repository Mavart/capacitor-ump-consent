package dev.mavart.plugins.capacitorumpconsent;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import android.util.Log;


import com.google.android.ump.ConsentForm;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentRequestParameters;
import com.google.android.ump.FormError;
import com.google.android.ump.UserMessagingPlatform;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

@CapacitorPlugin(name = "UmpConsent")
public class UmpConsentPlugin extends Plugin {

    private static final String TAG = "UMPConsentPlugin";
    private ConsentInformation consentInformation;
    private ConsentForm consentForm;

    @PluginMethod
    public void userMessagingPlatform(PluginCall call) {
        // Set tag for under age of consent. false means users are not under
        // age.
        JSObject ret = new JSObject();

        ConsentRequestParameters params = new ConsentRequestParameters
            .Builder()
            .setTagForUnderAgeOfConsent(false)
            .build();

        consentInformation = UserMessagingPlatform.getConsentInformation(getContext());
        consentInformation.requestConsentInfoUpdate(
            getActivity(),
            params,
            new ConsentInformation.OnConsentInfoUpdateSuccessListener() {
                @Override
                public void onConsentInfoUpdateSuccess() {
                    // The consent information state was updated.
                    // You are now ready to check if a form is available.
                    if (consentInformation.isConsentFormAvailable()) {
                       loadForm(false, call);
                    }else{
                        call.reject("form not available");
                    }

                }
            },
            new ConsentInformation.OnConsentInfoUpdateFailureListener() {
                @Override
                public void onConsentInfoUpdateFailure(FormError formError) {
                    call.reject(formError.getErrorCode() + ':' + formError.getMessage());
                }
            });




    }

    public void loadForm(boolean forceForm, PluginCall call){
        UserMessagingPlatform.loadConsentForm(getContext(),
            new UserMessagingPlatform.OnConsentFormLoadSuccessListener() {
                @Override
                public void onConsentFormLoadSuccess(ConsentForm form) {
                  consentForm = form;
                  if(forceForm){
                    consentForm.show(getActivity(), formError -> {
                        if (formError != null) {
                          call.reject(formError.getErrorCode() + ':' + formError.getMessage());
                        } else {
                          call.resolve(getConsentResponse());
                        }
                      }
                    );
                  }else{
                    if(consentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.REQUIRED) {
                      consentForm.show(getActivity(), formError -> {
                          if (formError != null) {
                            call.reject(formError.getErrorCode() + ':' + formError.getMessage());
                          } else {
                            call.resolve(getConsentResponse());
                          }
                        }
                      );
                    }else{
                      call.resolve(getConsentResponse());
                    }
                  }

                }
            },
            new UserMessagingPlatform.OnConsentFormLoadFailureListener() {
                @Override
                public void onConsentFormLoadFailure(FormError formError) {
                  call.reject(formError.getErrorCode() + ':' + formError.getMessage());
                }
            }
        );
    }

  private JSObject getConsentResponse () {
    JSObject response = new JSObject();

    String consentStatus = "UNKNOWN";
    if(consentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.REQUIRED){
      consentStatus = "REQUIRED";
    }else if(consentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.NOT_REQUIRED){
      consentStatus = "NOT_REQUIRED";
    }else if(consentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.OBTAINED){
      consentStatus = "OBTAINED";
    }

    response.put("status", consentStatus);

    return response;
  }

    @PluginMethod()
    public void forceForm(PluginCall call) {
        loadForm(true, call);
        call.resolve();
    }

    @PluginMethod()
    public void reset(PluginCall call) {
      UserMessagingPlatform.getConsentInformation(getContext()).reset();
        call.resolve();
    }
}
