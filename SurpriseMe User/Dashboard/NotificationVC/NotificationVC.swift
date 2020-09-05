//
//  NotificationVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 26/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var NotificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: UIView Shadow
        //self.viewBack.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 3, blur: 3, spread: 2)
        //Mark:tableview delegate/datasource
        NotificationTableView.delegate = self
        NotificationTableView.dataSource = self
        NotificationTableView.reloadData()
        
    }
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.back()
    }    
}

extension NotificationVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        }
     
        return cell
    }
}
