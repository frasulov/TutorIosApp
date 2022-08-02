//
//  Course.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import Foundation
import RealmSwift

enum CourseStatus: Int, PersistableEnum, Codable {
    case draft
    case open
    case active
    case completed
}

class Course: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createdBy: User?
    @Persisted var title: String
    @Persisted var image = "defaultCourseImage"
    @Persisted var language: String?
    @Persisted var price: Int?
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var created_at = Date()
    @Persisted var subCategory: SubCategory?
    @Persisted var status = CourseStatus.draft
}
