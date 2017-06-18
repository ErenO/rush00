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
		print(">>>>\(self.topic_id ?? 0)<<<<")
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		getMessages(topicId: self.topic_id!)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.message.count
	}
	
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}
//	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		print(tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as? MsgTableViewCell)
		if let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as? MsgTableViewCell {
//			DispatchQueue.main.async {
				cell.login.text = self.message[indexPath.row].login
				cell.date.text = self.message[indexPath.row].date
				cell.txt.text = self.message[indexPath.row].msg
				print(">>>>>\(cell)<<<<<")
//			}
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
					print("<<<<<<in getmsg >>>>>>>>>>>>>>>>>>>>>")
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
						
//						print(dic)
						DispatchQueue.main.async {
							for value in dic {
								let author: NSDictionary = (value["author"] as? NSDictionary)!
								//								print(value["created_at"] ?? "NC")
								//								print(value["name"])
//								print((author["login"] as? String)!)
//								print((value["created_at"] as? String)!)
//								print((value["content"] as? String)!)
								
								let elem = msg(login: (author["login"] as? String)!, msg: (value["created_at"] as? String)!, date: (value["content"] as? String)!)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
