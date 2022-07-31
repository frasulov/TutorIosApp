//
//  Category.swift
//  Tutor
//
//  Created by Fagan Rasulov on 27.07.22.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted(originProperty: "category") var subCategoires: LinkingObjects<SubCategory>
    
}
