//
//  CFOptionsMenu.swift
//  Ceflix
//
//  Created by Tobi Omotayo on 31/10/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

import UIKit

@objc protocol CFOptionsMenuDelegate {
    func hideOptionsMenuView(status: Bool)
}

@objc class CFOptionsMenu: UIView, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    let items = ["Like", "Download", "Add to Watch Later", "Share", "Cancel"]
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: self.bounds.height, width: self.bounds.width, height: 340))
        tb.isScrollEnabled = false
        return tb
    }()
    
    lazy var backgroundView: UIView = {
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.black
        bv.alpha = 0
        return bv
    }()
    
    lazy var headerView: UIView = {
        let hv = UIView.init(frame: self.frame)
        return hv
    }()
    
    lazy var thumbnailView: UIView = {
        let tv = UIView(frame: CGRect(x: 15, y: 10, width: 140, height: 80))
        return tv
    }()
    
    lazy var thumbnail: UIImageView = {
        let thumbnail = UIImageView(frame: CGRect(x: 15, y: 10, width: 140, height: 80))
        thumbnail.image = UIImage(named: "sample")
        return thumbnail
    }()
    
    lazy var tagView: UIView = {
        let tagView = UIView(frame: CGRect(x: 5, y: 55, width: 60, height: 20))
        return tagView
    }()
    
    lazy var playIcon: UIImageView = {
        let playIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        playIcon.image = UIImage(named: "play_tag")
        return playIcon
    }()
    
    lazy var durationLabel: UILabel = {
        let durationLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 40, height: 20))
        durationLabel.textColor = .white
        durationLabel.backgroundColor = .red
        return durationLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 168, y: 10, width: 196, height: 40))
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel(frame: CGRect(x: 168, y: 38, width: 196, height: 30))
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    lazy var viewsLabel: UILabel = {
        let viewsLabel = UILabel(frame: CGRect(x: 168, y: 76, width: 196, height: 12))
        viewsLabel.textColor = .gray
        return viewsLabel
    }()
    
    var delegate: CFOptionsMenuDelegate?
    
    //MARK: Methods
    func animate()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame.origin.y -= 340
            self.backgroundView.alpha = 0.5
        })
    }
    
    func  dismiss()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.tableView.frame.origin.y += 340
        }, completion: {(Bool) in
            self.delegate?.hideOptionsMenuView(status: true)
        })
    }
    
    //MARK: TableView Delegate, DataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = items[indexPath.row]
            cell.imageView?.image = UIImage.init(named:"like_black")
            cell.backgroundColor = .white
        case 1:
            cell.textLabel?.text = items[indexPath.row]
            cell.imageView?.image = UIImage.init(named:"download_black")
            cell.backgroundColor = .white
        case 2:
            cell.textLabel?.text = items[indexPath.row]
            cell.imageView?.image = UIImage.init(named:"watchLater_black")
            cell.backgroundColor = .white
        case 3:
            cell.textLabel?.text = items[indexPath.row]
            cell.imageView?.image = UIImage.init(named:"share_black")
            cell.backgroundColor = .white
        default:
            cell.textLabel?.text = items[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(colorLiteralRed: 233/255, green: 234/255, blue: 238/255, alpha: 1)
        }
        cell.selectionStyle = .gray
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            dismiss()
        }
        else {
            dismiss()
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerView.addSubview(thumbnailView)
        self.headerView.addSubview(titleLabel)
        self.headerView.addSubview(descriptionLabel)
        self.headerView.addSubview(viewsLabel)
        self.thumbnailView.addSubview(thumbnail)
        self.thumbnailView.addSubview(tagView)
        self.tagView.addSubview(playIcon)
        self.tagView.addSubview(durationLabel)
        
        return headerView
    }

    //Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CFOptionsMenu.dismiss)))
        self.addSubview(self.backgroundView)
        self.addSubview(tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // self.tableView.separatorStyle = .singleLine
    }

}
