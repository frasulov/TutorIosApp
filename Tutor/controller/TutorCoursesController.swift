//
//  TutorCoursesController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 02.08.22.
//

import UIKit
import RealmSwift

class TutorCoursesController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.register(UINib(nibName: "\(TutorCourseCell.self)", bundle: nil), forCellReuseIdentifier: "\(TutorCourseCell.self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if segment.selectedSegmentIndex == 0 {
            fetchCoursesByStatus(.draft)
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
            case 0:
                fetchCoursesByStatus(.draft)
            case 1:
                fetchCoursesByStatus(.open)
            case 2:
                fetchCoursesByStatus(.active)
            case 3:
                fetchCoursesByStatus(.completed)
            default:
            fetchCoursesByStatus(.draft)
        }
        table.reloadData()
    }
    

    
    func fetchCoursesByStatus(_ status: CourseStatus) {
        var courseElements = realm.objects(Course.self)
        courses.removeAll()
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        courseElements = courseElements.where {
            $0.status == status && $0.createdBy.email == userEmail
        }
        courses.append(contentsOf: courseElements)
    }
    
}


extension TutorCoursesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TutorCourseCell.self)", for: indexPath) as! TutorCourseCell
        cell.courseTitle.text = courses[indexPath.row].title
        cell.coursePrice.text = "AZN \(courses[indexPath.row].price ?? 0)"
        cell.courseCategory.text = courses[indexPath.row].subCategory?.category?.name
        cell.courseSubCategory.text = courses[indexPath.row].subCategory?.name
        cell.courseLanguage.text = courses[indexPath.row].language ?? "Teyin edilmeyib"
        cell.courseImage.image = UIImage(named: courses[indexPath.row].image)
        return cell
    }
    
    
}
