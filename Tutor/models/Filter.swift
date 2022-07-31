//
//  Filter.swift
//  Tutor
//
//  Created by Fagan Rasulov on 26.07.22.
//

import Foundation
import RealmSwift


enum CourseFilterType: String, PersistableEnum {
    case checkbox
    case dropdown
}

class CourseFilter: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var section: String
    @Persisted var filters: List<String>
    @Persisted var type = CourseFilterType.checkbox
}

class CourseFilterDto {
    var section: String = ""
    var filters = [String]()
}
