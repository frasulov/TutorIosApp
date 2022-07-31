//
//  SubCategory.swift
//  Tutor
//
//  Created by Fagan Rasulov on 27.07.22.
//

import Foundation
import RealmSwift

class SubCategory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var category: Category?
    @Persisted(originProperty: "subCategory") var courses: LinkingObjects<Course>
}
