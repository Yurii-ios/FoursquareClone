//
//  AppDelegate.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 15/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // inicualizacija Parse w kode
        let configuration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
           // wwodim tri parametra dlia podklu4enija k baze. zna4enija berem s sajta https://parse-dashboard.back4app.com/
            ParseMutableClientConfiguration.applicationId = "HuVqyxDO0na0TnKbIXkWWJMFPyRV1ZskYrSoyd9v"
            ParseMutableClientConfiguration.clientKey = "43PckKfXQqsa1ogrH2Js86WoNwWyPpkWSTSIhBGy"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        }
        
        Parse.initialize(with: configuration)
        
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


}

