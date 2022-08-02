//
//  models.swift
//  Tutor
//
//  Created by Fagan Rasulov on 02.08.22.
//

import Foundation


struct ModelUser: Codable {
    let first_name: String
    let last_name: String
    let email: String
    let phone: String
    let password: String
}

struct ModelCategory: Codable {
    let name: String
    let sub_categories: [String]
}


struct ModelFilter: Codable {
    let section: String
    let filters: [String]
    let type: CourseFilterType
}

struct ModelCourse: Codable {
    let title: String
    let image: String?
    let language: String?
    let price: Int?
    let latitude: Double?
    let longitude: Double?
    let category: String
    let sub_category: String
    let status: String?
    let created_user_email: String
}


struct ModelData: Codable {
    let run: Bool
    let users: [ModelUser]
    let categories: [ModelCategory]
    let filters: [ModelFilter]
    let courses: [ModelCourse]
}
