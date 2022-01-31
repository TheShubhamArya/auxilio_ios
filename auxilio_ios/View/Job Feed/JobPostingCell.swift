//
//  JobPostingCell.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/4/22.
//

import UIKit

class JobPostingCell: UICollectionViewCell {
    static let identifier = "JobPostingCellIdentifier"
    
    let defaults = UserDefaults.standard
    
    public let jobImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.minimumScaleFactor = 0.85
        label.adjustsFontSizeToFitWidth = true
//        label.backgroundColor = .systemGreen
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.minimumScaleFactor = 0.85
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemBlue
//        label.backgroundColor = .systemRed
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
//        label.backgroundColor = .blue
        return label
    }()
    
    private let amountLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
//        label.backgroundColor = .systemPink
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(jobImageView, nameLabel, dateLabel, descriptionLabel, amountLabel, durationLabel)
        layoutViews()
    }
    
    func configure(at indexPath: IndexPath){
        let job = jobDetails[indexPath.row]
        jobImageView.image = job.image
        nameLabel.text = job.name
        dateLabel.text = "Do by \(job.date)"
        descriptionLabel.text = "I need some one to do some deep cleaning of my apartment. I have all the equipements."
        
        amountLabel.attributedText = attributedAmount(with: "$", for: job.amount.removeTrailingZeros)
        durationLabel.text = jobDetails[indexPath.row].duration
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
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3),
            
            durationLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 3),
            durationLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            durationLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let jobDetails = [
        JobDetails(name: "Cleaning", image: UIImage(named: "cleaning")!, date: "Jan 11, 2022", descripton: "", amount: 15, duration: "per hour"),
        JobDetails(name: "Cooking", image: UIImage(named: "cooking")!, date: "Jan 17, 2022", descripton: "", amount: 12, duration: "per hour"),
        JobDetails(name: "Laundry", image: UIImage(named: "laundry")!, date: "Jan 14, 2022", descripton: "", amount: 10, duration: "per hour"),
        JobDetails(name: "Moving out", image: UIImage(named: "moving")!, date: "Jan 21, 2022", descripton: "", amount: 9, duration: "per hour"),
        JobDetails(name: "Pick up groceries", image: UIImage(named: "groceries")!, date: "Jan 5, 2022", descripton: "", amount: 20, duration: "in total"),
        JobDetails(name: "Cleaning", image: UIImage(named: "cleaning")!, date: "Jan 11, 2022", descripton: "", amount: 15, duration: "per hour")

    ]
    
}
