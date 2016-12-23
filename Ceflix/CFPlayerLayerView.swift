//
//  CFPlayerLayerView.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 23/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import UIKit
import AVFoundation

class CFPlayerLayerView: UIView
{
    var player: AVPlayer?
        {
        get
        {
            return playerLayer.player
        }
        set
        {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer
    {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override class var layerClass: Swift.AnyClass
        {
        get
        {
            return AVPlayerLayer.self
        }
    }
}
