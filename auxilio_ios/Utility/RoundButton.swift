//
//  RoundButton.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/27/22.
//

import UIKit

class RoundButton: UIButton {
    
    let button : UIButton = {
        let btn = UIButton()
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    public func configure(imageName: String, color: UIColor) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .medium)
        let largeBoldHeart = UIImage(systemName: imageName, withConfiguration: largeConfig)
        button.setImage(largeBoldHeart, for: .normal)
        button.tintColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
