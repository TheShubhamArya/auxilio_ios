//
//  UserInfoView.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 4/12/22.
//

import UIKit

class UserInfoView: UIView {

    private let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var callButton : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var emailButton : UIButton = {
        let btn = UIButton()
        return btn
    }()

    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size.height = 50
        imageView.frame.size.width = 50
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let addressLabel : UILabel = {
        let label = UILabel()
        label.text = "Address of the user"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBlue
        return label
    }()
    
    private let verticalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fillProportionally
        sv.alignment = UIStackView.Alignment.leading
        sv.spacing = 3
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews(backgroundView,callButton,emailButton, profileImageView, verticalStack)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        callButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            callButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            callButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            callButton.heightAnchor.constraint(equalToConstant: 40),
            callButton.widthAnchor.constraint(equalToConstant: 40),
            
            emailButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            emailButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            emailButton.heightAnchor.constraint(equalToConstant: 40),
            emailButton.widthAnchor.constraint(equalToConstant: 40),
            
            profileImageView.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: callButton.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            
            verticalStack.centerYAnchor.constraint(equalTo: callButton.centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant: -20)
            
        ])
        
        verticalStack.addArrangedSubview(usernameLabel)
        verticalStack.addArrangedSubview(addressLabel)
        
        configure(emailButton, imageName: "envelope.fill", color: .systemBlue)
        configure(callButton, imageName: "phone.fill", color: .systemGreen)
    }
    
    public func configure(_ button: UIButton, imageName: String, color: UIColor) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .medium)
        let largeBoldHeart = UIImage(systemName: imageName, withConfiguration: largeConfig)
        button.setImage(largeBoldHeart, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = color
    }
    
    public func configure(with userInfo : UserDetails) {
        usernameLabel.text = userInfo.name
        addressLabel.text = userInfo.address
//        if let url = URL(string: userInfo.imageURL) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.profileImageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
