//
//  ViewController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 19.07.22.
//

import UIKit
import LMDFloatingLabelTextField
import RealmSwift

class LoginController: UIViewController {


    @IBOutlet weak var table: UITableView!
    let realm = try! Realm()
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var password: LMDFloatingLabelTextField!
    @IBOutlet weak var email: LMDFloatingLabelTextField!
    var users = [User]()
    let context = AppDelegate().persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
        fetchUsers()
        
        email.text = "feqan.resulov.2000@gmail.com"
        title = ""
        self.table.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        self.table.isScrollEnabled = true
//        if self.table.contentOffset.y < self.table.bounds.height{
//            self.table.setContentOffset(CGPoint(x: 0, y: self.table.bounds.height), animated: true)
//        }
        
    }
    
    @objc func keyboardWillDisappear() {
        self.table.setContentOffset(.zero, animated: true)
        self.table.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        if login(email: email.text, password: password.text) {
            error.isHidden = true
            email.error = false
            password.error = false
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "\(CustomTabBarController.self)") as! UITabBarController

            nextViewController.modalPresentationStyle = .overFullScreen
            present(nextViewController, animated: true)
            UserDefaults.standard.set(true, forKey: "isLogged")
            UserDefaults.standard.set(email.text, forKey: "userEmail")
            
            print("login to account")
        }else {
            error.isHidden = false
            email.error = true
            password.error = true
            print("Credentials error")
        }

    }

    
    @IBAction func registerTapped(_ sender: Any) {
        navigateToRegister()
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        navigateToForgotPassword()
    }
    

    func uiSetup() {
        self.loginBtn.layer.cornerRadius = 10
    }

}


extension LoginController {

    func navigateToRegister() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(RegisterController.self)") as! RegisterController
        show(controller, sender: nil)
    }

    func navigateToForgotPassword() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(ForgotPasswordController.self)") as! ForgotPasswordController
        show(controller, sender: nil)
    }


    func fetchUsers() {
        let userElements = realm.objects(User.self)
        users.removeAll()
        for userElement in userElements {
            users.append(userElement)
        }
    }

    func login(email: String?, password: String?) -> Bool {
        for user in users {
            if user.email == email && user.password == password {
                return true
            }
        }
        return false
    }
}
