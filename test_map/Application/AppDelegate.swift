//
//  AppDelegate.swift
//  test_map
//
//  Created by Evgeny on 19.08.2022.
//

import UIKit
import YandexMapsMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let home = TabBar()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
                        // do only pure app launch stuff, not interface stuff
                    } else {
                        window = UIWindow(frame: UIScreen.main.bounds)
                        UIApplication.shared.windows.first?.rootViewController = home
                        window?.makeKeyAndVisible()
                    }
        
        YMKMapKit.setApiKey(yandexMapAPI)
        YMKMapKit.setLocale("en_US")
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}



