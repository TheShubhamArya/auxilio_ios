//
//  JobPostingCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

//let jobDetails = [
//    JobDetails(name: "Cleaning", image: UIImage(named: "cleaning")!, date: "Jan 11, 2022", descripton: "I need some one to do some deep cleaning of my apartment. I have all the equipements.", amount: 15, duration: "per hour"),
//    JobDetails(name: "Cooking", image: UIImage(named: "cooking")!, date: "Jan 17, 2022", descripton: "Cooking ingredieents and items will be provided. You can eat too.", amount: 12, duration: "per hour"),
//    JobDetails(name: "Laundry", image: UIImage(named: "laundry")!, date: "Jan 14, 2022", descripton: "I have no time to do laundry so can you do my laundry. I will give you something for free", amount: 10, duration: "per hour"),
//    JobDetails(name: "Moving out", image: UIImage(named: "moving")!, date: "Jan 21, 2022", descripton: "I am moving out and need some strong person to carry the furntiture 2 floors down into the car. Need it urgent.", amount: 9, duration: "per hour"),
//    JobDetails(name: "Pick up groceries", image: UIImage(named: "groceries")!, date: "Jan 5, 2022", descripton: "Need like 20 items of groceries from any store like eggs, milk, bread, potatoes, tomatoes, etc.", amount: 20, duration: "in total"),
//    JobDetails(name: "Raspberry pi", image: UIImage(named: "raspberry_pi")!, date: "Jan 11, 2022", descripton: "Unused raspberry pi with everything in it. Prices aree negotiable plus I will give you free cardboard box.", amount: 50, duration: "One time")
//
//]

class JobPostingCell: UICollectionViewCell {
    static let identifier = "JobPostingCellIdentifier"
    
    let defaults = UserDefaults.standard
    
    public let jobImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "load-icon")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.minimumScaleFactor = 0.85
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.minimumScaleFactor = 0.85
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemBlue
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private let amountLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let saveImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(jobImageView, nameLabel, dateLabel, descriptionLabel, amountLabel, durationLabel, saveImageView)
        layoutViews()
    }
    
    func configure(for post: PostDetails, isSaved: Bool = false){
        if !post.imageURLs.isEmpty {
//            if let url = URL(string: post.imageURLs[0]) {
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: url) {
//                        DispatchQueue.main.async {
//                            self.jobImageView.image = UIImage(data: data)
//                        }
//                    }
//                }
//            }
            if !post.images.isEmpty {
                jobImageView.image = post.images.first
            } else {
                jobImageView.image = UIImage(systemName: "exclamationmark.triangle")
            }
            
        } else {
            jobImageView.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        nameLabel.text = post.name
        dateLabel.text = "By \(post.endDate)"
        descriptionLabel.text = post.description
        
        amountLabel.attributedText = attributedAmount(with: "$", for: post.amount.removeTrailingZeros)
        durationLabel.text = post.rate
        saveImageView.alpha = isSaved ? 1 : 0
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: contentView.frame.size.height, width: contentView.frame.size.width, height: 0.5)
        
        bottomLine.backgroundColor =  UIColor.secondaryLabel.cgColor
        
        contentView.layer.addSublayer(bottomLine)
    }
    
    private func layoutViews(){
        jobImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        saveImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            jobImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            jobImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            jobImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            jobImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: jobImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.5),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: jobImageView.trailingAnchor, constant: 10),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: jobImageView.trailingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3),
            
            durationLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 3),
            durationLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            durationLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 1),
            
            saveImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            saveImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            saveImageView.heightAnchor.constraint(equalToConstant: 20),
            saveImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
