//
//  ManageAddressVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 30/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ManageAddressVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var tblAddress: UITableView!
    
    //MARK:- Variables -
    var objectViewModel = ManageAddressViewModel()
    var modelObject = [ManageAddressModel]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.SetInititialSetup()
    }
    
    func SetInititialSetup()  {
        self.tabBarController?.tabBar.isHidden = true
        let view = UIView()
        tblAddress.tableFooterView = view
        tblAddress.estimatedRowHeight = 68.0
        tblAddress.rowHeight = UITableView.automaticDimension
        objectViewModel.delegate = self
        objectViewModel.getParamForManageAddress(param: [:])
    }
    
    //MARk:- Custom Button's Action -
    @IBAction func btnAddAddress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectAddressTypeVC") as! SelectAddressTypeVC
        navigationController?.pushViewController(controller, animated: false)
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    @objc func btnDeleteTapped(_ sender: UIButton){
      // use the tag of button as index
      let modelData = modelObject[sender.tag]
        let param = ["id":modelData.id]
        
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete?", preferredStyle: UIAlertController.Style.alert)
               // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
                          // do something like...
                    self.objectViewModel.getParamForDeleteAddress(param: param as [String : Any])
                      }))
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
              
               self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ManageAddressVC :UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderAddressCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if modelObject.count > 0{
            return modelObject.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomManageAddressCell
        let data = modelObject[indexPath.row]
        cell.lblAddress.text = "\(data.name ?? "") \(data.street_address ?? "") \(data.city ?? "") \(data.state ?? "")  \(data.country ?? "") \(data.zip ?? 0)"
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
//        cell.btnEdit.addTarget(self, action: #selector(btnEditTapped(_:)), for: .touchUpInside)
 cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped(_:)), for: .touchUpInside)
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
}


//Error handling Signup Api Here:-
extension ManageAddressVC: ManageAddressViewModelProtocol {
    func manageAddressApiResponse(message: String, modelArray response:  [ManageAddressModel],isError :Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "OK") {
            }
        }else{
            modelObject = response
            self.tblAddress.reloadData()
        }
        
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
    
    func successAlert(susccessTitle: String, successMessage: String)
    {
        self.objectViewModel.getParamForManageAddress(param: [:])
        Helper.showOKAlertWithCompletion(onVC: self, title: "", message: successMessage, btnOkTitle: "OK") {

                   }
    }
    
}
