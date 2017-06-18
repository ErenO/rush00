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
	var pageNb: Int = 1
		
	@IBOutlet weak var tableView: UITableView!

	@IBAction func addTopicBtn(_ sender: Any) {
		self.performSegue(withIdentifier: "addTopic", sender: self)
	}
	
	@IBAction func nextPage(_ sender: UIBarButtonItem) {
		self.pageNb += 1
		getTopics(page: pageNb)
	}

	@IBAction func logoutBtn(_ sender: Any) {
//		print("heldgflkfg")
		self.performSegue(withIdentifier: "logOut", sender: self)
	}

	override func viewDidAppear(_ animated: Bool) {
		let session = UserDefaults.standard

		if (session.string(forKey: "access_token") == nil || session.string(forKey: "token") == nil)
		{
			self.performSegue(withIdentifier: "logOut", sender: self)
		} else {
			getTopics(page: 1)
		}
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	@IBAction func plusBtn(_ sender: UIButton) {
	
		performSegue(withIdentifier: "msgSegue", sender: sender.tag)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		let session = UserDefaults.standard
		if (session.string(forKey: "access_token") == nil || session.string(forKey: "token") == nil)
		{
			self.performSegue(withIdentifier: "logOut", sender: self)
		}
		if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
		{
			print("asdfasdfsadfsdafasdfasf")
			// Don't animate
		}
////			print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
////			print(session.string(forKey: "access_token"))
////			print(session.string(forKey: "token"))
////			print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
//			print(topics)
//		}
//		tableView.delegate = self
//		tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getTopics(page: Int) {
		let session = UserDefaults.standard
		let url = URL(string: "https://api.intra.42.fr/v2/topics?page=\(page)")
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
			}
			else if let d = data {
				do {
					print(d)
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {

						DispatchQueue.main.async {
							for value in dic {
								let author: NSDictionary = (value["author"] as? NSDictionary)!
//								print(value["created_at"] ?? "NC")
//								print(value["name"])
							let elem = topic(login: (author["login"] as? String)!, date: (value["created_at"] as? String)!, title: (value["name"] as? String)!, topicId: (value["id"] as? Int)!)
								self.topics.append(elem)
								self.tableView.reloadData()
								}
							}
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

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.topics.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as? TopicTableViewCell {
			DispatchQueue.main.async {
				cell.login.text = self.topics[indexPath.row].login
				cell.date.text = self.topics[indexPath.row].date
				cell.title.text = self.topics[indexPath.row].title
				cell.btn.tag = indexPath.row
			}
			return cell
		}
		return UITableViewCell()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "logOut" {
			let session = UserDefaults.standard
			if (session.string(forKey: "access_token") != nil && session.string(forKey: "token") != nil)
			{
				session.removeObject(forKey: "access_token")
				session.removeObject(forKey: "token")
				session.synchronize()
			}
		}
		if segue.identifier == "msgSegue" {
			if let destinationView = segue.destination as? MsgViewController {
				if let id = sender as? Int {
					destinationView.topic_id = self.topics[id].topicId
					print(self.topics[id].topicId)
				}
			}
		}
		if segue.identifier == "addTopic" {
			
		}
	}
}
