//
//  TextCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    static let identifier = "simpleTextCell"
    
    private let label : UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        layoutElements()
    }
    
    public func configure(with indexPath: IndexPath){
        if indexPath.section == 6 {
            let attributesTitle: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            let attributesSubtitle: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.secondaryLabel,
                .font: UIFont.systemFont(ofSize: 15, weight: .light)
            ]
            let attributedString = NSMutableAttributedString(string: "Add image ", attributes: attributesTitle)
            let subString = NSAttributedString(string: "(at least one)", attributes: attributesSubtitle)
            attributedString.append(subString)
            label.attributedText = attributedString
        }
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
