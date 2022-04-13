//
//  LabelTextViewCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 2/6/22.
//

import UIKit
import Contacts

protocol GrowingCellProtocol {
    func updateHeightOfRow(_ cell: LabelTextViewCell, _ textView: UITextView)
}

class LabelTextViewCell: UITableViewCell {

    static let identifier = "labelTextViewCellIdentifier"
    var cellDelegate: GrowingCellProtocol?
    
    private let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    public let textView : UITextView = {
        let tv = UITextView()
        tv.textAlignment = .right
        tv.bounces = false
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.isScrollEnabled = false
        tv.sizeToFit()
        return tv
    }()
    
    weak var user : UserDetails!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews(label, textView)
        layoutElements()
        textView.delegate = self
    }
    
    public func configure(for indexPath: IndexPath,_ user: UserDetails, isEditable: Bool){
        self.user = user
        let row = indexPath.row
        textView.tag = indexPath.item
        textView.keyboardType = .default
        textView.isEditable = isEditable
        if indexPath.section == 0 {
            if row == 0 {
                label.text = "Name"
                textView.text = user.name
            } else if row == 1 {
                label.text = "Mobile #"
                textView.keyboardType = .phonePad
                textView.text = user.mobile
            } else if row == 2 {
                label.text = "Address"
                textView.text = user.address
            }
        }
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalToConstant: 100),
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension LabelTextViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let tag = textView.tag
        if tag == 0 {
            user.name = textView.text
        } else if tag == 1 {
            user.mobile = textView.text
        } else if tag == 2 {
            user.address = textView.text
        }
    }
}
