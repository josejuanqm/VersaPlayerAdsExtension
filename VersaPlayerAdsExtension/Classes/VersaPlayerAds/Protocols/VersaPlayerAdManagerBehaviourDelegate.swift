//
//  VersaPlayerAdManagerBehaviourDelegate.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/12/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import Foundation
import VersaPlayer

public protocol VersaPlayerAdManagerBehaviourDelegate {
    func willShowAdsFor(player: VPlayer)
}
