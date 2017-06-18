//
//  AppDelegate.swift
//  rush00
//
//  Created by Eren Ozdek on 18/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let UID = "d3b16514976a970424adee2ee2460a91a2a484f3e70ac70ed6c6ce4316cbe8a4"
    let SECRET = "4ad66ff5c67dbc8f51a86d724da7438d1b3e2543f3a1e63d39fc9f5f8454284c"
//    var code: String?
    var access_token: String?
    var token: String?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let code = url.absoluteString.components(separatedBy: "&")[0].components(separatedBy: "=")[1]
//        self.code = code
        getAccessToken(code: code)
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

    
    func getAccessToken(code: String) {
        let session = UserDefaults.standard
        let redirectUri = "rush01://rush01"
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=authorization_code&client_id=\(self.UID)&client_secret=\(self.SECRET)&code=\(code)&redirect_uri=\(redirectUri)&state=coucou".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                        if let response = dic["access_token"] {
                            self.access_token = response as? String
                            print(">>>>>>>>>>>>>>>>\(self.access_token!)<<<<<<<<<<<<<e<<<<<<")
                            session.set(dic.value(forKey: "access_token"), forKey: "access_token")
                            session.synchronize()
                        }
//                        print(dic)
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }

}

