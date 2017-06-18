//
//  RespViewController.swift
//  rush00
//
//  Created by Samuel TOUSSAY on 6/18/17.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import UIKit

class RespViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var msgId: Int?
	var resps: [resp] = []
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		print(">>>MSSSSSSSGIIIDDDD>\(self.msgId ?? 0)<<<<")
		if let id = msgId  {
			getResponses(msgId: id)
		}
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

//	override func viewDidAppear(_ animated: Bool) {
//		
//	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getResponses(msgId: Int) {
		print("in get responesagads")
		let session = UserDefaults.standard
		let url = URL(string: "https://api.intra.42.fr/v2/messages/\(msgId)/messages")
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
					print("plus loin >>>")
					print(d)
					if let dic : [NSDictionary] = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
						
												print(dic)
						DispatchQueue.main.async {
							for value in dic {
								let author: NSDictionary = (value["author"] as? NSDictionary)!
//								print("id msg == \(value["id"])")
								let elem = resp(login: (author["login"] as? String)!, txt: (value["content"] as? String)!, date: (value["created_at"] as? String)!)
								self.resps.append(elem)
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

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.resps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "respCell", for: indexPath) as? RespTableViewCell {
			DispatchQueue.main.async {
				cell.login.text = self.resps[indexPath.row].login
				cell.date.text = self.resps[indexPath.row].date
				cell.txt.text = self.resps[indexPath.row].txt
			}
			return cell
		}
		return UITableViewCell()
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
