//
//  SearchController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 20.07.22.
//

import UIKit
import RealmSwift


enum SearchTableType: String {
    case categories
    case searchTextTips
    case searchResult
}

class SearchController: UIViewController {
    
    @IBOutlet weak var locationBtn: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var topSearchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonRightConstraint: NSLayoutConstraint!
    let DEFAULT_SEARCH_RIGTH_CONSTRAINT = 15
    let ANIMATED_SEARCH_RIGTH_CONSTRAINT = 75
    var userSelectedFilters = [CourseFilterDto]()
    var sortBy: String?
    var courses = [Course]()
    var categories = [Category]()
    var searchTips = [String]()
    let realm = try! Realm()
    var searchTableType = SearchTableType.categories
    var leftNavigationBtn: UIBarButtonItem?
    var searchBy: String?
    var bySubCategory: SubCategory?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uiSetup()
        fetchData()
        table.register(UINib(nibName: "\(CourseSearchCell.self)", bundle: nil), forCellReuseIdentifier: "\(CourseSearchCell.self)")
        table.register(UINib(nibName: "\(SearchTipCell.self)", bundle: nil), forCellReuseIdentifier: "\(SearchTipCell.self)")
        table.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil), forCellReuseIdentifier: "\(CategoryCell.self)")
        
    }
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.searchTableType = .categories
        self.table.reloadData()
        self.searchTextField.endEditing(true)
        self.searchBy = nil
        self.searchTextField.text = ""
        self.bySubCategory = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillAppear() {
        startSearchAnimation(width: self.ANIMATED_SEARCH_RIGTH_CONSTRAINT, cancelButtonRightConstraint: 2)
    }
    
    @objc func keyboardWillDisappear() {
        startSearchAnimation(width: self.DEFAULT_SEARCH_RIGTH_CONSTRAINT, cancelButtonRightConstraint: -75)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(CourseMapController.self)") as! CourseMapController
        controller.courses = self.courses
        show(controller, sender: nil)
    }
    
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(FilterController.self)") as! FilterController
        controller.callback = { sortByString, filterArray in
            self.searchTableType = .searchResult
            self.table.reloadData()
            print(sortByString, filterArray)
            self.sortBy = sortByString
            self.userSelectedFilters = filterArray
        }
//        controller.sortBy = self.sortBy
//        controller.userSelectedFilters = self.userSelectedFilters
        present(controller, animated: true)
    }
    
    @IBAction func editStarted(_ sender: Any) {
        self.searchTableType = .searchTextTips
        self.table.reloadData()
    }
    
    func startSearchAnimation(width: Int, cancelButtonRightConstraint: Int) {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear]) {
            self.rightConstraint.constant = CGFloat(width)
            self.cancelButtonRightConstraint.constant = CGFloat(cancelButtonRightConstraint)
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension SearchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTableType = .searchResult
        searchBy = textField.text
        table.reloadData()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.searchTips.removeAll()
        if let t = self.searchTextField.text {
            if t != "" {
                self.searchTips.append(t)
                table.reloadData()
            }
        }
        return true
    }
    
}

extension SearchController {
    
    
    func uiSetup() {
        self.searchBoxView.layer.cornerRadius = 10
        self.leftNavigationBtn = self.navigationItem.leftBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func fetchData() {
        var courseElements = realm.objects(Course.self)
        courseElements = courseElements.where {
            $0.status == .active || $0.status == .open
        }
        if let search = searchBy {
            if search != "" {
                courseElements = courseElements.where {
                    $0.title.starts(with: search)
                }
            }
        }
        
        if let sub = self.bySubCategory {
            courseElements = courseElements.where {
                $0.subCategory == sub
            }
        }
        courses.removeAll()
        courses.append(contentsOf: courseElements)
        
        let categoryElements = realm.objects(Category.self)
        categories.removeAll()
        categories.append(contentsOf: categoryElements)
        
    }
    
}


extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchTableType == .searchResult {
            fetchData()
            return courses.count
        } else if self.searchTableType == .categories {
            return categories[section].subCategoires.count
        } else {
            return self.searchTips.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchTableType == .categories {
            return categories.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.navigationItem.leftBarButtonItem = nil
        if self.searchTableType == .searchResult {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(CourseSearchCell.self)", for: indexPath) as! CourseSearchCell
            
            cell.language.text = courses[indexPath.row].language
            cell.price.text = "AZN \(courses[indexPath.row].price ?? 0)"
            cell.createdBy.text = courses[indexPath.row].createdBy?.name
            cell.title.text = courses[indexPath.row].title
            cell.courseImage.image = UIImage(named: courses[indexPath.row].image)
            cell.category.text = courses[indexPath.row].subCategory?.category?.name
            cell.subcategory.text = courses[indexPath.row].subCategory?.name
            self.navigationItem.leftBarButtonItem = self.leftNavigationBtn
            return cell
        } else if self.searchTableType == .categories {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(CategoryCell.self)", for: indexPath) as! CategoryCell
            cell.label.text = self.categories[indexPath.section].subCategoires[indexPath.row].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchTipCell.self)", for: indexPath) as! SearchTipCell
            cell.label.text = self.searchTips[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.searchTableType == .categories {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            let label = UILabel(frame: CGRect(x: 15, y: -15, width: tableView.frame.width-15, height: 20))
            view.backgroundColor = UIColor.white
            label.text = categories[section].name
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.boldSystemFont(ofSize: 20)
            view.addSubview(label)
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if self.searchTableType == .categories {
            return 20
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchTableType == .searchResult {
            let controller = storyboard?.instantiateViewController(withIdentifier: "\(CourseController.self)") as! CourseController
            controller.course = self.courses[indexPath.row]
            show(controller, sender: nil)

        } else if self.searchTableType == .categories {
            self.searchTableType = .searchResult
            self.bySubCategory = categories[indexPath.section].subCategoires[indexPath.row]
            table.reloadData()
        } else {
            self.searchTableType = .searchResult
            table.reloadData()
        }
    }
    
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
