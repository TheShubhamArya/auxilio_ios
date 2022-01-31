//
//  DetailLabelCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/27/22.
//

import UIKit

class DetailLabelCell: UICollectionViewCell {
    
    static let identifier = "DetailLabelCellIdentifier"
    
//    private let titleLabel : UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = "Something short for now Something short for now Something short for now Something short for now  Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for now  Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for now  Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no Something short for now Something short for now Something short for now Something short for no"
//        return label
//    }()
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Description Something short for now Something short for now Something short for now Something short for now  Something short for now Something short for now. Description Something short for now Something short for now Something short for now Something short for now  Something short for now Something short for now."
        return label
    }()
    
    private let datesLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemBlue
        label.text = "Jan 20, 2022 at 8:00pm to Jan 27, 2022 at 8pm"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
