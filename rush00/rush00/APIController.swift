//
//  APIController.swift
//  rush00
//
//  Created by Eren Ozdek on 17/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate: APIIntraDelegate?
    var token: String
    var login: String
	var responseJSON = [String: NSDictionary]()
	static let BASE_URL = "https://api.intra.42.fr/"

    init(delegate: APIIntraDelegate, token: String, login: String) {
        self.delegate = delegate
        self.token = token
        self.login = login
    }
    
    func reqIntra() {
    
    }
    
    func modifyMsg() {
    }
    
    func delecteMsg() {
    }
	
	func getTopics() {
		print("sdfsdfsdffffffffsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfssdfsdfsdf")
		makeRequest(to: "/v2/topics", method: "GET")
		print(self.responseJSON)
	}

	func makeRequest(to: String, method: String) {
		let url = URL(string: APIController.BASE_URL + to)
		
		let request = NSMutableURLRequest(url: url!)
		request.httpMethod = method
		request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
				print(response ?? "response is nil")
			if let err = error {
				print(err)
			}
			else if let d = data {
				do {
					if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
						self.responseJSON[to] = dic
					}
				} catch (let err) {
					print (err)
				}
			}
		}
		task.resume()
	}

    func showTopics() {
        let url = URL(string: "https://api.intra.42.fr/v2/me/topics")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        print("hello")
        //request2.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task2 = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
//            print(response)
            if let err = error {
                print("NONNNNN")
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                        print("bonjour")
                        print(dic)
                    }
                } catch (let err) {
                    print("NEIN!")
                    print (err)
                }
            }
        }
        task2.resume()
    }
    
    func addMsg() {
    }
    
    func disconnect() {
    }
}
