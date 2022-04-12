//
//  JobDetailVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/25/22.
//

import UIKit
import Firebase
import MessageUI

protocol JobPickedDelegate {
    func didPickJob(_ isPicked: Bool)
}

class JobDetailVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    var collectionView : UICollectionView!
    let bottomView = BottomView()
    var post : PostDetails!
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var jobPickedDelegate : JobPickedDelegate!
    let userInfo = UserDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = .systemBackground
        setupNavbar()
        setupCollectionView()
        if post.pickedBy == "none" {
            layoutBottomView()
        } else {
            getUserInformation()
        }
    }
    
    func layoutBottomView() {
        updateSaveButtonState()
        bottomView.acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        bottomView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100)
        ])
        bottomView.configure(with: post)
    }
    
    func updateSaveButtonState() {
        if AllPosts.savedPosts.contains(post.post_id) {
            bottomView.configure(bottomView.saveButton, imageName: "heart.slash", color: .systemRed)
        } else {
            bottomView.configure(bottomView.saveButton, imageName: "heart", color: .systemRed)
        }
    }
    
    @objc func saveButtonTapped() {
        if !AllPosts.savedPosts.contains(post.post_id) {
            AllPosts.savedPosts.append(post.post_id)
        } else {
            AllPosts.savedPosts.removeAll { post_id in
                post_id == post.post_id
            }
            alert(title: "Unsaved", message: "This post has been removed from your liked list.")
        }
        
        let currentUser = db.collection(User.collectionName).document(auth.currentUser!.uid)
        currentUser.updateData([
            User.postsSaved: AllPosts.savedPosts
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.alert(title: "Saved", message: "This post has been saved for you.")
                self.updateSaveButtonState()
            }
        }
    }
    
    @objc func acceptButtonTapped() {
        let alert = UIAlertController(title: "Accept job", message: "Do you want to accept this job?", preferredStyle: .alert)
        let accept = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.jobPickedByUser()
        }
        let decline = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(accept)
        alert.addAction(decline)
        present(alert, animated: true, completion: nil)
        
    }
    
    func jobPickedByUser() {
        AllPosts.pickedPosts.append(post.post_id)
//        let currentUser = db.collection(User.collectionName).document(auth.currentUser!.uid)
//        currentUser.updateData([
//            User.postsPicked: AllPosts.pickedPosts
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
        
        let currentPost = db.collection(Post.collectionName).document(post.post_id)
        currentPost.updateData([:
//            Post.pickedBy : auth.currentUser!.uid,
//            Post.postStatus : PostStatus.inProcess.rawValue
        ]) { [weak self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self?.exitJobDetail()
                self?.bottomView.alpha = 0
                self?.getUserInformation()
            }
        }
    }
    
    func getUserInformation() {
        let userID = post.postedBy
        let docRef = db.collection(User.collectionName).document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let email = data?[User.email] as? String,
                   let phone = data?[User.mobile] as? String,
                   let userImageURL = data?[User.imageURL] as? String,
                   let name = data?[User.name] as? String{
                    
                    self.userInfo.email = email
                    self.userInfo.mobile = phone
                    self.userInfo.imageURL = userImageURL
                    self.userInfo.address = self.post.location
                    self.userInfo.name = name
                    self.configureUserInfoView()
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func configureUserInfoView() {
        let userInfoView = UserInfoView()
        userInfoView.emailButton.addTarget(self, action: #selector(emailUserAction), for: .touchUpInside)
        userInfoView.callButton.addTarget(self, action: #selector(callUserAction), for: .touchUpInside)
        view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.heightAnchor.constraint(equalToConstant: 120)
        ])
        userInfoView.configure(with: userInfo)
    }
    
    @objc func callUserAction() {
        if let phoneCallURL = URL(string: "tel://\(userInfo.mobile)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        } else {
            alert(title: "Error", message: "Something wrong with the number. Report concern.")
        }
    }
    
    @objc func emailUserAction() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([userInfo.email])
            let emailBody = """
                <h2>Hello \(userInfo.name),</h2>
            """
            mail.setMessageBody(emailBody, isHTML: true)

            present(mail, animated: true)
        } else {
            alert(title: "Error", message: "You cannot send emails.")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func exitJobDetail() {
        jobPickedDelegate.didPickJob(true)
    }
    
    func setupNavbar() {
        self.title = "Service Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.bubble"), style: .plain, target: self, action: #selector(reportConcern))
    }
    
    @objc func reportConcern() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["shubhamarya11099@gmail.com"])
            mail.setMessageBody("<h3>Report your concerns below: </h3>", isHTML: true)

            present(mail, animated: true)
        } else {
            alert(title: "Error", message: "You cannot send emails.")
        }
    }
}

extension JobDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(JobImageCell.self, forCellWithReuseIdentifier: JobImageCell.identifier)
        collectionView.register(DetailLabelCell.self, forCellWithReuseIdentifier: DetailLabelCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {return post.imageURLs.count}
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobImageCell.identifier, for: indexPath) as? JobImageCell else {return UICollectionViewCell()}
            cell.configure(for: post.imageURLs[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLabelCell.identifier, for: indexPath) as? DetailLabelCell else {return UICollectionViewCell()}
            cell.configure(with: post)
            return cell
        }
    }
    
    func createLayoutDiffSection() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 1{
                let estimatedHeight = CGFloat(100)
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                section.interGroupSpacing = 10
                return section
            }
            
            var columns = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
            
            var groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.50)
            var groupWidth =  NSCollectionLayoutDimension.fractionalWidth(0.9)
            
            if sectionIndex == 0 {
                groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.45)
                groupWidth =  NSCollectionLayoutDimension.fractionalWidth(0.95)
            } else if sectionIndex == 1{
                groupHeight = NSCollectionLayoutDimension.estimated(100)
            }
            
            if self.collectionView.frame.size.width > 500 || self.collectionView.frame.size.height > 1000{
                groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.1)
                groupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
                columns = 2
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            
            if sectionIndex == 0 {
                section.orthogonalScrollingBehavior = .groupPaging
            }
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 8, bottom: 5, trailing: 8)
            if sectionIndex != 0 {
                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
                section.boundarySupplementaryItems = [layoutSectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            }
            return section
        }
        return layout
    }
    
    private func createSectionHeader(with section: Int) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(45))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
}
