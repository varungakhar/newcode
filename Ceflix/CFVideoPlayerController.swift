//
//  CFVideoPlayerController.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 19/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

protocol CFVideoPlayerControllerDelegate {
    func didMinimize()
    func didMaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
}

import UIKit
import AVFoundation
// import CFVideo

private var playbackLikelyToKeepUpContext = 0

class CFVideoPlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, CFVideoListCellDelegate, CFOptionsMenuDelegate {

    // MARK: Outlets
    @IBOutlet weak var videoPlayerView: CFPlayerLayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postCommentView: UIView!
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var videoLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoLengthLabel: UILabel!
    @IBOutlet weak var videoTimeLabel: UILabel!
    @IBOutlet weak var goFullScreenButton: UIButton!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var watchLaterButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var tableViewFooter: CFFooter!
    
    private var loading = false
        /*
        {
        didSet {
            tableViewFooter.isHidden = !loading
        }
    }
    */
    
    // MARK: properties
    let service = CFCeflixService.sharedInstance() as CFCeflixService
    var video: CFCeflixRemoteVideo?
    var videoID: NSString? = nil
    var channelID: NSString? = nil
    var videoUrl: URL? = nil
    var delegate: CFVideoPlayerControllerDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var videoPlayer: AVPlayer?
    var relatedVideos: NSArray = []
    var videoComments: NSArray = []
    var videoLikers: NSArray = []
    var isRowHidden: Bool = true
    var segmentedControlIndex: Int = 0
    
    lazy var optionsMenu: CFOptionsMenu = {
        let optionsMenu = CFOptionsMenu.init(frame: UIScreen.main.bounds)
        optionsMenu.delegate = self
        return optionsMenu
    }()
    
