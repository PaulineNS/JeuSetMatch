//
//  AppDelegate.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 17/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
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
        let logInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginViewController") 
        let searchViewController = mainStoryBoard.instantiateViewController(withIdentifier: "searchViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if Auth.auth().currentUser?.uid == nil {
            logInViewController.modalPresentationStyle = .fullScreen
            appDelegate.window?.rootViewController = logInViewController
        } else {
            searchViewController.modalPresentationStyle = .fullScreen
            appDelegate.window?.rootViewController = searchViewController
        }
        if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterGender) == nil {
            UserDefaults.standard.set("Tout", forKey: Constants.UDefault.savedFilterGender)
        }
        if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterCity) == nil {
            UserDefaults.standard.set("Tout", forKey: Constants.UDefault.savedFilterCity)
        }
        if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterLevel) == nil {
            UserDefaults.standard.set("Tout", forKey: Constants.UDefault.savedFilterLevel)
        }

        let db = Firestore.firestore()
        print(db)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        GMSPlacesClient.provideAPIKey(Config.googleMapPlaceClientKey)
        GMSServices.provideAPIKey(Config.googleMapService)
        
        return true
    }
}

