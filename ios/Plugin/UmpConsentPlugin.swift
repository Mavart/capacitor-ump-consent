import Foundation
import Capacitor
import UserMessagingPlatform

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(UmpConsentPlugin)
public class UmpConsentPlugin: CAPPlugin {


    @objc func userMessagingPlatform(_ call: CAPPluginCall) {
        print("userMessagingPlatform")
        let parameters = UMPRequestParameters()
   // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
        with: parameters,
        completionHandler: { error in
            if error != nil {
                // Handle the error.
                call.reject("errore ump")
            } else {
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                if formStatus == .available {
                   //self.loadForm(command: command, forceForm: false)
                self.loadForm(forceForm: false, call: call)
                   
                } else if formStatus == .unavailable {
                    // just in case no consent form is required
                    print("Consent form not required")
                  
                    call.reject("Consent form unaivable")
                }
                print("Consent form called")
            }
        })
     
    }
    
    func loadForm(forceForm: Bool, call: CAPPluginCall){
        UMPConsentForm.load(completionHandler: { (form, loadError) in
            if let error = loadError as NSError? {
                        // deal with error loading form
                print("Error verifyConsent: \(error.localizedDescription)")
                call.reject(error.localizedDescription)
            } else {
                if forceForm == true
                    {
                            // force display the form
                            // usable for settings section
                    form?.present(from: self.getRootVC()!, completionHandler: {(error) in
                                if UMPConsentInformation.sharedInstance.consentStatus == .obtained {
                                    // user gave consent
                                    // OK to serve ads
                                    call.resolve(["status": "user gave consent"])
                                } else {
                                    print("User got the form and didn't give consent")
                                    call.resolve(["status": "User got the form and didn't give consent"])
                                }
                            
                            })
                            
                        } else
                        {
                            // If user didn't get a consent form before, display it
                            if UMPConsentInformation.sharedInstance.consentStatus == .required {
                                form?.present(from: self.getRootVC()!, completionHandler: {(error) in
                                    if UMPConsentInformation.sharedInstance.consentStatus == .obtained {
                                        // user gave consent
                                        // OK to serve ads
                                        print("User got the form and gave consent")
                                        let jsonResult = ["consent" : true, "hasShownDialog" : true, "formAvailable": true] as [AnyHashable : Any]
                                        call.resolve(["status": "user gave consent"])
                                    } else {
                                        print("User got the form and didn't give consent")
                                        let jsonResult = ["consent" : false, "hasShownDialog" : true, "formAvailable": true] as [AnyHashable : Any]
                                        call.resolve(["status": "User got the form and didn't give consent"])
                                    }
                                })
                            } else if UMPConsentInformation.sharedInstance.consentStatus == .obtained {
                                // if user received the consent form before and gave consent
                                // OK to serve ads
                                print("User gave consent before")
                                call.resolve(["status": "User gave consent before"])
                            }
                        }
                    }
                })
    }
    
    @objc func forceForm(_ call: CAPPluginCall) {
        self.loadForm(forceForm: true, call: call)
    }
    
    @objc func reset(_ call: CAPPluginCall) {
        UMPConsentInformation.sharedInstance.reset()
        call.resolve()
    }
    
    func getRootVC() -> UIViewController? {
            var window: UIWindow? = UIApplication.shared.delegate?.window ?? nil

            if window == nil {
                let scene: UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
                window = scene?.windows.filter({$0.isKeyWindow}).first
                if window == nil {
                    window = scene?.windows.first
                }
            }
            return window?.rootViewController
    }
}
