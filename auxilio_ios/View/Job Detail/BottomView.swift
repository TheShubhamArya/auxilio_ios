//
//  BottomView.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/27/22.
//

import UIKit

class BottomView: UIView {
    
    private let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var saveButton : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var acceptButton : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private let middleLabel : UILabel = {
        let label = UILabel()
        label.text = "$14 per hour"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews(backgroundView,saveButton,acceptButton,middleLabel)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            saveButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            saveButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.widthAnchor.constraint(equalToConstant: 70),
            
            acceptButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            acceptButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            acceptButton.heightAnchor.constraint(equalToConstant: 70),
            acceptButton.widthAnchor.constraint(equalToConstant: 70),
            
            middleLabel.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 10),
            middleLabel.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -10),
            middleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10)
        ])
        
        configure(acceptButton, imageName: "checkmark.circle.fill", color: .systemGreen)
        configure(saveButton, imageName: "heart.circle.fill", color: .systemPink)
    }
    
    public func configure(_ button: UIButton, imageName: String, color: UIColor) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .medium)
        let largeBoldHeart = UIImage(systemName: imageName, withConfiguration: largeConfig)
        button.setImage(largeBoldHeart, for: .normal)
        button.tintColor = color
    }
    
    public func configure(with post: PostDetails) {
        middleLabel.attributedText = amountWithRatesAttributes(with: "$", for: post.amount.removeTrailingZeros, rate: " \(post.rate)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
