//
//  TutorialCell.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 6/4/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
    var displayTitle: UITextView = UITextView()
    var displayImage: UIImageView = UIImageView()
    var displayMessage: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red:0.29, green:0.70, blue:0.40, alpha:1.0)
    }
    
    func setupLayout() {

        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        topImageContainerView.topAnchor.constraint(equalTo: displayTitle.bottomAnchor).isActive = true

        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        topImageContainerView.addSubview(displayImage)
        displayImage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        displayImage.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        displayImage.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true

        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        
        addSubview(displayTitle)
        displayTitle.translatesAutoresizingMaskIntoConstraints = false
        displayTitle.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        displayTitle.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        displayTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        displayTitle.widthAnchor.constraint(equalToConstant: frame.width - 100).isActive = true
        displayTitle.textColor = .white
        displayTitle.backgroundColor = .clear
        displayTitle.textAlignment = .center
        displayTitle.isScrollEnabled = false
        displayTitle.isEditable = false
        displayTitle.font = .systemFont(ofSize: 30)
        
        addSubview(displayMessage)
        displayMessage.translatesAutoresizingMaskIntoConstraints = false
        displayMessage.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: -50).isActive = true
        displayMessage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        displayMessage.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        displayMessage.widthAnchor.constraint(equalToConstant: frame.width - 100).isActive = true
        displayMessage.textColor = .white
        displayMessage.backgroundColor = .clear
        displayMessage.textAlignment = .center
        displayMessage.isScrollEnabled = false
        displayMessage.isEditable = false
        displayMessage.font = .systemFont(ofSize: 18)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
