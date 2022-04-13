//
//  SigninTVC.swift
//  auxilio_ios
//
//  Created by Shubham Arya on 1/24/22.
//

import UIKit
import Firebase

class SigninTVC: UITableViewController {
    
    var email : String = ""
    var password : String = ""
    var errorMessage : String = ""
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Account", style: .plain, target: self, action: #selector(createAccount))
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TextFieldTableCell.self, forCellReuseIdentifier: TextFieldTableCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.register(CenterLabelCell.self, forCellReuseIdentifier: CenterLabelCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
    }
    
    @objc func createAccount() {
        let vc = RegisterTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValidInput() -> Bool{
        email = email.trimming(spaces: .all)
        if email.isEmpty || password.isEmpty {
            errorMessage = "One or more fields is empty."
            return false
        }
        if !email.isValidEmail() {
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
    
    func signIn() {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self?.errorMessage = "Cannot sign in with those details."
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                let vc = MainTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 1) {
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
            cell.configure(with: indexPath, type: .signin)
            cell.textField.delegate = self
            cell.textField.tag = row
            if row == 0 {
                cell.textField.text = email
            } else if row == 1{
                cell.textField.text = password
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 && indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CenterLabelCell.identifier, for: indexPath) as? CenterLabelCell else {return UITableViewCell()}
            cell.configure(with: "Sign in")
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
        if indexPath.section == 1 && indexPath.row == 1 {
            if isValidInput() {
                signIn()
            } else {
                tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Extension for Text field
extension SigninTVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if textField.tag == 0 {
            email = text
        } else if textField.tag == 1 {
            password = text
        }
    }
    
}
