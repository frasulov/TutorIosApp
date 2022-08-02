//
//  CreateCourseController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 31.07.22.
//

import UIKit
import RealmSwift
import LMDFloatingLabelTextField

enum TextFieldType: String {
    case category
    case subcategory
}

class CreateCourseController: UIViewController {
    
    let realm = try! Realm()
    

    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var categoryError: UILabel!
    @IBOutlet weak var subcategoryError: UILabel!
    @IBOutlet weak var titleField: LMDFloatingLabelTextField!
    
    @IBOutlet weak var subcategoryField: LMDFloatingLabelTextField!
    @IBOutlet weak var categoryField: LMDFloatingLabelTextField!
    
    let pickerView = UIPickerView()
    var categories = [Category]()
    var category = Category()
    var selectedSubCategory = SubCategory()
    var selectedTextField = TextFieldType.category
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.categoryField.delegate = self
        self.subcategoryField.delegate = self
        uiSetup()

    }
    
    func uiSetup() {
        self.categoryField.inputView = pickerView
        self.subcategoryField.inputView = pickerView
        self.subcategoryField.disabled = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneCategoryPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        self.categoryField.inputAccessoryView = toolBar
    }
    
    @objc func doneCategoryPicker() {
        categoryField.resignFirstResponder()
        subcategoryField.becomeFirstResponder()
    }
    
    @objc func cancelPicker() {
        categoryField.resignFirstResponder()
        subcategoryField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.categoryField.text = ""
        self.subcategoryField.text = ""
        self.titleField.text = ""
    }
    
    
    @IBAction func createBtnTapped(_ sender: Any) {
        var error = 0
        if titleField.text == "" {
            titleError.isHidden = false
            error += 1
        } else {
            titleError.isHidden = true
        }

        if categoryField.text == "" {
            categoryError.isHidden = false
            error += 1
        } else {
            categoryError.isHidden = true
        }

        if subcategoryField.text == "" {
            subcategoryError.isHidden = false
            error += 1
        } else {
            subcategoryError.isHidden = true
        }

        if error == 0 {
            let currentUser = fetchUser()
            let course = Course()
            course.title = titleField.text!
            course.subCategory = selectedSubCategory
            course.createdBy = currentUser

            try! realm.write {
                realm.add(course)
            }
        }
        
        if let tabbar = self.tabBarController {
            print("tabbar is not null")
            tabbar.selectedIndex = 1
        }
        
    }
    
    func fetchUser() -> User? {
        var user: User?
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        let userElements = realm.objects(User.self)
        user = userElements.where {
            $0.email == userEmail
        }.first
        return user
    }
    
    func fetchData() {
        let categoryElements = realm.objects(Category.self)
        categories.removeAll()
        categories.append(contentsOf: categoryElements)
    }
}


extension CreateCourseController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.selectedTextField == .category {
            return categories.count
        } else {
            return category.subCategoires.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.selectedTextField == .category {
            return categories[row].name
        } else {
            return category.subCategoires[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.selectedTextField == .category {
            categoryField.text = categories[row].name
            category = categories[row]
            categoryField.resignFirstResponder()
            self.subcategoryField.disabled = false
        } else {
            selectedSubCategory = category.subCategoires[row]
            subcategoryField.text = category.subCategoires[row].name
            subcategoryField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.selectedTextField = .category
        } else if textField.tag == 2 {
            self.selectedTextField = .subcategory
        }
    }
    
}
