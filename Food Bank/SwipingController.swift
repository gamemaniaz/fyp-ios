//
//  SwipingController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 6/4/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let titles = ["Welcome to Foodbank!", "Inventorising Process", "Packing Process"]
    let images = [#imageLiteral(resourceName: "Box"), UIImage.gif(name: "scanner_FIT_v2")!, UIImage.gif(name: "packing_FIT_v2")!]
    let messages = ["Learning how to inventorise and pack with these simple steps", "Check the barcodes to see if they match!", "Do not be alarmed, concurrent packing may occur during the process"]
    var skipButton: UIButton = UIButton(type: .system)
    
    var progressPoint1: UIButton = UIButton()
    var progressPoint2: UIButton = UIButton()
    var progressPoint3: UIButton = UIButton()
    
    let inactiveColor: UIColor = UIColor(red:0.50, green:0.79, blue:0.58, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(red:0.29, green:0.70, blue:0.40, alpha:1.0)
        collectionView?.register(TutorialCell.self, forCellWithReuseIdentifier: "tutorialCell")
        collectionView?.isPagingEnabled = true
        
        initProgressPoints()
        
        skipButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - 50, width: 90, height: 30)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.tintColor = .white
        skipButton.titleLabel?.font = .systemFont(ofSize: 18)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        view.addSubview(skipButton)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        progressPoint1.backgroundColor = inactiveColor
        progressPoint2.backgroundColor = inactiveColor
        progressPoint3.backgroundColor = inactiveColor
        if currentPage == 0 {
            progressPoint1.backgroundColor = .white
        } else if currentPage == 1 {
            progressPoint2.backgroundColor = .white
        } else if currentPage == 2 {
            progressPoint3.backgroundColor = .white
        }
    }
    
    @objc func skipAction (sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as! TutorialCell
        cell.displayTitle.text = titles[indexPath.row]
        cell.displayImage = {
            let imageView = UIImageView()
            imageView.image = images[indexPath.row]
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        cell.displayMessage.text = messages[indexPath.row]
        cell.setupLayout()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func initProgressPoints () {
        
        progressPoint1.isEnabled = false
        progressPoint2.isEnabled = false
        progressPoint3.isEnabled = false
        
        progressPoint1.frame = CGRect(x: view.frame.size.width / 2 - 15, y: view.frame.size.height - 60, width: 10, height: 10)
        progressPoint2.frame = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height - 60, width: 10, height: 10)
        progressPoint3.frame = CGRect(x: view.frame.size.width / 2 + 15, y: view.frame.size.height - 60, width: 10, height: 10)
        
        progressPoint1.layer.cornerRadius = 5
        progressPoint2.layer.cornerRadius = 5
        progressPoint3.layer.cornerRadius = 5
        
        progressPoint1.backgroundColor = .white
        progressPoint2.backgroundColor = inactiveColor
        progressPoint3.backgroundColor = inactiveColor
        
        view.addSubview(progressPoint1)
        view.addSubview(progressPoint2)
        view.addSubview(progressPoint3)
        
    }
    
}
