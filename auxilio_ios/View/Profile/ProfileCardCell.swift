//
//  ProfileCardCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit
import Firebase

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
    }
    
    func configure(with user: UserDetails) {
        if profilePicture.image == nil {
            profilePicture.image = UIImage(systemName: "person")?.withTintColor(.systemGray)
        }
//        if let url = URL(string: user.imageURL) {
//            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//                if let data = data, error == nil {
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        let image = UIImage(data: data)
//                        self.profilePicture.image = image
//                    })
//                }
//            })
//            task.resume()
//        }
        usernameLabel.text = user.name
        emailLabel.text = user.email
        mobileLabel.text = user.mobile
        addressLabel.text = user.address
    }
    
    private func layoutElements() {
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profilePicture.heightAnchor.constraint(equalToConstant: 100),
            profilePicture.widthAnchor.constraint(equalToConstant: 100),
            editButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
