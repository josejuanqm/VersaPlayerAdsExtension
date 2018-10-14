//
//  VersaPlayerAdExtension.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import Foundation
import UIKit
import VersaPlayer

public extension VersaPlayer {
    
    public var adsManager: VersaPlayerAdsManager? {
        let adsManager = getExtension(with: "adsManager") as? VersaPlayerAdsManager
        return adsManager
    }
    
    public func useAds(manager: VersaPlayerAdsManager) {
        addExtension(extension: manager, with: "adsManager")
    }
    
}