    // MARK: Methods
    func customization() {
        self.view.backgroundColor = UIColor.clear
        self.videoPlayerView.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        // self.videoPlayerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CFVideoPlayerController.tapPlayView)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(CFVideoPlayerController.tapPlayView(notification:)), name: NSNotification.Name("open"), object: nil)
    }
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                self.tableView.alpha = 1
                self.videoPlayerView.transform = CGAffineTransform.identity
                // UIApplication.shared.isStatusBarHidden = true
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = false
                self.minimizeButton.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.videoPlayerView.bounds.width/4, y: -self.videoPlayerView.bounds.height/2 + 20))
                self.videoPlayerView.transform = trasform
                
                self.videoPlayerView.addSubview(self.minimizeButton)
                
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        self.tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.videoPlayerView.bounds.width / 4 * scaleFactor), y: -(self.videoPlayerView.bounds.height / 4 * scaleFactor)))
        self.videoPlayerView.transform = trasform
    }
    
    func tapPlayView(notification: Notification)  {
        
        
        let dict = notification.userInfo
        
        // self.video = dict.value(forKey: <#T##String#>)
        
        self.videoID = dict?["videoID"] as! NSString?
        self.channelID = dict?["channelID"] as! NSString?
        print(videoID!)
        self.fetchVideoDetails()
        
        /*
        if ((self.video?.videoURL) != nil) {
            print(video?.videoURL as Any)
            self.videoPlayer.play()
            self.state = .fullScreen
            self.delegate?.didMaximize()
            self.animate()
            
            self.setupPlayerView()
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "Error", message:"No URL Link for selected video", preferredStyle: .alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
        }
        */
    }
    
    func segmentedControlChangedValue(segmentedControl: UISegmentedControl) {
        print(segmentedControl.selectedSegmentIndex)
        self.segmentedControlIndex = segmentedControl.selectedSegmentIndex
        
        // reload table view section
        let range = NSMakeRange(1, 1)
        let sectionToReload = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sectionToReload as IndexSet, with: UITableViewRowAnimation.automatic)

        if self.segmentedControlIndex == 1 {
            self.commentView.isHidden = false
        }
    }
    
    var isPlaying = false
    
    // MARK: Actions
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if isPlaying {
            self.videoPlayerView.player?.pause()
            self.playButton.setImage(UIImage(named: "play"), for: .normal)
        }
        else {
            self.videoPlayerView.player?.play()
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @IBAction func sliderChanged(_ sender: AnyObject) {
        if let duration = self.videoPlayerView.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(self.videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            self.videoPlayerView.player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // do something later here
            })
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: AnyObject) {
        // code to send like to service
    }
    
    @IBAction func watchLaterButtonPressed(_ sender: AnyObject) {
        // code to add the video to watch later with video ID
    }
    
    @IBAction func downloadButtonPressed(_ sender: AnyObject) {
        // code to start downloading the video for offline viewing
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        // display activity view controller, so that users can share the video link through apps that can share, email and also be able to copy link (ceflix link)
    }
    @IBAction func minimize(_ sender: UIButton) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
        self.commentTextField.resignFirstResponder()
    }
    
    @IBAction func goFullScreenButtonPressed(_ sender: UIButton) {
        // add code to make videoPlayerView fill the screen
        // if it's an animation, put it into a method and also call it in orientation did change to landscape.
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.videoPlayer?.pause()
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.commentTextField.resignFirstResponder()
        
    }
    
    @IBAction func postCommentPressed(_ sender: AnyObject) {
        self.postCommentButton.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.doSomething()
    }
    
    func doSomething() {
        
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 10)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.postCommentButton.isHidden = false
            }
        }
    }
    
    var isHidingControls = false
    
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        
        self.videoLoadingIndicator.startAnimating()
        self.videoLoadingIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async(execute: {
            // self.setupPlayerView()
            // self.tableView.reloadData()
            })
        self.setupGradientLayer()
        
        self.playButton.isHidden = true
        self.videoSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        tableViewFooter.isHidden = true
        
        // controls container view hiding and appearing
        self.controlsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapControls)))
        
    }
    
    func tapControls() {
        isHidingControls = !isHidingControls
        animateControls()
    }
    
    func animateControls() {
        if isHidingControls {
            UIView.animate(withDuration: 0.25, animations: { 
                self.controlsContainerView.subviews.forEach {$0.alpha = 0}
            }, completion: { _ in
                self.controlsContainerView.subviews.forEach {$0.isHidden = true}
            })
        }
        else {
            self.controlsContainerView.subviews.forEach {$0.isHidden = true}
            UIView.animate(withDuration: 0.25, animations: { 
                self.controlsContainerView.subviews.forEach {$0.alpha = 1}
            }, completion: { _ in
                if #available(iOS 10.0, *) {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                        guard self?.isHidingControls == false else {
                            return
                        }
                        self?.isHidingControls = true
                        self?.animateControls()
                    }
                } else {
                    // Fallback on earlier versions
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.playButton.layer.cornerRadius = 0.5 * self.playButton.bounds.size.width
        self.playButton.clipsToBounds = true
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    func setupPlayerView() {
        self.videoUrl = URL(string: (self.video?.videoURL)!)
        print(self.videoUrl as Any)
        if  (self.videoUrl != nil) {
            if (self.videoPlayerView.player != nil) {
                self.videoPlayerView.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
            }
            self.videoPlayer = AVPlayer.init(url: self.videoUrl!)
            self.videoPlayerView.player = self.videoPlayer
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "Error", message:"Video failed to load", preferredStyle: .alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.state != .hidden {
            self.videoPlayerView.player?.play()
        }
        
        self.videoPlayerView.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        // track player's progress
        let interval = CMTime(value: 1, timescale: 2)
        
        self.videoPlayerView.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(seconds / 60))
            // print(secondsString)
            
            self.videoTimeLabel.text = "\(minutesString):\(secondsString)"
            
            // move the slider's thumb
            if let duration = self.videoPlayerView.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSeconds)
            }
        })
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientLayer.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // this is when the player is ready and rendering frames -- currentItem.playbackLikelyToKeepUp
        if keyPath == "currentItem.loadedTimeRanges" {
            self.videoLoadingIndicator.stopAnimating()
            self.playButton.isHidden = false
            self.controlsContainerView.backgroundColor = .clear
            isPlaying = true
            
            if let duration = self.videoPlayerView.player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CFVideoPlayerController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CFVideoPlayerController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // this might be moved to viewdidappear later
        self.activityIndicator.isHidden = true
        
        // hide comment view based on selected index of segmented control
        if self.segmentedControlIndex == 0 || self.segmentedControlIndex == 2 {
            self.commentView.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // stop whatever video is playing AVPlayer.
    }
    
    deinit {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo!
        let keyboardFrame = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.bottomConstraint.constant = keyboardFrame.height
        self.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: Notification) {
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    //MARK: Table View Delegates & dataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }
        else {
            if self.segmentedControlIndex == 0 {
                return relatedVideos.count
            }
            else if self.segmentedControlIndex == 1 {
                return videoComments.count
            }
            else {
                return videoLikers.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let titleViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoTitleDetail", for: indexPath) as! CFVideoTitleDetailViewCell
                titleViewCell.configureCell(self.video)
                if !isRowHidden {
                    titleViewCell.hideDescriptionIcon.image = UIImage(named: "collapse")
                }
                return titleViewCell
            }
            else if indexPath.row == 1 {
                let descriptionDetailCell = tableView.dequeueReusableCell(withIdentifier: "descriptionDetail", for: indexPath) as! CFVideoDescriptionDetailViewCell
                descriptionDetailCell.configureCell(self.video)
                return descriptionDetailCell
                
            }
            else {
                let videoChannelDetail = tableView.dequeueReusableCell(withIdentifier: "channelDetail", for: indexPath) as! CFVideoChannelDetailViewCell
                videoChannelDetail.configureCell(self.video)
                return videoChannelDetail
                
            }
        }
        else {
            if self.segmentedControlIndex == 1 {
                let commentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CFCommentViewCell
                let comment = self.videoComments.object(at: indexPath.row) as! CFComment
                commentViewCell.configureCell(for: comment);
                return commentViewCell
            }
            else if self.segmentedControlIndex == 2 {
                let userViewCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! CFUserViewCell
                return userViewCell
            }
            else {
                let relatedVideoCell = tableView.dequeueReusableCell(withIdentifier: "RelatedVideo", for: indexPath) as! CFVideoListCell
                relatedVideoCell.delegate = self
                let relatedVideo = relatedVideos.object(at: indexPath.row) as! CFCeflixRemoteVideo
                relatedVideoCell.configureCell(forVideoList: relatedVideo)
                return relatedVideoCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            
            if indexPath.row == 0 {
                if self.isRowHidden {
                    print("First row selected")
                    self.isRowHidden = false
                    tableView.reloadSections(sectionToReload as IndexSet, with: UITableViewRowAnimation.automatic)
                }
                else {
                    self.isRowHidden = true
                    tableView.reloadSections(sectionToReload as IndexSet, with: UITableViewRowAnimation.automatic)
                }
            }
        }
    }
    
    // change this later to use expectec row height and do autorezise tableview row height in view did load
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                if self.isRowHidden {
                    return 0.0
                }
                else {
                    return 60.0;
                }
            }
            return 60.0
        }
        else {
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        else {
            let segmentedHeader = tableView.dequeueReusableCell(withIdentifier: "SegmentedHeader") as! CFSegmentedHeaderViewCell
            segmentedHeader.configureCell()
            segmentedHeader.segmentedControl.addTarget(self, action: #selector(CFVideoPlayerController.segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
            self.segmentedControlIndex = segmentedHeader.segmentedControl.selectedSegmentIndex
            return segmentedHeader
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        else {
            return 44.0
        }
    }
    
    // MARK: UITextView Delegate 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.postCommentButton.isEnabled = true
    }
    
    // MARK: Service call Methods
    
    func fetchVideoDetails() {
        self.service.getVideoDetails(withID: self.videoID as String!, success: { (videos: Any?) -> Void in
            
            self.video = (videos as! NSArray).object(at: 0) as? CFCeflixRemoteVideo
           print((self.video?.videoURL)! as String)
            
            // reload the section
            let range = NSMakeRange(0, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sectionToReload as IndexSet, with: UITableViewRowAnimation.automatic)
            
            // just adding this
            if ((self.video?.videoURL) != nil) {
                print((self.video?.videoURL)! as String)
                self.videoPlayer?.play()
                self.state = .fullScreen
                self.delegate?.didMaximize()
                self.animate()
                
                self.setupPlayerView()
            }
            else {
                let alert: UIAlertController = UIAlertController(title: "Error", message:"No URL Link for selected video", preferredStyle: .alert)
                let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            // fetch related here that is sure that fetchVideoDetails is complete
            self.fecthRelatedVideos()
            
            // fetch video comments here too
            self.fetchVideoComments()
            
            }) { (error) in
                let alert: UIAlertController = UIAlertController(title: "Error", message:"This Video failed to load", preferredStyle: .alert)
                let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                print(error?.localizedDescription as Any)
        }
    }
    
    func fecthRelatedVideos() {
        
        self.service.fetchChannelVideos(withChannelID: self.channelID as String!, success: { (channelVideos: Any!) -> Void in
            self.relatedVideos = channelVideos as! NSArray
            print(channelVideos)
            
            // reload table view section
            let range = NSMakeRange(1, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sectionToReload as IndexSet, with: .none)
            
        }) {error in
            let alert: UIAlertController = UIAlertController(title: "Error", message:"Related Videos failed to load", preferredStyle: .alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
            print(error?.localizedDescription as Any)
        }
    }
    
    func fetchVideoComments() {
        print(self.videoID as Any)
        self.service.fetchComments(forVideo: self.videoID as String!, success: { (comments: Any!) -> Void in
            self.videoComments = comments as! NSArray
            print(comments)
            
            // reload the table view section
            let range = NSMakeRange(1, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sectionToReload as IndexSet, with: UITableViewRowAnimation.automatic)

            }) { error in
                let alert: UIAlertController = UIAlertController(title: "Error", message:"Comments failed to load", preferredStyle: .alert)
                let okayAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                print(error?.localizedDescription as Any)
        }
    }
    
    // MARK: - Video List Cell Delegate
    
    func didClickOptions(at cellIndex: Int, withData data: Any!, by button: UIButton!) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.optionsMenu)
            self.optionsMenu.animate()
        }
    }
    
    // MARK: - Options Menu View Delegate
    
    func hideOptionsMenuView(status: Bool) {
        if status == true {
            self.optionsMenu.removeFromSuperview()
        }
    }

}
