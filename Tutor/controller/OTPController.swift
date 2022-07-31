//
//  OTPController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 23.07.22.
//

import UIKit
import OTPFieldView

class OTPController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var firstBack: UIView!
    @IBOutlet weak var secondBack: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var kodAlinmadi: UILabel!
    @IBOutlet weak var otp: OTPFieldView!
    @IBOutlet weak var sendNewCodeBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var userEmail: String?
    var timeRemaining = 0
    var timer: Timer!
    var otpText: String?
    let TOTAL_TIME = 12
    let DEFAULT_OTP_CODE = "111111"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
        emailLabel.text = userEmail
        startTimer()
        
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

    
    @IBAction func newCodeBtnTapped(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if otpText == DEFAULT_OTP_CODE {
            print("successfully register")
            timer.invalidate()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "\(CustomTabBarController.self)") as! UITabBarController
            nextViewController.modalPresentationStyle = .overFullScreen
            present(nextViewController, animated: true)
            errorLabel.isHidden = true
        }else {
            print("Code is wrong")
            errorLabel.isHidden = false
        }
    }
}

extension OTPController {
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timeLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        kodAlinmadi.layer.opacity = 0.3
        sendNewCodeBtn.layer.opacity = 0.3
        sendNewCodeBtn.isEnabled = false
        image.image = UIImage(named: "otpFirst")
        timeLabel.text = "00:00"
        timeRemaining = TOTAL_TIME
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining >= 60 {
                timeLabel.text = String(format: "%02d:%02d", timeRemaining/60, timeRemaining%60)
            } else {
                timeLabel.text = String(format: "00:%02d", timeRemaining)
            }
            if timeRemaining < 10 {
                timeLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
            } else {
                timeLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        } else {
            timerFinishedSetup()
        }
    }
    
    func timerFinishedSetup(){
        timer.invalidate()
        kodAlinmadi.layer.opacity = 1
        sendNewCodeBtn.layer.opacity = 1
        sendNewCodeBtn.isEnabled = true
        submitBtn.isEnabled = false
        submitBtn.layer.opacity = 0.3
        image.image = UIImage(named: "otpError")
    }
    
    func uiSetup() {
        self.otp.fieldsCount = 6
        self.otp.fieldBorderWidth = 2
        self.otp.defaultBorderColor = UIColor(named: "SecondColor")!
        self.otp.filledBorderColor = UIColor(named: "otpCode")!
//        self.otp.cursorColor = UIColor(named: "errorColor")!
        self.otp.requireCursor = false
        self.otp.displayType = .circular
        self.otp.fieldSize = 42
        self.otp.separatorSpace = 7
        self.otp.shouldAllowIntermediateEditing = false
        self.otp.delegate = self
        self.otp.initializeUI()
        
        self.firstBack.layer.cornerRadius = 271.5
        self.firstBack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.firstBack.layer.backgroundColor = UIColor(named: "circle1")?.withAlphaComponent(0.2).cgColor
        self.secondBack.layer.backgroundColor = UIColor(named: "circle2")?.withAlphaComponent(0.2).cgColor
        self.secondBack.layer.cornerRadius = 196
        
        self.submitBtn.layer.cornerRadius = 10
        self.submitBtn.layer.opacity = 0.3
        self.submitBtn.isEnabled = false
    }
}


extension OTPController: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        if timeRemaining > 0 {
            if hasEnteredAll {
                image.image = UIImage(named: "otpSubmit")
                self.submitBtn.layer.opacity = 1
                self.submitBtn.isEnabled = true
            } else {
                image.image = UIImage(named: "otpFirst")
                self.submitBtn.layer.opacity = 0.3
                self.submitBtn.isEnabled = false
            }
        }

        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        otpText = otp
    }
}
