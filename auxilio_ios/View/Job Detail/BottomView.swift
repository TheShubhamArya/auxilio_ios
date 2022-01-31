//
//  BottomView.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/27/22.
//

import UIKit

class BottomView: UIView {
    
    private let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let saveButton = RoundButton()
    let acceptButton = RoundButton()
    
    private let middleLabel : UILabel = {
        let label = UILabel()
        label.text = "$14 per hour"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews(backgroundView,saveButton,acceptButton,middleLabel)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            saveButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            saveButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.widthAnchor.constraint(equalToConstant: 70),
            
            acceptButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            acceptButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            acceptButton.heightAnchor.constraint(equalToConstant: 70),
            acceptButton.widthAnchor.constraint(equalToConstant: 70),
            
            middleLabel.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 10),
            middleLabel.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -10),
            middleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10)
        ])
        acceptButton.configure(imageName: "checkmark.circle.fill", color: .systemGreen)
        saveButton.configure(imageName: "heart.circle.fill", color: .systemPink)
    }
    
    public func configure() {
        middleLabel.attributedText = amountWithRatesAttributes(with: "$", for: "14", rate: " per hour")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
