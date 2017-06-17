//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

//URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

//let UID = "d3b16514976a970424adee2ee2460a91a2a484f3e70ac70ed6c6ce4316cbe8a4"
//let SECRET = "4ad66ff5c67dbc8f51a86d724da7438d1b3e2543f3a1e63d39fc9f5f8454284c"
var ACCESS_TOKEN: String = ""
//
//let url = URL(string: "https://api.intra.42.fr/oauth/token")
//
//let request = NSMutableURLRequest(url: url!)
//request.httpMethod = "POST"
//request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
//request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
//
//let task = URLSession.shared.dataTask(with: request as URLRequest) {
//	(data, response, error) in
//	print(response)
//
//	if let err = error {
//		print(error)
//	}
//	else if let d = data {
//		do {
//			if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
//				print (dic)
//			}
//		} catch (let err) {
//			print (err)
//		}
//	}
//}
//
//task.resume()

ACCESS_TOKEN = "af1fc5bdcb3b5cbc177fecc65fa467e2f995f2f5fe33462ddf2649e102fe09ca"
let url = URL(string: "https://api.intra.42.fr/v2/me/topics")

let request = NSMutableURLRequest(url: url!)
request.httpMethod = "GET"
request.setValue("Bearer " + ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
//request2.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)

let task2 = URLSession.shared.dataTask(with: request as URLRequest) {
	(data, response, error) in
		print(response)
	print("asdfsdf........>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	
	if let err = error {
		print(err)
	}
	else if let d = data {
		do {
			print("asdfsdf........>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			print(try JSONSerialization.jsonObject(with: d, options: .mutableContainers))
			if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
				print("asdfsdf........>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

				print(dic)
//				if let dict: [NSDictionary] = dic["statuses"] as? [NSDictionary] {
//					for posts in dict {
//						print(posts["text"])
//						print(posts["created_at"])
//						if let user: NSDictionary = posts["user"] as? NSDictionary {
//							print(user["name"])
//						}
//					}
//				}
			}
		} catch (let err) {
			print (err)
		}
	}
}


task2.resume()

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true