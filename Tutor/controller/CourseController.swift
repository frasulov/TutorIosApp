//
//  CourseController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import UIKit


enum CellType: String {
    case rating
    case description
    case allratings
}

class CourseController: UIViewController {

    @IBOutlet weak var courseSubCategory: UILabel!
    @IBOutlet weak var courseCategory: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var courseTutorCourses: UILabel!
    @IBOutlet weak var courseLanguage: UILabel!
    @IBOutlet weak var courseTutorStudents: UILabel!
    @IBOutlet weak var courseTutor: UILabel!
    @IBOutlet weak var courseRating: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var bottomViewPrice: UILabel!
    @IBOutlet weak var topViewPrice: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var cells = [CellType]()
    var course = Course()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        uiSetup()
        fillData()
        
        cells.append(contentsOf: [.description, .allratings, .rating, .rating, .rating, .rating, .rating, .rating, .rating])
        
        table.register(UINib(nibName: "\(CourseDescCell.self)", bundle: nil), forCellReuseIdentifier: "\(CourseDescCell.self)")
        table.register(UINib(nibName: "\(RatingCell.self)", bundle: nil), forCellReuseIdentifier: "\(RatingCell.self)")
        table.register(UINib(nibName: "\(AllRatingsCell.self)", bundle: nil), forCellReuseIdentifier: "\(AllRatingsCell.self)")
        
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
    }
    
}


extension CourseController: UIScrollViewDelegate {
    
    func uiSetup() {
        self.bottomView.isHidden = true
        self.bottomViewHeightConstraint.constant = 0
        self.bottomView.addTopBorderWithColor(color: UIColor.gray, width: 1)
    }
    
    func fillData() {
        self.courseTitle.text = course.title
        self.courseTutor.text = course.createdBy?.name
        self.courseImage.image = UIImage(named: course.image)
        self.courseLanguage.text = course.language
        self.courseCategory.text = course.subCategory?.category?.name
        self.courseSubCategory.text = course.subCategory?.name
        if let price = course.price {
            self.bottomViewPrice.text = "AZN \(price)"
            self.topViewPrice.text = "\(price) AZN"
        } else {
            self.bottomViewPrice.text = "FREE"
            self.topViewPrice.text = "FREE"
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= self.topView.bounds.height {
            self.bottomView.isHidden = false
            self.bottomViewHeightConstraint.constant = 60
        }else {
            self.bottomView.isHidden = true
            self.bottomViewHeightConstraint.constant = 0
        }
    }
    
}



extension CourseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cells[indexPath.section] {
        case .rating:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(RatingCell.self)", for: indexPath)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(CourseDescCell.self)", for: indexPath)
            return cell
        case .allratings:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(AllRatingsCell.self)", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            return view
    }
    
    
    
    
    
    
}
