//
//  TopicViewController.swift
//  rush00
//
//  Created by Samuel TOUSSAY on 6/18/17.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var topics: [topic] = []
    
	@IBOutlet weak var tableView: UITableView!
	@IBAction func logoutBtn(_ sender: Any) {
		print("heldgflkfg")
		let session = UserDefaults.standard
		session.removeObject(forKey: "access_token")
		session.removeObject(forKey: "token")
		session.synchronize()
		self.performSegue(withIdentifier: "logOut", sender: self)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		getTopics()
//		tableView.delegate = self
//		tableView.dataSource = self
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
		print(session.string(forKey: "access_token")!)
		let token = session.string(forKey: "access_token")!
		request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
			print(response ?? "response is nil")
			if let err = error {
				print(err)
				session.removeObject(forKey: "access_token")
				session.removeObject(forKey: "token")
				session.synchronize()
				self.performSegue(withIdentifier: "logOut", sender: self)
			}
			else if let d = data {
				do {
					print(d)
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
						
												print(dic[0])
						for value in dic {
							//							print(topic["author"] ?? "NC")
							let author: NSDictionary = (value["author"] as? NSDictionary)!
//							print(author["login"])
							print(value["created_at"] ?? "NC")
							print(value["name"])
//							let msg: NSDictionary = (dic["name"] as? NSDictionary)!
//							let content: NSDictionary = (msg["content"] as? NSDictionary!)!
//							let str = content["html"] as! String
//							
//							let dateFormatter = DateFormatter()
//							dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//"EEE MMM dd HH:mm:ss Z yyyy"
//							let strDate = dateFormatter.date(from: value["created_at"] as! String)
//							dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//							let strDateF = dateFormatter.string(from: strDate!)
//							print(strDate)
//							print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
//							
//							print(strDateF)
//							print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

//							print(str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
							let elem = topic(login: (author["login"] as? String)!, date: (value["created_at"] as? String)!, title: (value["name"] as? String)!)
							self.topics.append(elem)
							self.tableView.reloadData()
							//							print(topic["message"] ?? "NC")
						}
						//						session.set(dic.value(forKey: "access_token"), forKey: "token")
						//						session.synchronize()
					}
				} catch (let err) {
					session.removeObject(forKey: "access_token")
					session.removeObject(forKey: "token")
					session.synchronize()
					self.performSegue(withIdentifier: "logOut", sender: self)
				}
			}
		}
		task.resume()
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.topics.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as? TopicTableViewCell {
			cell.login.text = self.topics[indexPath.row].login
			cell.date.text = self.topics[indexPath.row].date
			cell.title.text = self.topics[indexPath.row].title
			return cell
		}
		return UITableViewCell()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "logOut" {}
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "logout" {}
//	}
}
