//
//  AppDelegate.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 17/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginViewController") as! UIViewController
        let searchViewController = mainStoryBoard.instantiateViewController(withIdentifier: "searchViewController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if Auth.auth().currentUser?.uid == nil {
            appDelegate.window?.rootViewController = logInViewController
        } else {
            appDelegate.window?.rootViewController = searchViewController
        }
        
        let db = Firestore.firestore()
        print(db)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyAsAeyNFUwWfB9jBeT0U6ZkZl6w7G9lkb4")
        GMSServices.provideAPIKey("AIzaSyAsAeyNFUwWfB9jBeT0U6ZkZl6w7G9lkb4")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "JeuSetMatch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

