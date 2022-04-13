//
//  CreatePostCVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/6/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import PhotosUI

class CreatePostCVC: UIViewController {
    
    var collectionView : UICollectionView!
    let items = ["Information"]
    var imagePicker: UIImagePickerController!
    var newPost = PostDetails()
    let db = Firestore.firestore()
    let auth = Auth.auth()
    private let storage = Storage.storage().reference()
    var errorMessage = ""
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Post"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupCollectionView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    private func taskTypeMenu() -> UIMenu? {
        let menu = UIMenu(title: "Task type", image: nil, identifier: nil, options: [], children: [
            UIAction(title: "Service", image: nil, handler: { [weak self] (_) in
                self?.newPost.taskType = PostType.service.rawValue
            }),
            UIAction(title: "Goods", image: nil, handler: { [weak self] (_) in
                self?.newPost.taskType = PostType.good.rawValue
            })
        ])
        return menu
    }
    
    private func imageAction() {
        let actionSheet = UIAlertController(title: "Select Images", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.selectImage(from: .camera)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.pickPhotos()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverPresentationController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func selectImage(from source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch){
        newPost.allowLocationContactAccess = sender.isOn
    }
    
    @objc func removeSelectedImage(_ sender: UIButton) {
        newPost.images.remove(at: sender.tag - 1)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        if sender.tag == 4 {
            newPost.startDate = sender.date.fullDateString
        } else if sender.tag == 5 {
            newPost.endDate = sender.date.fullDateString
        }
    }
    
    func isValidPost() -> Bool {
        if newPost.amount <= 0 {
            errorMessage = "Amount for this job has to be greater than 0."
            return false
        }
        if newPost.images.isEmpty {
            errorMessage = "Please select at least one image."
            return false
        }
        if newPost.startDate > newPost.endDate {
            errorMessage = "Start date cannot be greater than the end date."
            return false
        }
//        if newPost.startDate > Date() {
//            errorMessage = "Start date cannot be before today."
//            return false
//        }
        if !newPost.allowLocationContactAccess {
            errorMessage = "Please accept terms and conditions."
            return false
        }
        if newPost.name.isEmpty || newPost.rate.isEmpty || newPost.location.isEmpty || newPost.description.isEmpty {
            errorMessage = "One or more fields is empty."
            return false
        }
        errorMessage = ""
        return true
    }
    
    func resetAllFields() {
        newPost = PostDetails()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func addPostToFeed() {
        activityIndicator.startAnimating()
        AllPosts.createdPosts.append(newPost.post_id)
        let currentUser = db.collection(User.collectionName).document(auth.currentUser!.uid)
        currentUser.updateData([
            User.postsCreated: AllPosts.createdPosts
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.saveImagesAndGetURL()
            }
        }
    }
    
    func saveImagesAndGetURL() {
        for (i,image) in newPost.images.enumerated() {
            if let imageData = image.pngData() {
                let imageID = UUID().uuidString
                storage.child("Posts/\(newPost.post_id)/\(imageID).png").putData(imageData, metadata: nil) { _, error in
                    guard error == nil else {
                        return
                    }
                    self.storage.child("Posts/\(self.newPost.post_id)/\(imageID).png").downloadURL { url, error in
                        guard let url = url, error == nil else {
                            return
                        }
                        let urlString = url.absoluteString
                        self.newPost.imageURLs.append(urlString)
                        if i == self.newPost.images.count - 1 {
                            self.savePostToFirebase()
                        }
                    }
                }
            }
        }
    }
    
    func savePostToFirebase() {
        activityIndicator.stopAnimating()
        db.collection(Post.collectionName).document(newPost.post_id).setData([
            Post.title : newPost.name,
            Post.description : newPost.description,
            Post.amount : newPost.amount,
            Post.rate : newPost.rate,
            Post.startDate : newPost.startDate,
            Post.endDate : newPost.endDate,
            Post.location : newPost.location,
            Post.taskType : newPost.taskType,
            Post.privacyAccess : newPost.allowLocationContactAccess,
            Post.post_id : newPost.post_id,
            Post.postedBy : auth.currentUser!.uid,
            Post.postStatus : newPost.postStatus,
            Post.pickedBy : "none",
            Post.imageURLs : newPost.imageURLs
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
                self.alert(title: "Error", message: "Theere was an issue saving data for the account.")
            } else {
                self.alert(title: "Success", message: "Your post is added to the job feed")
                self.resetAllFields()
            }
        }
    }
    
}

extension CreatePostCVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.identifier)
        collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: TextViewCell.identifier)
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.identifier)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(LabelButtonCell.self, forCellWithReuseIdentifier: LabelButtonCell.identifier)
        collectionView.register(SwitchCell.self, forCellWithReuseIdentifier: SwitchCell.identifier)
        collectionView.register(CreateButtonCell.self, forCellWithReuseIdentifier: CreateButtonCell.identifier)
        collectionView.register(HeaderWithTextView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderWithTextView.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 7 {return newPost.images.count + 1}
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 7 && indexPath.item == 0 {
            imageAction()
        } else if indexPath.section == 11 {
            if isValidPost() {
                addPostToFeed()
            } else {
                alert(title: "Error", message: errorMessage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 || section == 2 || section == 3 || section == 8 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.identifier, for: indexPath) as? TextFieldCell else {return UICollectionViewCell()}
            cell.textField.tag = section
            cell.configure(with: indexPath, newPost)
            cell.textField.delegate = self
            return cell
        } else if section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.identifier, for: indexPath) as? TextViewCell else {return UICollectionViewCell()}
            cell.descriptionTextView.delegate = self
            cell.descriptionTextView.text = newPost.description
            return cell
        } else if section == 4 || section == 5{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {return UICollectionViewCell()}
            cell.datePicker.tag = section
            newPost.startDate = Date().fullDateString
            newPost.endDate = Date().fullDateString
            cell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .touchUpInside)
            cell.configure(with: indexPath)
            return cell
        } else if section == 6 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.identifier, for: indexPath) as? TextCell else {return UICollectionViewCell()}
            cell.configure(with: indexPath)
            return cell
        } else if section == 7 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {return UICollectionViewCell()}
            cell.removeImageButton.tag = indexPath.item
            cell.removeImageButton.addTarget(self, action: #selector(removeSelectedImage), for: .touchUpInside)
            if indexPath.item == 0 {
                cell.configure(with: indexPath, image: nil)
            } else {
                cell.configure(with: indexPath, image: newPost.images[indexPath.item - 1])
            }
            return cell
        } else if section == 9 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelButtonCell.identifier, for: indexPath) as? LabelButtonCell else {return UICollectionViewCell()}
            cell.button.showsMenuAsPrimaryAction = true
            cell.button.menu = taskTypeMenu()
            return cell
        } else if section == 10 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell else { return UICollectionViewCell()}
            cell.privacySwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
            cell.privacySwitch.isOn = newPost.allowLocationContactAccess
            return cell
        } else if section == 11 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateButtonCell.identifier, for: indexPath) as? CreateButtonCell else {return UICollectionViewCell()}
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderWithTextView.identifier, for: indexPath) as? HeaderWithTextView else {return UICollectionReusableView()}
            headerView.configure(header: items[indexPath.section])
            return headerView


        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func createLayoutDiffSection() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var columns = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
            
            var groupHeight = NSCollectionLayoutDimension.absolute(50)
            var groupWidth =  NSCollectionLayoutDimension.fractionalWidth(1)
            
            if sectionIndex == 1 {
                groupHeight = NSCollectionLayoutDimension.absolute(110)
            } else if sectionIndex == 7 {
                columns = 4
                groupHeight = NSCollectionLayoutDimension.absolute(80)
            } else if sectionIndex == 11 {
                groupHeight = NSCollectionLayoutDimension.absolute(40)
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
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            if sectionIndex == 0{
                let layoutSectionHeader = self.createSectionHeader(with: sectionIndex)
                section.boundarySupplementaryItems = [layoutSectionHeader]
            } else if sectionIndex == 7 {
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20)
            } else if sectionIndex == 11 {
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 20, trailing: 8)
            }
            
            return section
        }
        return layout
    }
    
    private func createSectionHeader(with section: Int) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(35))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

