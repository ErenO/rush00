//
//  ViewController.swift
//  rush00
//
//  Created by Eren Ozdek on 18/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let UID = "d3b16514976a970424adee2ee2460a91a2a484f3e70ac70ed6c6ce4316cbe8a4"
    let SECRET = "4ad66ff5c67dbc8f51a86d724da7438d1b3e2543f3a1e63d39fc9f5f8454284c"
    var token: String?
	
	
	@IBAction func unwindtoConnect(segue: UIStoryboardSegue) {
		let session = UserDefaults.standard
		session.removeObject(forKey: "access_token")
		session.removeObject(forKey: "token")
		session.synchronize()
	}
	
    @IBAction func connectBtn(_ sender: Any) {
        authenticateUser()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		let session = UserDefaults.standard
		print("before2")
		print(session.string(forKey: "access_token"))
		print("after2")
		if session.string(forKey: "access_token") != nil {
			performSegue(withIdentifier: "auth", sender: self)
		}

	}
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getToken()
//
//		let session = UserDefaults.standard
//		print("before1")
//		print(session.string(forKey: "access_token"))
//		print("after1")
//		if session.string(forKey: "access_token") != nil {
//			performSegue(withIdentifier: "auth", sender: self)
//		}

//        authenticateUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticateUser() {
        let redirectUri = "rush01://rush01".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(self.UID)&redirect_uri=\(redirectUri!)&response_type=code&scope=public&state=coucou"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("url error")
        }
    }
    
    func getToken() {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        let session = UserDefaults.standard
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(self.UID)&client_secret=\(self.SECRET)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                        if let response = dic["access_token"] {
                            self.token = response as? String
                            session.set(dic.value(forKey: "access_token"), forKey: "token")
                            session.synchronize()
                            print(">>\(self.token!)<<")
                        }
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "auth" {
			
		}
	}
}
