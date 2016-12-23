//
//  extensions.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 20/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import UIKit
import Foundation

// UIImage with downloadable content
extension UIImage {
    class  func contentOfURL(link: String) -> UIImage {
        let url = URL.init(string: link)!
        var image = UIImage()
        do{
            let data = try Data.init(contentsOf: url)
            image = UIImage.init(data: data)!
        } catch _ {
            print("error downloading images")
        }
        return image
    }
}

// uicolor init simplified
extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

let imageCache = NSCache<NSString, UIImage>()

/*
@objc class CFCustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        print("here", url)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            })
            
        }).resume()
    }
    
}

*/
enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}
enum Direction {
    case up
    case left
    case none
}


