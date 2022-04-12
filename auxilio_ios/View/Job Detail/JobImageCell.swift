//
//  JobImageCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/25/22.
//

import UIKit

class JobImageCell: UICollectionViewCell {
    
    static let identifier = "jobImageCellIdentifier"
    
    private let jobImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(jobImage)
        jobImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            jobImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            jobImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            jobImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)  
        ])
    }
    
    public func configure(for urlString: String) {
        print("url for image is \(urlString)")
//        if let url = URL(string: urlString) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.jobImage.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
