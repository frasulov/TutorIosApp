//
//  ProfileInfoController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 21.07.22.
//

import UIKit
import RealmSwift

class ProfileInfoController: UIViewController {

    
    let realm = try! Realm()
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var name: UILabel!
    var currentUser: User?
    let context = AppDelegate().persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchUser()
        self.fillData()
    }
    
    
    func fillData() {
        self.email.text = currentUser?.email
        self.name.text = currentUser?.first_name
        self.surname.text = currentUser?.last_name
        self.address.text = currentUser?.address
        self.phone.text = currentUser?.phone
    }
    
    
    func fetchUser() {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        let userElements = realm.objects(User.self)
        currentUser = userElements.where {
            $0.email == userEmail
        }.first
    }
    

    @IBAction func updateBtnTapped(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "\(ProfileInfoUpdateController.self)") as! ProfileInfoUpdateController
        show(nextViewController, sender: nil)
    }


}
