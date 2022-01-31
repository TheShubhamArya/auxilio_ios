//
//  GetStartedCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/5/22.
//

import UIKit

class GetStartedCell: UICollectionViewCell {
    
    static let identifier = "gettingStartedCellIdenitifer"
    
    private let headerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
//        label.textColor = .white
        return label
    }()
    
    private let subheaderLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .secondaryLabel
        return label
    }()
    
    let signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 5
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 2.0)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        
        return button
    }()
    
    private let backgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.35
//        let angle =  CGFloat(Double.pi/2)
//        let tr = CGAffineTransform.identity.rotated(by: angle)
//        imageView.transform = tr
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        
        contentView.addSubViews(backgroundImage, headerLabel, signupButton, subheaderLabel)
        layoutElements()
    }
    
    public func configure() {
        headerLabel.text = "A marketplace for goods and service"
        subheaderLabel.text = "Post your jobs to be serviced or sell goods. Pick up jobs or buy goods from others"
        backgroundImage.image = UIImage(named: "background")
        
    }
    
    private func layoutElements() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subheaderLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -75),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subheaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            subheaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subheaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subheaderLabel.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -20),
            
            signupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            signupButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            signupButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
