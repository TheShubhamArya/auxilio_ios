//
//  UserJobPostingCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/5/22.
//

import UIKit

enum JobStatus {
    case notAccepted
    case inProgress
    case completed
    case error
}

class UserJobPostingCell: JobPostingCell {
    
    let statusLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 7.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(statusLabel)
        layoutElements()
    }
    
    func configureStatusLabel(at indexPath: IndexPath){
        configure(at: indexPath)
        statusLabel.text = "Completed"
        statusLabel.backgroundColor = .systemGreen
        
    }
    
    func layoutElements() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: jobImageView.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: jobImageView.leadingAnchor, constant: -5),
            statusLabel.trailingAnchor.constraint(equalTo: jobImageView.trailingAnchor, constant: 5),
            statusLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
