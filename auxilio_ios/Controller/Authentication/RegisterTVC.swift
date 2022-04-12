//
//  RegisterTVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/24/22.
//

import UIKit
import Firebase

class RegisterTVC: UITableViewController {
    
    var password : String = ""
    var errorMessage : String = ""
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var user = UserDetails()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TextFieldTableCell.self, forCellReuseIdentifier: TextFieldTableCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.register(CenterLabelCell.self, forCellReuseIdentifier: CenterLabelCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
    }
    
    func isValidInput() -> Bool{
        user.email = user.email.trimming(spaces: .all)
        user.name = user.name.trimming(spaces: .leadingAndTrailing )
        user.mobile = user.mobile.trimming(spaces: .all)
        if user.name.isEmpty || user.mobile.isEmpty || user.email.isEmpty || password.isEmpty {
            errorMessage = "One or more fields is empty."
            return false
        }
        for number in user.mobile {
            if !number.isNumber {
                errorMessage = "Phone number has characters other than number."
                return false
            }
        }
        if !user.email.isValidEmail() {
            errorMessage = "Not a valid email address."
            return false
        }
        if password.count < 6 || password.count > 18 {
            errorMessage = "Password must be between 6-18 characters."
            return false
        }
        errorMessage = ""
        return true
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            errorMessage = ""
        } else {
            activityIndicator.stopAnimating()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else if indexPath.section == 1 && indexPath.row == 1 {
            return 50
        } else {
            return 30
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableCell.identifier, for: indexPath) as? TextFieldTableCell else {return UITableViewCell()}
            cell.backgroundColor = .systemBackground
            cell.configure(with: indexPath,type: .register)
            cell.textField.delegate = self
            cell.textField.tag = row
            if row == 0 {
                cell.textField.text = user.name
            } else if row == 1 {
                cell.textField.text = user.mobile
            } else if row == 2 {
                cell.textField.text = user.email
            } else if row == 3 {
                cell.textField.text = password
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 && row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CenterLabelCell.identifier, for: indexPath) as? CenterLabelCell else {return UITableViewCell()}
            cell.configure(with: "Create Account")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .systemBackground
            cell.textLabel?.text = errorMessage
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = .systemRed
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1{
            if isValidInput() {
                Auth.auth().createUser(withEmail: user.email, password: password) { [weak self] (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self?.alert(title: "Error", message: "There was an issue creating account")
                    } else {
                        self?.user.uuid = Auth.auth().currentUser?.uid ?? "nil"
                        self?.saveUserInfo()
                    }
                }
                
            } else {
                tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveUserInfo() {
        db.collection(User.collectionName).document(user.uuid).setData([
            User.name : user.name ,
            User.uuid : user.uuid,
            User.email : user.email,
            User.mobile : user.mobile,
            User.address : user.address,
            User.dob : user.dob,
            User.postsCreated : user.postsCreated,
            User.postsPicked : user.postsPicked,
            User.postsSaved : user.postsSaved,
            User.imageURL : user.imageURL
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
                self.alert(title: "Error", message: "Theere was an issue saving data for the account.")
            } else {
                self.moveToTabbarController()
            }
        }
    }
    
    func moveToTabbarController() {
        let vc = MainTabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Extension for text field delegates
extension RegisterTVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if textField.tag == 0 {
            user.name = text
        } else if textField.tag == 1 {
            user.mobile = text
        } else if textField.tag == 2 {
            user.email = text
        } else if textField.tag == 3 {
            password = text
        }
    }
    
}
