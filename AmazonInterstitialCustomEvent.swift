//
//  AmazonInterstitialCustomEvent.swift
//

import UIKit
import MoPub

@objc(AmazonInterstitialCustomEvent)
class AmazonInterstitialCustomEvent: MPInterstitialCustomEvent {
    
    let adView : AmazonAdInterstitial?
    let helper = AmazonCustomEventHelper()
    
    override init() {
        adView = AmazonAdInterstitial()
        super.init()
        adView?.delegate = self
    }
    
    override func requestInterstitial(withCustomEventInfo info: [AnyHashable : Any]!) {
        let options = AmazonAdOptions()
        options.setAdvancedOption(helper.getPkString(), forKey:kAMAPublisherKey)
        options.setAdvancedOption(kAMASlotName, forKey: kAMASlotKey)
        helper.processCustomEvent(info: info, options: options)
        adView?.load(options)
    }
    
    override func showInterstitial(fromRootViewController rootViewController: UIViewController!) {
        adView?.present(from: rootViewController)
    }
    
}

extension AmazonInterstitialCustomEvent : AmazonAdInterstitialDelegate {
    
    func interstitialDidLoad(_ interstitial: AmazonAdInterstitial!) {
        print("Amazon Interstitial Ad Loaded")
        delegate.interstitialCustomEvent(self, didLoadAd: interstitial)
    }
    
    func interstitialDidFail(toLoad interstitial: AmazonAdInterstitial!, withError error: AmazonAdError!) {
        print("Amazon Interstitial Ad Failed to Load:" + error.description)
        delegate.interstitialCustomEvent(self, didFailToLoadAdWithError: helper.convertAmazonErrorToError(error: error))
    }
    
    func interstitialDidPresent(_ interstitial: AmazonAdInterstitial!) {
        print("Amazon Interstitial Ad Did Appear")
        delegate.interstitialCustomEventDidAppear(self)
    }
    
    func interstitialDidDismiss(_ interstitial: AmazonAdInterstitial!) {
        print("Amazon Interstitial Ad Did Disappear")
        delegate.interstitialCustomEventDidDisappear(self)
    }

    func interstitialWillDismiss(_ interstitial: AmazonAdInterstitial!) {
        print("Amazon Interstitial Ad Will Disappear")
        delegate.interstitialCustomEventWillDisappear(self)
    }
    
    func interstitialWillPresent(_ interstitial: AmazonAdInterstitial!) {
        print("Amazon Interstitial Ad Will Present")
        delegate.interstitialCustomEventWillAppear(self)
    }
}
