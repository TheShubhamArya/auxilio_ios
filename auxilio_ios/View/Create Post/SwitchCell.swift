//
//  SwitchCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/23/22.
//

import UIKit

class SwitchCell: UICollectionViewCell {
    
    static let identifier = "LabelSwitchCellIdentifier"
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "By turning it on, you agree to share your location and contact information with a service provider or buyer when they accept your post request."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let privacySwitch : UISwitch = {
        let privacySwitch = UISwitch()
        privacySwitch.onTintColor = .secondarySystemFill
        return privacySwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(label, privacySwitch)
        layoutElements()
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        privacySwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privacySwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            privacySwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            privacySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            privacySwitch.widthAnchor.constraint(equalToConstant: 50),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: privacySwitch.leadingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
