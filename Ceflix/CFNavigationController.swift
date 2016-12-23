//
//  CFNavigationController.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 20/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import UIKit

class CFNavigationController: UINavigationController, CFVideoPlayerControllerDelegate {

    //MARK: Properties
    lazy var videoPlayerViewController: CFVideoPlayerController = {
        let pvc: CFVideoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! CFVideoPlayerController
        pvc.view.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        pvc.delegate = self
        return pvc
    }()
    let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.shared.statusBarFrame)
        st.backgroundColor = UIColor.white
        st.alpha = 1.0 // 0.15
        return st
    }()
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let minimizedOrigin: CGPoint = {
        
        
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 40
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    //Methods
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.videoPlayerViewController.view.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.videoPlayerViewController.view.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.videoPlayerViewController.view.frame.origin = self.hiddenOrigin
                self.videoPlayerViewController.videoPlayerView.player?.replaceCurrentItem(with: nil)
            })
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didMaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.videoPlayerViewController.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.videoPlayerViewController.view.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.videoPlayerViewController.view.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.statusView)
            window.addSubview(self.videoPlayerViewController.view)
        }
    }

}
