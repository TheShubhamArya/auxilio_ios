//
//  CreateButtonCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/23/22.
//

import UIKit

class CreateButtonCell: UICollectionViewCell {
    
    static let identifier = "CreateButtonCellIdentifier"
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Create Post"
        label.textColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.label
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.addSubViews(label)
        layoutElements()
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
