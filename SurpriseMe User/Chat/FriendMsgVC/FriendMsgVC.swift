//
//  FriendMsgVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class FriendMsgVC: UIViewController {

    @IBOutlet weak var msgTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Mark:tableview delegate/datasource
        msgTableView.delegate = self
        msgTableView.dataSource = self
        msgTableView.reloadData()
    }
    @IBAction func btnBAckOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension FriendMsgVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "recievedTableViewCell", for: indexPath) as! recievedTableViewCell
            cell1.receiveView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 20)//Common function call
            return cell1
        
        }else if indexPath.section == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "sendTableViewCell", for: indexPath) as! sendTableViewCell
            cell2.sendView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)//Common function call
            return cell2
       
        } else{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "typingTableViewCell", for: indexPath) as! typingTableViewCell
            cell3.typingView.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft], radius: 20)//Common function call
            return cell3
        }
    }
}
