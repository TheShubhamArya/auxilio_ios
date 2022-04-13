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
    func didPickJob(_ isPicked: Bool,removeFrom indexPath: IndexPath)
    func didChangePostStatus(for post: PostDetails,updateAt indexPath: IndexPath)
}

class JobDetailVC: UIViewController{
    
    var collectionView : UICollectionView!
    let bottomView = BottomView()
    var post : PostDetails!
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var jobPickedDelegate : JobPickedDelegate!
    let userInfo = UserDetails()
    var indexPath : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = .systemBackground
        setupNavbar()
        setupCollectionView()
        
        for urlString in post.imageURLs {
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data){
                            DispatchQueue.main.async {
                                self.post.images.append(image)
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        let currentUserID = auth.currentUser!.uid
        if currentUserID == post.postedBy {
            // User posted the job. Show picked by user if available. Dont show option to pick or save
            if post.pickedBy != "none" {
                getUserInformation(with: post.pickedBy!)
            }
        } else if currentUserID == post.pickedBy {
            // User picked this job. Show job poster info
            if post.postedBy != "none" {
                getUserInformation(with: post.postedBy)
            }
        } else { // if job is neither picked, nor posted by user
            layoutBottomView()
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
        let currentUser = db.collection(User.collectionName).document(auth.currentUser!.uid)
        currentUser.updateData([
            User.postsPicked: AllPosts.pickedPosts
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        let currentPost = db.collection(Post.collectionName).document(post.post_id)
        currentPost.updateData([
            Post.pickedBy : auth.currentUser!.uid,
            Post.postStatus : PostStatus.inProcess.rawValue
        ]) { [weak self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self?.exitJobDetail()
                self?.bottomView.alpha = 0
                self?.getUserInformation(with: (self?.post.postedBy)!)
            }
        }
    }
    
    func getUserInformation(with userID: String) {
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
        userInfoView.moreInfoButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
    
    @objc func moreButtonTapped() {
        let actionSheet = UIAlertController(title: "Information", message: "", preferredStyle: .actionSheet)
        
        let email = UIAlertAction(title: "Email", style: .default) { [weak self] _ in
            self?.emailUserAction()
        }
        
        let mobile = UIAlertAction(title: "Mobile", style: .default) {[weak self] _ in
            self?.callUserAction()
        }
        
        let changeStatus = UIAlertAction(title: "Change Status", style: .default) {[weak self] _ in
            self?.changePostStatusAction()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(email)
        actionSheet.addAction(mobile)
        actionSheet.addAction(changeStatus)
        actionSheet.addAction(cancel)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverPresentationController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    func changePostStatusAction() {
        let actionSheet = UIAlertController(title: "Change status of post", message: "Both the service provider and the post creator can change post status. It is recommended that both parties discuss change of status before changing status.", preferredStyle: .actionSheet)
        
        let completed = UIAlertAction(title: "Completed", style: .default) { [weak self] _ in
            self?.updateStatusOfPost(with: .completed)
        }
        
        let inProcess = UIAlertAction(title: "In process", style: .default) {[weak self] _ in
            self?.updateStatusOfPost(with: .inProcess)
        }
        
        let error = UIAlertAction(title: "There was some error", style: .default) {[weak self] _ in
            self?.updateStatusOfPost(with: .error)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(completed)
        actionSheet.addAction(inProcess)
        actionSheet.addAction(error)
        actionSheet.addAction(cancel)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverPresentationController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    func updateStatusOfPost(with newStatus: PostStatus) {
        let currentPost = db.collection(Post.collectionName).document(post.post_id)
        post.postStatus = newStatus.rawValue
        jobPickedDelegate.didChangePostStatus(for: post, updateAt: indexPath)
        currentPost.updateData([
            Post.postStatus : newStatus.rawValue
        ]) { [weak self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self?.alert(title: "Success!", message: "Post Status successfully changed")
            }
        }
    }
    
    func exitJobDetail() {
        jobPickedDelegate.didPickJob(true, removeFrom: indexPath)
    }
    
    func setupNavbar() {
        self.title = "Service Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.bubble"), style: .plain, target: self, action: #selector(reportConcern))
    }
    
}

//MARK: - Colletion view delegates
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
        if section == 0 {return post.images.count}
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
            cell.jobImage.image = post.images[indexPath.item]
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

//MARK: - Contact details and actions
extension JobDetailVC : MFMailComposeViewControllerDelegate {
    
    func callUserAction() {
        if let phoneCallURL = URL(string: "tel://\(userInfo.mobile)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        } else {
            alert(title: "Error", message: "Something wrong with the number. Report concern.")
        }
    }
    
    func emailUserAction() {
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
