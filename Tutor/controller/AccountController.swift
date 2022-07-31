//
//  AccountController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 21.07.22.
//

import UIKit

class AccountController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        uiSetup()
    }
    
    func uiSetup() {
        self.profileImage.layer.cornerRadius = 75
        
        self.bottomView.layer.cornerRadius = 40
        self.bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    @IBAction func accountInfoBtnTapped(_ sender: Any) {
        let profileNav = storyboard?.instantiateViewController(withIdentifier: "profileNav") as! UINavigationController
        present(profileNav, animated: true)
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isLogged")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
        nextViewController.modalPresentationStyle = .overFullScreen
        present(nextViewController, animated: true)
    }
    
}
