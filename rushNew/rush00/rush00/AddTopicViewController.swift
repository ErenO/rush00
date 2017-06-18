//
//  AddTopicViewController.swift
//  rush00
//
//  Created by Eren Ozdek on 18/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class AddTopicViewController: UIViewController {

	@IBOutlet weak var titleTxt: UITextField!
	@IBOutlet weak var textTxt: UITextView!
	
	@IBAction func doneBtn(_ sender: Any) {
		addTopic()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func addTopic() {
		print("kdjhjhsdbfhdsjbfhjdsb>>>>>RENTRE")
		let session = UserDefaults.standard
		let author = session.string(forKey: "author_id")!
		print("author id === \(author)")
		let tab = [
				"topic": [
				"author_id": author,
				"cursus_ids": [
							"1"
				],
				"kind": "normal",
				"language_id": "3",
				"name": "The daily unicorn #837 🦄",
				"tag_ids": [
							"13",
							"8",
							"7"
				],
				"messages_attributes" : [
					[
					"content":"content",
					"author_id": author
					]
					]
				]
		]
		
		
		
		let url = URL(string: "https://api.intra.42.fr/v2/topics")
		let request = NSMutableURLRequest(url: url!)
		request.httpMethod = "POST"
		
		do {
			let jsonObj = try JSONSerialization.data(withJSONObject: tab, options: [])
			print("JSON CREATED\(jsonObj)>>>>>>>>>>>>>>>>>>>>>")
			request.httpBody = jsonObj
		} catch (let err) {
			print(err)
		}
		
		print("}}}}}}}}}}}}}}")
		print(session.string(forKey: "access_token"))
		let token = session.string(forKey: "access_token")!
		request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//		request.httpBody = jsonObj
		let task = URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
			print(response)
			if let err = error {
				print(err)
				session.removeObject(forKey: "access_token")
				session.removeObject(forKey: "token")
				session.synchronize()
			}
			else if let d = data {
				do {
					print("DEA>>>>>DANDNNDANDa")
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
						print(dic)
					}
				} catch (let err) {
					session.removeObject(forKey: "access_token")
					session.removeObject(forKey: "token")
					session.synchronize()
				}
			}
		}
		task.resume()
		
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
