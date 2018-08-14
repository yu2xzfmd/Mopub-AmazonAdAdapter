//
//  MopubCustomEventHelper.swift
//

import UIKit

class AmazonCustomEventHelper: NSObject {

    func processCustomEvent(info: [AnyHashable : Any], options: AmazonAdOptions) {
        
        if let appKey = info[kAMAAppKey] as? String {
            AmazonAdRegistration.shared().setAppKey(appKey)
        }
        
        if let loggingEnabled = info[kAMALoggingEnabled] as? Bool {
            AmazonAdRegistration.shared().setLogging(loggingEnabled)
        }
        
        if let testingEnabled = info[kAMATestingEnabled] as? Bool {
            options.isTestRequest = testingEnabled
        }
        
        if let geolocationEnabled = info[kAMAGeolocationEnabled] as? Bool {
            options.usesGeoLocation = geolocationEnabled
        }
        
        if let advancedOptions = info[kAMAAdvancedOptionsKey] as? [AnyHashable : Any] {
            for optionKey in advancedOptions.keys {
                options.setAdvancedOption(advancedOptions[optionKey] as! String, forKey: optionKey as! String)
            }
        }
    }
    
    func convertAmazonErrorToError(error: AmazonAdError) -> Error {
        let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString(error.description, comment: "error")]
        return NSError(domain: kAMADomain, code: Int(error.errorCode.rawValue), userInfo: userInfo)
    }
    
    func isAmazonAdSize(size: CGSize) -> Bool {
        return ( __CGSizeEqualToSize(size, AmazonAdSize_320x50)
            || __CGSizeEqualToSize(size, AmazonAdSize_300x250)
            || __CGSizeEqualToSize(size, AmazonAdSize_728x90)
            || __CGSizeEqualToSize(size, AmazonAdSize_1024x50))
    }
    
    func getPkString() -> String{
        var pkString = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject: [kAMAVersion], options: .prettyPrinted)
            pkString = String.init(data: data, encoding: String.Encoding.utf8)!
        } catch {}
        return pkString
    }
}
