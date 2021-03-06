//
//  GlobalVariables.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 20/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import Foundation
import UIKit

struct globalVariables {
    // static let videoLink = URL
}

//MARK: Global Functions
func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let second = (seconds % 3600) % 60
    let hoursString: String = {
        let hs = String(hours)
        return hs
    }()
    
    let minutesString: String = {
        var ms = ""
        if  (minutes <= 9 && minutes >= 0) {
            ms = "0\(minutes)"
        } else{
            ms = String(minutes)
        }
        return ms
    }()
    
    let secondsString: String = {
        var ss = ""
        if  (second <= 9 && second >= 0) {
            ss = "0\(second)"
        } else{
            ss = String(second)
        }
        return ss
    }()
    
    var label = ""
    if hours == 0 {
        label =  minutesString + ":" + secondsString
    } else{
        label = hoursString + ":" + minutesString + ":" + secondsString
    }
    return label
}

func requestSuggestionsURL(text: String) -> URL {
    let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
    let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
    return url
}

func showNotification() {
    print("Please check your internet connection")
}
