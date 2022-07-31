//
//  ForgotPasswordController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 21.07.22.
//

import UIKit

class ForgotPasswordController: UIViewController {

    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
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
    
    
    func uiSetup() {
        self.forgotPasswordBtn.layer.cornerRadius = 10
    }



}
