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
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(statusLabel)
        layoutElements()
    }
    
    func configureStatusLabel(with post: PostDetails,isSaved: Bool = false){
        configure(for: post)
        statusLabel.text = post.postStatus
        var color = UIColor.systemYellow
        if PostStatus.drafted.rawValue == post.postStatus {
            color = UIColor.systemYellow
        } else if PostStatus.inProcess.rawValue == post.postStatus {
            color = UIColor.orange
        } else if PostStatus.completed.rawValue == post.postStatus {
            color = UIColor.systemGreen
        } else if PostStatus.notPicked.rawValue == post.postStatus {
            color = UIColor.systemBlue
        } else if PostStatus.error.rawValue == post.postStatus {
            color = UIColor.systemRed
        }
        statusLabel.backgroundColor = color
        statusLabel.alpha = isSaved ? 0 : 1
    }
    
    func layoutElements() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: jobImageView.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: jobImageView.leadingAnchor, constant: 3),
            statusLabel.trailingAnchor.constraint(equalTo: jobImageView.trailingAnchor, constant: -3),
            statusLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
