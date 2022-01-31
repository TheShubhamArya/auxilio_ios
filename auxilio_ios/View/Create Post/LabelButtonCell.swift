//
//  ButtonTextFieldCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/23/22.
//

import UIKit

class LabelButtonCell: UICollectionViewCell {
    
    static let identifier = "ButtonTextFieldCell"
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Task type"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton()
        button.setTitle("Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(titleLabel, button)
        layoutElements()
    }
    
    private func layoutElements() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
