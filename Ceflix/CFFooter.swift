//
//  CFFooter.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 28/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import UIKit

class CFFooter: UIView {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
        self.loadMoreButton.isHidden = true
        self.statusLabel.isHidden = true
        self.frame = CGRect(x: 0, y: 518, width: frame.width, height: 40)
    }

}
