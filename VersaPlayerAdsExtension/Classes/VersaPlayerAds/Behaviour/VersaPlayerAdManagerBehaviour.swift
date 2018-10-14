//
//  VersaPlayerAdManagerBehaviour.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/12/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import Foundation
import CoreMedia
import VersaPlayer

public class VersaPlayerAdManagerBehaviour {
    
    public var handler: VersaPlayerAdsManager! {
        didSet {
            configure()
        }
    }
    public var delegate: VersaPlayerAdManagerBehaviourDelegate? = nil
    
    public func configure() {
        
    }
    
    public func willShowAdsFor(player: VPlayer) {
        self.handler.player.controls?.controlsCoordinator.isHidden = true
        delegate?.willShowAdsFor(player: player)
    }
    
    public func didEndAd() {
        self.handler.player.controls?.controlsCoordinator.isHidden = false
    }
    
}
