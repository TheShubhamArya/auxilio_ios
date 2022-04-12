//
//  DetailLabelCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/27/22.
//

import UIKit

class DetailLabelCell: UICollectionViewCell {
    
    static let identifier = "DetailLabelCellIdentifier"
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let datesLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemBlue
        return label
    }()
    
    private let verticalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.leading
        sv.spacing = 10
        return sv
    }()
    
    private let privacyDescriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
        label.numberOfLines = 0
        label.text = "The location and contact information of the user will be able once you accept the job."
        return label
    }()
    
    private let userProfileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(descriptionLabel)
        verticalStack.addArrangedSubview(datesLabel)
        verticalStack.addArrangedSubview(privacyDescriptionLabel)
    }
    
    public func configure(with post: PostDetails) {
        titleLabel.text = post.name
        descriptionLabel.text = post.description
        datesLabel.text = "\(post.startDate) to \(post.endDate)"
        if post.pickedBy != "none" {
            privacyDescriptionLabel.removeFromSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
