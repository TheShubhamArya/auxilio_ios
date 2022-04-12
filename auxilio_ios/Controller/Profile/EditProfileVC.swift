//
//  EditProfileVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/30/22.
//

import UIKit
import Firebase

protocol EditProfileDelegate {
    func didEditInfo(of user: UserDetails)
}

class EditProfileVC: UIViewController {

    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(LabelTextViewCell.self, forCellReuseIdentifier: LabelTextViewCell.identifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    var isEditable = false
    private let storage = Storage.storage().reference()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var editProfileDelegate : EditProfileDelegate!
    var user : UserDetails!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        let profilePicButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(addProfileImage))
        
        navigationItem.rightBarButtonItems = [profilePicButton, editButton]
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupTableView()
    }
    
    @objc func addProfileImage() {
        let imageController = UIImagePickerController()
        imageController.allowsEditing = true
        imageController.delegate = self
        present(imageController, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    @objc func editButtonTapped() {
        isEditable = !isEditable
        var EditButtonText = "Edit"
        if isEditable {
            EditButtonText = "Done"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: EditButtonText, style: .plain, target: self, action: #selector(editButtonTapped))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func saveProfileImageForUser(with urlString: String) {
        let user = self.db.collection(User.collectionName).document(self.auth.currentUser!.uid)
        user.updateData([
            User.imageURL : urlString
        ]) { [weak self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self?.user.imageURL = urlString
                self?.editProfileDelegate.didEditInfo(of: self?.user ?? UserDetails())
                print("Document successfully updated")
            }
        }
    }
}

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            alert(title: "Error", message: "Image not found. Please try again.")
            return
        }
        
        let fixedImage = image.fixOrientation
        
        guard let imageData = fixedImage.pngData() else {
            alert(title: "Error", message: "Please try again later.")
            return
        }
        storage.child("UserProfiles/\(auth.currentUser!.uid).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                return
            }
            self.storage.child("UserProfiles/\(self.auth.currentUser!.uid).png").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                self.saveProfileImageForUser(with: urlString)
            }
        }
    }
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTextViewCell.identifier, for: indexPath) as? LabelTextViewCell else {return UITableViewCell()}
        cell.configure(for: indexPath, isEditable: isEditable)
        cell.cellDelegate = self
        return cell
    }
}

extension EditProfileVC: GrowingCellProtocol {
    
    func updateHeightOfRow(_ cell: LabelTextViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

