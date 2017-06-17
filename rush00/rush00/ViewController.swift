//
//  ViewController.swift
//  rush00
//
//  Created by Eren Ozdek on 17/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APIIntraDelegate {

	var token: String?
	static var access_token: String? {
		didSet {
			let api = APIController(delegate: self as! APIIntraDelegate, token: self.token!, login: "stoussay")
			api.getTopics()
		}
	}
    var topics: [Msg] = []
    static let UID = "d3b16514976a970424adee2ee2460a91a2a484f3e70ac70ed6c6ce4316cbe8a4"
    static let SECRET = "4ad66ff5c67dbc8f51a86d724da7438d1b3e2543f3a1e63d39fc9f5f8454284c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
		authenticateUser()
        print("sak")

    }

	func authenticateUser() {
		let redirectUri = "rush01://rush01".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
		let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(ViewController.UID)&redirect_uri=\(redirectUri!)&response_type=code&scope=public&state=coucou"
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			print("url error")
		}
	}

    func getToken() {
//        var ACCESS_TOKEN: String = ""
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(ViewController.UID)&client_secret=\(ViewController.SECRET)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
        	(data, response, error) in
//        	print(response)
        	if let err = error {
        		print(err)
        	}
        	else if let d = data {
        		do {
        			if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
        				if let response = dic["access_token"] {
                            self.token = response as? String
                            print(">>>>>>>>>>>>>>>>\(self.token!)<<<<<<<<<<<<<<<<<<<")
                            self.makeReq()
                        }
        			}
        		} catch (let err) {
        			print (err)
        		}
        	}
        }
        task.resume()
    }
    
    static func getAccessToken(code: String) {
        let redirectUri = "rush01://rush01"
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=authorization_code&client_id=\(ViewController.UID)&client_secret=\(ViewController.SECRET)&code=\(code)&redirect_uri=\(redirectUri)&state=coucou".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            //        	print(response)
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                        if let response = dic["access_token"] {
                            ViewController.access_token = response as? String
                            print(">>>>>>>>>>>>>>>>\(ViewController.access_token!)<<<<<<<<<<<<<ekfdslfn<<<<<<")
                        }
//                            print(dic)
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }
    
    func makeReq() {
        if self.token != nil {
            let api = APIController(delegate: self, token: self.token!, login: "stoussay")
            api.showTopics()
            print("show!")
        }
        print("merde")
    }
    
    func treatPost(_ post: [Msg]) {
        self.topics = post
        
    }
    
    func msgError(_ msg: String) {
        
    }
    
    
    func getUserInfo() {
        
    }
}

