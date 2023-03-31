import Foundation
import Capacitor
import UserMessagingPlatform

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(UmpConsentPlugin)
public class UmpConsentPlugin: CAPPlugin {
    private let implementation = UmpConsent()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func userMessagingPlatform(_ call: CAPPluginCall) {{
        let parameters = UMPRequestParameters()
   // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
        with: parameters,
        completionHandler: { error in
            if error != nil {
                // Handle the error.
                call.reject(error)
            } else {
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                if formStatus == .available {
                   //self.loadForm(command: command, forceForm: false)
                   call.resolve("load_form")
                } else if formStatus == .unavailable {
                    // just in case no consent form is required
                    print("Consent form not required")
                    let jsonResult = ["consent" : true, "hasShownDialog" : false, "formAvailable": false] as [AnyHashable : Any]
                    call.reject(jsonResult)
                }
            }
        })
     
    }
}
