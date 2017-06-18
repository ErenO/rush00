//
//  MsgViewController.swift
//  rush00
//
//  Created by Samuel TOUSSAY on 6/18/17.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class MsgViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	var message: [msg] = []
	var topic_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
		getMessages(topicId: self.topic_id!)

//		print(">>>>\(self.topic_id ?? 0)<<<<")
        // Do any additional setup after loading the view.
    }
	
	@IBAction func respBtn(_ sender: UIButton) {
		if sender.tag != 0 {
			performSegue(withIdentifier: "respMsg", sender: sender.tag)
		}
	}
//	override func viewDidAppear(_ animated: Bool) {
////		getMessages(topicId: self.topic_id!)
//		tableView.rowHeight = UITableViewAutomaticDimension
//		tableView.estimatedRowHeight = 100
//	}

	override func viewWillAppear(_ animated: Bool) {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.message.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as? MsgTableViewCell {
			DispatchQueue.main.async {
				cell.login.text = self.message[indexPath.row].login
				cell.date.text = self.message[indexPath.row].date
				cell.txt.text = self.message[indexPath.row].msg
				cell.respBtn.tag = indexPath.row
			}
			return cell
		}
		return UITableViewCell()
	}
	
	
	func getMessages(topicId: Int) {
		let session = UserDefaults.standard
		let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages")
		let request = NSMutableURLRequest(url: url!)
		
		request.httpMethod = "GET"
		
		let token = session.string(forKey: "access_token")!
		request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
			if let err = error {
				print(err)
				session.removeObject(forKey: "access_token")
				session.removeObject(forKey: "token")
				session.synchronize()
			}
			else if let d = data {
				do {
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
						
						DispatchQueue.main.async {
							for value in dic {
								let author: NSDictionary = (value["author"] as? NSDictionary)!
								print("id msg == \(value["id"])")
								
								let elem = msg(login: (author["login"] as? String)!, msg:(value["content"] as? String)!, date: (value["created_at"] as? String)!, msgId: (value["id"] as? Int)!)
								self.message.append(elem)
								self.tableView.reloadData()
//								print(">>>\(self.message)<<<<")
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "respMsg" {
			if let destinationView = segue.destination as? RespViewController {
				if let id = sender as? Int {
					print(">>>>>>IDDDDDD>>>\(id)<<<<")
					if id != 0 {
						destinationView.msgId = self.message[id].msgId
					}
				}
			}
		}
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
