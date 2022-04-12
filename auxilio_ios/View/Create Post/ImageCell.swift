//
//  ImageCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let identifier = "imageCellIdentifier"
    
    private let jobImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let removeImageButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(jobImage, removeImageButton)
        layoutElements()
    }
    
    public func configure(with indexPath: IndexPath, image: UIImage?) {
        removeImageButton.alpha = indexPath.item == 0 ? 0 : 1
        if indexPath.item >= 0 {
            if let image = image {
                jobImage.image = image
            } else {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 14, weight: .thin, scale: .small)
                jobImage.image = UIImage(systemName: "plus", withConfiguration: config)
            }
        }
    }
    
    private func layoutElements() {
        jobImage.translatesAutoresizingMaskIntoConstraints = false
        removeImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            jobImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            jobImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            jobImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            removeImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            removeImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeImageButton.heightAnchor.constraint(equalToConstant: 20),
            removeImageButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
