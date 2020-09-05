//
//  BookingVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class BookingVC: UIViewController {
    
    @IBOutlet weak var viewBookingDash: UIView!
    @IBOutlet weak var BookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Mark:tableview delegate/datasource
         BookingTableView.delegate = self
         BookingTableView.dataSource = self
         BookingTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFilterOnPress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .coverVertical
        navController.isNavigationBarHidden = true
        self.present(navController, animated:true, completion: nil)
    }
    
    @objc func btnseeAllDetailsOnPress(sender: UIButton){
            let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            navigationController?.pushViewController(controller, animated: true)
    }
}
extension BookingVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
//        cell.viewBookingBorderDash.addDashedBorder( UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00), withWidth: 1, cornerRadius: 6, dashPattern: [5,4])
        cell.btnseeAllDetails.addTarget(self, action: #selector(btnseeAllDetailsOnPress(sender:)), for: .touchUpInside)
        cell.btnseeAllDetails.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)

    }
    
}
