//
//  RegisterController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 19.07.22.
//

import UIKit
import RealmSwift
import LMDFloatingLabelTextField

class RegisterController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let realm = try! Realm()
    @IBOutlet weak var checkboxBtn: CheckBox!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var password: LMDFloatingLabelTextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var email: LMDFloatingLabelTextField!
    @IBOutlet weak var phone: LMDFloatingLabelTextField!
    @IBOutlet weak var lastnameError: UILabel!
    @IBOutlet weak var lastname: LMDFloatingLabelTextField!
    @IBOutlet weak var firstnameError: UILabel!
    @IBOutlet weak var firstname: LMDFloatingLabelTextField!
    @IBOutlet weak var phoneError: UILabel!

    
    let context = AppDelegate().persistentContainer.viewContext
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        var backImage = UIImage(named: "leftArrow")!
        backImage = resizeImage(image: backImage, newWidth: 25)!
        backImage = backImage.withRenderingMode(.alwaysOriginal)
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.table.isScrollEnabled = false

        uiSetup()
        print("fileUrl: ", realm.configuration.fileURL ?? "no file found")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        self.table.isScrollEnabled = true
        
    }
    
    @objc func keyboardWillDisappear() {
        self.table.setContentOffset(.zero, animated: true)
        self.table.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        let isRegistered = registerNewUser(first_name: firstname.text, last_name: lastname.text, phoneNumber: phone.text, email: email.text, password: password.text)
        if isRegistered {
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "\(OTPController.self)") as! OTPController
            nextViewController.userEmail = email.text
            UserDefaults.standard.set(true, forKey: "isLogged")
            UserDefaults.standard.set(email.text, forKey: "userEmail")
            show(nextViewController, sender: nil)
        }
    }
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        checkboxBtn.isChecked = checkboxBtn.isChecked ? true : false
        self.registerBtn.isEnabled = checkboxBtn.isChecked
    }
    
    @IBAction func checkBtnTextTapped(_ sender: Any) {
        checkboxBtn.isChecked = checkboxBtn.isChecked ? false : true
        self.registerBtn.isEnabled = checkboxBtn.isChecked
    }
    
    @IBAction func toLoginBtnTapped(_ sender: Any) {
        navigateToLogin()
    }
    

}

extension RegisterController {
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth + 15, height: newHeight))
            image.draw(in: CGRect(x: 15, y: 0, width: newWidth, height: newHeight))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
    
    func uiSetup() {
//        self.loginBtn.font = UIFont(name: "Nunito-Bold", size: 16)
        checkboxBtn.style = .tick
        checkboxBtn.borderStyle = .square

        self.registerBtn.isEnabled = false
        self.registerBtn.layer.cornerRadius = 10
        self.email.layer.cornerRadius = 10
        self.email.layer.borderWidth = 1
        self.email.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        self.phone.layer.cornerRadius = 10
        self.phone.layer.borderWidth = 1
        self.phone.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        self.lastname.layer.cornerRadius = 10
        self.lastname.layer.borderWidth = 1
        self.lastname.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        self.firstname.layer.cornerRadius = 10
        self.firstname.layer.borderWidth = 1
        self.firstname.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        self.password.layer.cornerRadius = 10
        self.password.layer.borderWidth = 1
        self.password.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
    }
    
}

extension RegisterController {
    
    func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func registerNewUser(first_name: String?, last_name: String?, phoneNumber: String?, email: String?, password: String?) -> Bool {
        if validateUserInfo(first_name: first_name, last_name: last_name, phoneNumber: phoneNumber, email: email, password: password) {
            let model = User()
            model.first_name = first_name
            model.last_name = last_name
            model.phone = phoneNumber!
            model.email = email!
            model.password = password!

            try! realm.write {
                realm.add(model)
            }
            return true
        } else {
            return false
        }
    }

    func validateUserInfo(first_name: String?, last_name: String?, phoneNumber: String?, email: String?, password: String?) -> Bool {

        var error = 0
        if first_name == "" {
            self.firstnameError.isHidden = false
            self.firstname.layer.borderColor = UIColor(named: "errorColor")?.cgColor
            error+=1
        }else {
            self.firstnameError.isHidden = true
            self.firstname.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        }

        if last_name == "" {
            self.lastnameError.isHidden = false
            self.lastname.layer.borderColor = UIColor(named: "errorColor")?.cgColor
            error+=1
        }else{
            self.lastnameError.isHidden = true
            self.lastname.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        }

        if phoneNumber == "" {
            self.phoneError.isHidden = false
            self.phone.layer.borderColor = UIColor(named: "errorColor")?.cgColor
            error+=1
        }else{
            self.phoneError.isHidden = true
            self.phone.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        }
        if password == "" {
            self.passwordError.isHidden = false
            self.password.layer.borderColor = UIColor(named: "errorColor")?.cgColor
            error+=1
        }else{
            self.passwordError.isHidden = true
            self.password.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
        }
        if email == "" {
            self.emailError.isHidden = false
            self.emailError.text = "* E-poçt tələb olunur"
            self.email.layer.borderColor = UIColor(named: "errorColor")?.cgColor
            error+=1
        }else{
            if !isValidEmail(email ?? "") {
                self.emailError.isHidden = false
                self.emailError.text = "* Etibarsız e-poçt formatı"
                self.email.layer.borderColor = UIColor(named: "errorColor")?.cgColor
                error+=1
            } else {
            self.emailError.isHidden = true
            self.email.layer.borderColor = UIColor(red: 0.654, green: 0.63, blue: 0.627, alpha: 1).cgColor
            }
        }

        if error != 0 {
            return false
        }
        return true
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
