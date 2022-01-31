//
//  HomeInfoCells.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/5/22.
//

import UIKit

class HomeInfoCell: UICollectionViewCell {
    
    static let identifier = "HomeInfoCellIdentifier"
    
    let info = [
        [
            HomeModel(section: .benefits, header: "Cost Effective", subheader: "We hope to provide services at a much cheaper cost compared to competitors because the services will be provided by students. Professional services tend to be very expensive and unaffordable for students.", image: "https://paramountbank.com/wp-content/uploads/2020/09/saving_money_square.jpg"),
            HomeModel(section: .benefits, header: "Time Convenience", subheader: "No need to waste time searching for jobs or goods online with quick and easy search and filters in Auxilio. Get your work done by someone else and utilize that time to do something productive.", image: "https://images.wsj.net/im-159769?width=1280&size=1"),
            HomeModel(section: .benefits, header: "Additional Income", subheader: "Since students service other students, get a chance to earn some extra cash every month by picking up jobs or selling your goods. Pick them at your convenience and help the community.", image: "https://previews.123rf.com/images/tankist276/tankist2761203/tankist276120300263/13002202-background-of-very-many-mass-currency-note-dollars-square-photo.jpg")
        ],
        [
            HomeModel(section: .customer, header: "Why join us?", subheader: "As students on campus, you will be able to get the much needed assistance from your peers on campus for a much cheaper price. All the benefits are too good to miss.", image: "https://voyado.com/wp-content/uploads/2021/05/man_computer_happy-min-1200x1200.jpg"),
            HomeModel(section: .customer, header: "How we help?", subheader: "We help people connect! Through Auxilio, we help connect people who need help with people who want to help in exchange of some money.", image: "https://www.pngkit.com/png/detail/847-8472670_increasing-community-connections-social-relations-icon.png"),
            HomeModel(section: .customer, header: "What you need to do?", subheader: "If you have not already, sign up! Once you do that, post a job you need to get done or a good you want to sell, or pick up a job or buy a good from the job feed.", image: "https://media.istockphoto.com/vectors/businessman-standing-in-the-direction-of-the-crossroads-chose-the-vector-id1164101981?k=20&m=1164101981&s=612x612&w=0&h=L4HhHklSnP-TxCMTDWYVHV9mh6gPJhRJw7pMJsxdC4o=")
        ],
        [
            HomeModel(section: .serviceProvider, header: "How you earn money?", subheader: "Once you complete a job or sell a good, you can contact the customer how they would like to get paid. The best part? Auxilio does not take any commission from the service provider so it is all your money.", image: "https://www.thestreet.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY3NTM5MzU2OTQyNTQyNzM0/circor-shares-soar-on-cranes-17-billion-buyout-offer.jpg"),
            HomeModel(section: .serviceProvider, header: "How does it work?", subheader: "", image: ""),
            HomeModel(section: .serviceProvider, header: "Why us?", subheader: "", image: "")
        ],
        [
            HomeModel(section: .aboutUs, header: "Who are we?", subheader: "Just a bunch of college students looking to help other college students around campus. We are seniors at the University of Texas at Arlington majoring in Computer Science.", image: "https://cdn.web.uta.edu/-/media/project/website/general/uta-link-preview.ashx?revision=aa44075d-8f8c-4c1e-a916-b3d1ebc1449e"),
            HomeModel(section: .aboutUs, header: "Our aim", subheader: "", image: ""),
            HomeModel(section: .aboutUs, header: "The creators", subheader: "", image: "")
        ]
        
    ]
    
    private let headingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let heroImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        label.textAlignment = .justified
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(headingLabel,heroImage,descriptionLabel)
        layoutElements()
    }
    
    public func configure(at indexPath: IndexPath) {
        headingLabel.text = info[indexPath.section - 1][indexPath.row].header
        let urlString = info[indexPath.section - 1][indexPath.row].image
        descriptionLabel.text = info[indexPath.section - 1][indexPath.row].subheader
        
        let url = URL(string: urlString) ?? URL(string: "https://miro.medium.com/max/880/0*H3jZONKqRuAAeHnG.jpg")

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.heroImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func layoutElements() {
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            headingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headingLabel.heightAnchor.constraint(equalToConstant: 30),
            
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            heroImage.widthAnchor.constraint(equalToConstant: 100),
            heroImage.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            heroImage.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
