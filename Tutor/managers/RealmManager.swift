//
//  RealmManager.swift
//  Tutor
//
//  Created by Fagan Rasulov on 31.07.22.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    
    @Published var realm: Realm?
    let app: App
    @Published var user: RealmSwift.User?
    @Published var config: Realm.Configuration?
    
    static let shared = RealmManager()
    
    private init() {
        self.app = App(id: "tutor-ios-app-gknqn")
    }
    
    @MainActor
    func initialize() {
        let apiKey = Credentials.userAPIKey("mFGGHOtdyo3EJdaNfsdYnMON5T5lF0SXjy5GkMvQKMyJAZ0MeIi2HbUw8M9YKBLK")
        user = app.login(credentials: apiKey)
        
        self.config = user?.flexibleSyncConfiguration(initialSubscriptions: { subs in
            if let _ = subs.first(named: "all-users") {
                return
            } else {
                subs.append(QuerySubscription<User>(name: "all-users"))
            }
        }, rerunOnOpen: true)
        
        realm = try! await Realm(configuration: self.config!, downloadBeforeOpen: .always)
        
    }
    
    
    
    
    
}

//let app = App(id: "tutor-ios-app-gknqn")
//let apiKey = Credentials.userAPIKey("mFGGHOtdyo3EJdaNfsdYnMON5T5lF0SXjy5GkMvQKMyJAZ0MeIi2HbUw8M9YKBLK")
//app.login(credentials: apiKey) { (result) in
//    switch result {
//    case .failure(let error):
//        print("Login failed: \(error.localizedDescription)")
//    case .success(let user):
//        print("Successfully logged in as user \(user)")
//        var config = user.flexibleSyncConfiguration()
//        config.schemaVersion = 13
//        Realm.Configuration.defaultConfiguration = config
//        let realm = try! Realm()
//    }
//}