extension CreatePostCVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let section = textField.tag
        if section == 0 {
            newPost.name = textField.text ?? ""
        } else if section == 2 {
            newPost.amount = Double(textField.text ?? "0") ?? 0
        } else if section == 3 {
            newPost.rate = textField.text ?? ""
        } else if section == 8 {
            newPost.location = textField.text ?? ""
        }
    }
}

//MARK: - Delegate for text view
extension CreatePostCVC: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        newPost.description = textView.text
    }
}

//MARK: - Delegate for image picker controller
extension CreatePostCVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            alert(title: "Error", message: "Image not found. Please try again.")
            return
        }
        
        if let medImage = image.jpeg(.medium) {
            if let uiimage = UIImage(data: medImage) {
                let potraitImge  = uiimage.fixOrientation
                newPost.images.append(potraitImge)
            }
        }
    
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            
        }
    }
}

//MARK: - Delegate for PHPicker to select multiple images
extension CreatePostCVC : PHPickerViewControllerDelegate {
    
    @objc func pickPhotos(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = PHPickerFilter.images
        config.selection = .ordered
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    // MARK: PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    if let medImage = image.jpeg(.medium) {
                        if let uiimage = UIImage(data: medImage) {
                            let potraitImge  = uiimage.fixOrientation
                            self.newPost.images.append(potraitImge)
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        
    }
}
