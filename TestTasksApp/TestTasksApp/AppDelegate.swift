//
//  AppDelegate.swift
//  TestTasksApp
//
//  Created by Maria Khamitsevich on 31/01/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: PhotoListFactory.makePhotoListScreen())
        window?.makeKeyAndVisible()
        return true
    }
}

