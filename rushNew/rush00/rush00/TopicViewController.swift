//
//  TopicViewController.swift
//  rush00
//
//  Created by Samuel TOUSSAY on 6/18/17.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func getTopics() {
		let session = UserDefaults.standard
		let url = URL(string: "https://api.intra.42.fr/v2/topics")
		
		let request = NSMutableURLRequest(url: url!)
		request.httpMethod = "GET"
		request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(session.string(forKey: "access_token"))", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
			print(response ?? "response is nil")
			if let err = error {
				print(err)
			}
			else if let d = data {
				do {
					if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
						session.set(dic.value(forKey: "access_token"), forKey: "token")
						session.synchronize()
					}
				} catch (let err) {
					print (err)
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
