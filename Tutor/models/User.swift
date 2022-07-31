//
//  CustomUser.swift
//  Tutor
//
//  Created by Fagan Rasulov on 22.07.22.
//

import Foundation
import RealmSwift

class User: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var first_name: String?
    @Persisted var last_name: String?
    @Persisted(indexed: true) var email: String
    @Persisted var address: String = ""
    @Persisted var phone: String
    @Persisted var password: String
    @Persisted var created_at = Date()
    @Persisted(originProperty: "createdBy") var courses: LinkingObjects<Course>
    
    
    var name: String {
        return "\(first_name ?? "") \(last_name ?? "")"
    }
    
    
    
    
}
