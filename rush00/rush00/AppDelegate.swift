//
//  AppDelegate.swift
//  rush00
//
//  Created by Eren Ozdek on 17/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var code: String?
    var window: UIWindow?
//    weak var delegate: APIIntraDelegate?
    
//    var token: String
//    var activate = UIApplication.shared.delegate as! ViewController
    
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		let code = url.absoluteString.components(separatedBy: "&")[0].components(separatedBy: "=")[1]
//		print("code === \(code)")
//		self.getAccessToken(code: code)
//        self.delegate?.getApiCode(code)
//        print("chier")
//        self.code = code
//        ViewController.code = code
//        ViewController.getApiCode(code)
        print("bonjour")
        ViewController.getAccessToken(code: code)
//        activate.getApiCode(code)
		return true
	}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

