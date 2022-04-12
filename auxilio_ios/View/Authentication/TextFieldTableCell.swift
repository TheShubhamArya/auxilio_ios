//
//  TextFieldTableCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/24/22.
//

import UIKit

class TextFieldTableCell: UITableViewCell {

    static let identifier = "textFieldTableCellIdentifier"
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = UITextField.ViewMode.always
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    public func configure(with indexPath: IndexPath, type: AuthType) {
        textField.isSecureTextEntry = false
        if type == .signin {
            if indexPath.section == 0 && indexPath.row == 0 {
                textField.attributedPlaceholder = attributedPlaceholder(with: "Email", for: "envelope")
            } else if indexPath.section == 0 && indexPath.row == 1 {
                textField.isSecureTextEntry = true
                textField.attributedPlaceholder = attributedPlaceholder(with: "Password", for: "lock")
            }
        } else if type == .register {
            if indexPath.section == 0 && indexPath.row == 0 {
                textField.attributedPlaceholder = attributedPlaceholder(with: "Full name", for: "person")
            } else if indexPath.section == 0 && indexPath.row == 1 {
                textField.attributedPlaceholder = attributedPlaceholder(with: "Phone Number", for: "phone")
                textField.keyboardType = .numberPad
            } else if indexPath.section == 0 && indexPath.row == 2 {
                textField.attributedPlaceholder = attributedPlaceholder(with: "Email", for: "envelope")
                textField.keyboardType = .emailAddress
            } else if indexPath.section == 0 && indexPath.row == 3 {
                textField.isSecureTextEntry = true
                textField.attributedPlaceholder = attributedPlaceholder(with: "Password", for: "lock")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
