//
//  AppDelegate.swift
//  Tutor
//
//  Created by Fagan Rasulov on 19.07.22.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // When you open the realm, specify that the schema
        // is now using a newer version.
        
        // Use this configuration when opening realms

        
//        let app = App(id: "tutorapp-lngie")
//        let apiKey = Credentials.userAPIKey("s3h93bI3dNGvfXKJxCyHzkE2DO8W3KmwYOSfO21CVTpRzOZ0nxXXA9tjVX56Plfg")
//        app.login(credentials: apiKey) { (result) in
//            switch result {
//            case .failure(let error):
//                print("Login failed: \(error.localizedDescription)")
//            case .success(let user):
//                print("Successfully logged in as user \(user)")
//                // Now logged in, do something with user
//                // Remember to dispatch to main if you are doing anything on the UI thread
//            }
//        }
//
//        let user = app.currentUser
//        let partitionValue = "Clifford"
////
////        realm = try! Realm(configuration: user.configuration(partitionValue: partitionValue))
//        var config = user!.configuration(partitionValue: partitionValue)
//        config.schemaVersion = 8
//        40.377022316833504, 49.859915048254784
        
        let config = Realm.Configuration(
            schemaVersion: 12)
        Realm.Configuration.defaultConfiguration = config
        

//        let realm = try! Realm()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tutor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
