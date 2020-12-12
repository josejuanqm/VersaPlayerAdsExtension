//
//  VersaPlayerAds.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import Foundation
import GoogleInteractiveMediaAds
import VersaPlayer

public class VersaPlayerAdsManager: VersaPlayerExtension, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    
    public var behaviour: VersaPlayerAdManagerBehaviour!
    public var contentPlayhead: IMAAVPlayerContentPlayhead?
    public var pipProxy: IMAPictureInPictureProxy?
    public var adsLoader: IMAAdsLoader?
    public var adsManager: IMAAdsManager?
    public weak var displayDelegate: VersaPlayerAdsManagerDisplayDelegate?
    public var tag: String!
    public var showingAds: Bool = false
    public var adsRenderingSettings: IMAAdsRenderingSettings!
    private weak var viewController: UIViewController!
    
    public init(with player: VersaPlayerView, and delegate: VersaPlayerAdsManagerDisplayDelegate? = nil, on viewController: UIViewController) {
        super.init(with: player)
        self.behaviour = VersaPlayerAdManagerBehaviour()
        self.behaviour.handler = self
        self.displayDelegate = delegate
        self.viewController = viewController
        setUpContentPlayer()
        setUpAdsLoader()
        player.addObserver(self, forKeyPath: "isPipModeEnabled", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isPipModeEnabled" {
            if let value = change?[NSKeyValueChangeKey.newKey] as? Bool {
                requestAds(using: value)
            }
        }
    }
    
    public func setUpAdsLoader() {
        let settings = IMASettings.init()
        settings.autoPlayAdBreaks = displayDelegate?.shouldAutoPlayAds() ?? true
        adsLoader = IMAAdsLoader(settings: settings)
        adsLoader!.delegate = self
    }
    
    public func requestAds(using pip: Bool = false) {
        guard let player = player else { return }
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: player.renderingView, viewController: viewController, companionSlots: self.adsManager == nil ? nil : displayDelegate?.companionSlots(for: self.adsManager!))
        var request: IMAAdsRequest
        if !pip {
            request = IMAAdsRequest(
                adTagUrl: tag,
                adDisplayContainer: adDisplayContainer,
                contentPlayhead: contentPlayhead,
                userContext: nil)
        }else {
            if pipProxy == nil {
                pipProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: player.pipController?.delegate)
                player.pipController?.delegate = pipProxy
            }
            let display = IMAAVPlayerVideoDisplay(avPlayer: player.player)
            request = IMAAdsRequest(
                adTagUrl: tag,
                adDisplayContainer: adDisplayContainer,
                avPlayerVideoDisplay: display,
                pictureInPictureProxy: pipProxy,
                userContext: nil)
        }
        
        adsLoader!.requestAds(with: request)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        displayDelegate?.ads(loader: loader, didLoad: adsLoadedData)
        adsManager = adsLoadedData.adsManager
        adsManager!.delegate = self
        adsRenderingSettings = displayDelegate?.renderingSettings(for: adsManager!)
        
        adsManager!.initialize(with: adsRenderingSettings)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        displayDelegate?.ads(loader: loader, failedWith: adErrorData)
        print(adErrorData.adError.message)
    }
    
    public func setUpContentPlayer() {
        guard let player = player else { return }
        displayDelegate?.willSetUpContentPlayer()
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player.player)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentDidFinishPlaying(notification:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.player.currentItem
        )
    }
    
    @objc public func contentDidFinishPlaying(notification: NSNotification) {
        guard let obj = notification.object as? AVPlayerItem, obj == player?.player.currentItem else { return }
        adsLoader?.contentComplete()
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        guard let player = player else { return }
        displayDelegate?.ads(manager: adsManager, didReceiveEvent: event)
        switch event.type {
        case .LOADED:
            if displayDelegate?.shouldAutoPlayAds() ?? true {
                adsManager.start()
            }
        case .STARTED:
            showingAds = true
            behaviour.willShowAdsFor(player: player.player)
        case .SKIPPED, .COMPLETE:
            displayDelegate?.adsDidFinishPlaying()
            showingAds = false
            behaviour.didEndAd()
        default: break
        }
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        displayDelegate?.ads(manager: adsManager, didReceiveError: error)
        player?.play()
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        displayDelegate?.adsManagerDidRequestContentPause(adsManager)
        player?.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        displayDelegate?.adsManagerDidRequestContentResume(adsManager)
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
}
