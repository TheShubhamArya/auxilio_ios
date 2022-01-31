//
//  DateCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    static let identifier = "dateCellIdentifier"
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(label, datePicker)
        layoutElements()
    }
    
    public func configure(with indexPath: IndexPath) {
        if indexPath.section == 4 {
            label.text = "Start Date"
        } else {
            label.text = "End Date"
        }
    }
    
    private func layoutElements() {
        label.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
