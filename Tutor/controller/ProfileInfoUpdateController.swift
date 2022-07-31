//
//  ProfileInfoUpdateController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 21.07.22.
//

import UIKit
import RealmSwift

class ProfileInfoUpdateController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let realm = try! Realm()
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    var currentUser: User?
    let context = AppDelegate().persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchUser()
        self.fillData()
        self.table.isScrollEnabled = false
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
    

    @IBAction func updateBtnTapped(_ sender: Any) {
        
        try! realm.write {
            currentUser!.first_name = (currentUser!.first_name != firstnameField.text) ? firstnameField.text : currentUser!.first_name
            currentUser!.last_name = (currentUser!.last_name != lastnameField.text) ? lastnameField.text : currentUser!.last_name
            currentUser!.address = (currentUser!.address != addressField.text!) ? addressField.text! : currentUser!.address
            currentUser!.email = (currentUser!.email != emailField.text!) ? emailField.text! : currentUser!.email
            currentUser!.phone = (currentUser!.phone != phoneField.text!) ? phoneField.text! : currentUser!.phone
        }
        
        navigationController?.popViewController(animated: true)
        
    }
}


extension ProfileInfoUpdateController {
    
    
    func fillData() {
        
        self.firstnameField.text = self.currentUser?.first_name
        self.lastnameField.text = self.currentUser?.last_name
        self.emailField.text = self.currentUser?.email
        self.phoneField.text = self.currentUser?.phone
        self.addressField.text = self.currentUser?.address
        
    }
    
    func fetchUser() {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        let userElements = realm.objects(User.self)
        currentUser = userElements.where {
            $0.email == userEmail
        }.first
    }
    
}
