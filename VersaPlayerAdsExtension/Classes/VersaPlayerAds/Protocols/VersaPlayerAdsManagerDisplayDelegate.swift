//
//  VersaPlayerAdsManagerDisplayDelegate.swift
//  VersaPlayerAdsExtension
//
//  Created by Jose Quintero on 10/18/18.
//

import Foundation
import GoogleInteractiveMediaAds

public protocol VersaPlayerAdsManagerDisplayDelegate {
    func ads(loader: IMAAdsLoader!, didLoad data: IMAAdsLoadedData!)
    func ads(loader: IMAAdsLoader!, failedWith data: IMAAdLoadingErrorData!)
    func willSetUpContentPlayer()
    func adsDidFinishPlaying()
    func ads(manager: IMAAdsManager!, didReceive event: IMAAdEvent!)
    func ads(manager: IMAAdsManager!, didReceive error: IMAAdError!)
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!)
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!)
}
