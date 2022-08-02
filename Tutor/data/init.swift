//
//  init.swift
//  Tutor
//
//  Created by Fagan Rasulov on 02.08.22.
//

import Foundation
import RealmSwift


class JsonReader {
    
    func readJsonFromBundle(filename: String) -> Data? {
        if let jsonFile = Bundle.main.url(forResource: filename, withExtension: "json"), let data = try? Data(contentsOf: jsonFile) {
            return data
        }
        return nil
    }
    
    func parseJson(data: Data) -> ModelData? {
        do {
            let model = try JSONDecoder().decode(ModelData.self, from: data)
            return model
        } catch let error {
            print("Follwing error: ", error.localizedDescription)
        }
        return nil
    }
}


class Init {
    
    static var shared = Init()
    var reader = JsonReader()
    let realm = try! Realm()
        
    func run() {
        
        if let data = reader.readJsonFromBundle(filename: "initial_data") {
            if let model = reader.parseJson(data: data) {
                
                if model.run {
                    try! realm.write {
                        let users = realm.objects(User.self)
                        realm.delete(users)
                        
                        let filters = realm.objects(CourseFilter.self)
                        realm.delete(filters)
                        
                        let courses = realm.objects(Course.self)
                        realm.delete(courses)
                        
                        let categories = realm.objects(Category.self)
                        realm.delete(categories)
                        
                        let sub_categories = realm.objects(SubCategory.self)
                        realm.delete(sub_categories)
                        
                        for user in model.users {
                            let u = User()
                            u.first_name = user.first_name
                            u.last_name = user.last_name
                            u.password = user.password
                            u.email = user.email
                            u.phone = user.phone
                            realm.add(u)
                        }
                        for filter in model.filters {
                            let f = CourseFilter()
                            f.filters.append(objectsIn: filter.filters)
                            f.type = filter.type
                            f.section = filter.section
                            realm.add(f)
                        }
                        for category in model.categories {
                            let c = Category()
                            c.name = category.name
                            realm.add(c)
                            
                            for sub_category in category.sub_categories {
                                let sub = SubCategory()
                                sub.name = sub_category
                                sub.category = c
                                realm.add(sub)
                            }
                        }
                    }
                    
                    try! realm.write {
                        var errors = [String]()
                        for course in model.courses {
                            let c = Course()
                            c.language = course.language
                            c.latitude = course.latitude
                            c.longitude = course.longitude
                            c.price = course.price
                            if let image = course.image {
                                c.image = image
                            }
                            c.title = course.title
                            if let status = course.status {
                                if status == "open" {
                                    c.status = .open
                                } else if status == "active" {
                                    c.status = .active
                                } else if status == "completed" {
                                    c.status = .completed
                                } else {
                                    c.status = .draft
                                }
                            }
                            
                            if let createdBy = realm.objects(User.self).where({$0.email == course.created_user_email}).first {
                                c.createdBy = createdBy
                            } else {
                                errors.append("No user found with email = \(course.created_user_email)")
                                continue
                            }
                            
                            if let category = realm.objects(Category.self).where({$0.name == course.category }).first {
                                if let sub_category = realm.objects(SubCategory.self).where({$0.category == category && $0.name == course.sub_category}).first {
                                    c.subCategory = sub_category
                                } else {
                                    errors.append("No subcategory found with name = \(course.sub_category)")
                                    continue
                                }
                            } else {
                                errors.append("No category found with name = \(course.category)")
                                continue
                            }
                            realm.add(c)
                        }
                        print("Error: ", errors)
                    }
                    

                }
            }
        }
    }
    
}

