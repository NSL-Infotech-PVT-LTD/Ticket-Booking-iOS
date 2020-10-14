//
//  ReviewVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var ReviewTableView: UITableView!
    
    //MARK:- Variable -
    var artistID = Int()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBack.addBottomShadow()
        
        //Mark:tableview delegate/datasource
        ReviewTableView.delegate = self
        ReviewTableView.dataSource = self
        ReviewTableView.reloadData()
    }
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ReviewVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell     
        return cell
    }
}
