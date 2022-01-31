//
//  TextViewCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit

class TextViewCell: UICollectionViewCell {
    
    static let identifier = "textViewCellIdentifier"
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "Add a description of the job"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let descriptionTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.secondaryLabel.cgColor
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 5
        tv.textColor = .secondaryLabel
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(label,descriptionTextView)
        layoutElements()
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionTextView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
