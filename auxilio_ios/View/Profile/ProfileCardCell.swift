//
//  ProfileCardCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

class ProfileCardCell: UICollectionViewCell {
    
    static let identifier = "ProfileCardIdentifier"
    
    private let profilePicture : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let mobileLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let emailLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    private let addressLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let editButton : UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let verticalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.leading
        sv.spacing = 5
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        
        contentView.addSubViews(verticalStack, profilePicture)
        layoutElements()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStack.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
        ])
        verticalStack.addArrangedSubview(usernameLabel)
        verticalStack.addArrangedSubview(emailLabel)
        verticalStack.addArrangedSubview(mobileLabel)
        verticalStack.addArrangedSubview(addressLabel)
        verticalStack.addArrangedSubview(editButton)
//        contentView.addSubViews(profilePicture, usernameLabel, emailLabel, mobileLabel, addressLabel, editButton)
        
    }
    
    func configure() {
        profilePicture.image = UIImage(named: "profile")
        usernameLabel.text = "Shubham Arya"
        emailLabel.text = "shubham.arya@mavs.uta.edu"
        mobileLabel.text = "682-216-7780"
        addressLabel.text = "400 Kerby St Apt 206,\nArlington, TX - 76013"
    }
    
    private func layoutElements() {
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        mobileLabel.translatesAutoresizingMaskIntoConstraints = false
//        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profilePicture.heightAnchor.constraint(equalToConstant: 150),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            
//            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            usernameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
//            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//
//            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
//            emailLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
//            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//
//            mobileLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
//            mobileLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
//            mobileLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//
//            addressLabel.topAnchor.constraint(equalTo: mobileLabel.bottomAnchor, constant: 5),
//            addressLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
//            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//
//            editButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
//            editButton.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
//            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
