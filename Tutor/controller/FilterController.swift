//
//  FilterController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import UIKit
import RealmSwift

class FilterController: UIViewController {
    let realm = try! Realm()
    var filters = [CourseFilter]()
    var userSelectedFilters = [CourseFilterDto]()
    var sortBy: String?
    var callback: ((String, [CourseFilterDto])->())?
    var sortByText = "Default"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilterData()
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.register(UINib(nibName: "FilterDropdownCell", bundle: nil), forCellReuseIdentifier: "FilterDropdownCell")
        
        print("sort by:", self.sortBy ?? "")
    }
    
    @IBAction func applyFiltersBtn(_ sender: Any) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "\(SearchController.self)") as! SearchController
//        controller.userSelectedFilters = self.userSelectedFilters
//        controller.sortBy = self.sortBy
//        navigationController?.popToViewController(controller, animated: true)
        print("here--------")
        callback?(sortBy ?? "", userSelectedFilters)
        dismiss(animated: true, completion: nil)
    }
    
    func fetchFilterData() {
        let filterElements = realm.objects(CourseFilter.self)
        filters.removeAll()
        for filter in filterElements {
            filters.append(filter)
        }
        
        filters = filters.sorted {
            $0.type > $1.type
        }
    }
    

}

extension FilterController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filters[section].type == CourseFilterType.dropdown {
            return 1
        }
        return filters[section].filters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filters[indexPath.section]
        
        if filter.type == .dropdown {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FilterDropdownCell.self)", for: indexPath) as! FilterDropdownCell
            cell.label.text = self.sortByText
//            cell.view.addLeftBorderWithColor(color: UIColor.red, width: 2)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FilterCell.self)", for: indexPath) as! FilterCell
            cell.label.text = filter.filters[indexPath.row]
            cell.checkBox.style = .tick
            cell.checkBox.borderStyle = .square
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width-15, height: 30))
        view.backgroundColor = UIColor.white
        label.text = filters[section].section
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filters[indexPath.section]
        if data.type == CourseFilterType.dropdown {
            showSimpleActionSheet(sortColumns: data, indexPath: indexPath)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! FilterCell
            
            if cell.checkBox.isChecked {
                // delete
                if let courseFilter = userSelectedFilters.first(where: { $0.section == data.section}) {
                    userSelectedFilters.removeAll{ $0.section == data.section}
                    courseFilter.filters.remove(at: courseFilter.filters.firstIndex(of: data.filters[indexPath.row])!)
                    if courseFilter.filters.count != 0 {
                        userSelectedFilters.append(courseFilter)
                    }
                }
            } else {
                // add
                if let courseFilter = userSelectedFilters.first(where: { $0.section == data.section}) {
                    courseFilter.filters.append(data.filters[indexPath.row])
                }else {
                    let courseFilter = CourseFilterDto()
                    courseFilter.section = data.section
                    courseFilter.filters.append(data.filters[indexPath.row])
                    userSelectedFilters.append(courseFilter)
                }
            }
            cell.checkBox.isChecked = !cell.checkBox.isChecked
        }
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


extension FilterController {
    func showSimpleActionSheet(sortColumns: CourseFilter, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        
        for column in sortColumns.filters {
            alert.addAction(UIAlertAction(title: column, style: .default, handler: { (_) in
                self.sortBy = column
                self.sortByText = column
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        }
    
}
