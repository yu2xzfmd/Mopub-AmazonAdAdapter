//
//  AmazonBannerCustomEvent.swift
//

import UIKit
import MoPub

@objc(AmazonBannerCustomEvent)
class AmazonBannerCustomEvent: MPBannerCustomEvent {
    
    var adView : AmazonAdView?
    let helper = AmazonCustomEventHelper()
    
    override func requestAd(with size: CGSize, customEventInfo info: [AnyHashable : Any]!) {
        let options = AmazonAdOptions()
        options.setAdvancedOption(helper.getPkString(), forKey:kAMAPublisherKey)
        options.setAdvancedOption(kAMASlotName, forKey: kAMASlotKey)
        helper.processCustomEvent(info: info, options: options)
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        if helper.isAmazonAdSize(size: size) {
            adView = AmazonAdView.init(adSize: size)
        } else {
            adView = AmazonAdView.init(frame: rect)
        }
        adView?.delegate = self
        adView?.setVerticalAlignment(.center)
        adView?.setHorizontalAlignment(.center)
        adView?.loadAd(options)
    }
    
}
extension AmazonBannerCustomEvent : AmazonAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return delegate?.viewControllerForPresentingModalView()
    }
    
    func adViewDidLoad(_ view: AmazonAdView!) {
        print("Amazon Banner Ad Loaded")
        delegate?.bannerCustomEvent(self, didLoadAd: view)
    }
    
    func adViewDidFail(toLoad view: AmazonAdView!, withError error: AmazonAdError!) {
        print("Amazon Banner Ad Failed to Load:" + error.description)
        delegate?.bannerCustomEvent(self, didFailToLoadAdWithError: helper.convertAmazonErrorToError(error: error))
    }
    
    func adViewDidCollapse(_ view: AmazonAdView!) {
        print("Amazon Banner Ad view did collapse")
    }
    
    func adViewWillExpand(_ view: AmazonAdView!) {
        print("Amazon Banner Ad view will expand")
    }
}
