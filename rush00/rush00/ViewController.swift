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
    var topics: [Msg] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
//        makeReq()
    }

    func getToken() {
        let UID = "d3b16514976a970424adee2ee2460a91a2a484f3e70ac70ed6c6ce4316cbe8a4"
        let SECRET = "4ad66ff5c67dbc8f51a86d724da7438d1b3e2543f3a1e63d39fc9f5f8454284c"
//        var ACCESS_TOKEN: String = ""
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
        
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

