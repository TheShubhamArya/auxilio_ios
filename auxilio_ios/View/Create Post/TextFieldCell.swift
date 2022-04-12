//
//  TextFieldCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit

class TextFieldCell: UICollectionViewCell {

    static let identifier = "textFieldCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(label,textField)
        layoutElements()
    }
    
    public func configure(with indexPath: IndexPath, _ content: PostDetails) {
        textField.textColor = .secondaryLabel
        textField.keyboardType = .default
        if indexPath.row == 0 && indexPath.section == 0 {
            label.text = "Name"
            textField.placeholder = "Enter job title here"
            textField.text = content.name
        } else if indexPath.section == 2 {
            label.text = "Amount"
            textField.placeholder = "$0.00"
            textField.keyboardType = .decimalPad
            if content.amount == 0 {
                textField.text = ""
            }
        } else if indexPath.section == 3 {
            label.text = "Rate for amount"
            textField.placeholder = "Eg. per hour"
            textField.text = content.rate
        } else if indexPath.section == 8 {
            label.text = "Location"
            textField.placeholder = "Enter your address"
            textField.textColor = .systemBlue
            textField.text = content.location
        }
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
