//
//  ViewController.swift
//  VersaPlayerAdsExtension
//
//  Created by jose.juan.qm@gmail.com on 10/13/2018.
//  Copyright (c) 2018 jose.juan.qm@gmail.com. All rights reserved.
//

import UIKit
import VersaPlayer
import VersaPlayerAdsExtension

class ViewController: UIViewController, VersaPlayerAdManagerBehaviourDelegate {
    
    @IBOutlet weak var player: VersaPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.useAds(manager: VersaPlayerAdsManager.init(with: player, presentingIn: self))
        player.adsManager?.behaviour.delegate = self
        if let url = URL.init(string: "http://rmcdn.2mdn.net/Demo/html5/output.mp4") {
            let item = VPlayerItem(url: url)
            player.set(item: item)
        }
        
        player.adsManager?.tag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator="
        player.adsManager?.requestAds()
    }
    
    func willShowAdsFor(player: VPlayer) {
        
    }

}

