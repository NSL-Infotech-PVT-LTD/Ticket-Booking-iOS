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
    @IBOutlet weak var viewHeader: UIView!
    
    
    @IBOutlet weak var noDataFound: UIView!
    //MARK:- Variables -
    var objectViewModel = ManageAddressViewModel()
    var modelObject = [ManageAddressModel]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.SetInititialSetup()
        self.viewHeader.addBottomShadow()
    }
    
    func SetInititialSetup()  {
        self.tabBarController?.tabBar.isHidden = true
        let view = UIView()
        self.tblAddress.isHidden = true
        self.noDataFound.isHidden = true

        tblAddress.tableFooterView = view
        tblAddress.estimatedRowHeight = 75.0
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
    
    
    
    
    
    @objc func btnEditTapped(_ sender: UIButton){
    // use the tag of button as index
    let modelData = modelObject[sender.tag]
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "UpdateLocationVC") as! UpdateLocationVC
        controller.isEdit = true
        controller.modelObjectDict = modelData
               navigationController?.pushViewController(controller, animated: false)
        
        
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
        cell.lblAddressType.text = "\(data.name ?? "")"
        cell.lblAddress.text = " \(data.street_address ?? "") "
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        if data.name == "Home"{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 71")
        }else if data.name == "Work"{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 72")
        }else{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 70")
        }
        cell.btnEdit.addTarget(self, action: #selector(btnEditTapped(_:)), for: .touchUpInside)
       cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped(_:)), for: .touchUpInside)
        
        cell.viewContainer.layer.cornerRadius = 8
                      cell.viewContainer.layer.shadowColor = UIColor.darkGray.cgColor
                      cell.viewContainer.layer.shadowOpacity = 1
                      cell.viewContainer.layer.shadowRadius = 3
                      //MARK:- Shade a view
                      cell.viewContainer.layer.shadowOpacity = 0.5
                      cell.viewContainer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                      cell.viewContainer.layer.masksToBounds = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataItem = modelObject[indexPath.row]
        currentAddress = dataItem.street_address ?? ""
        locationCurrentTitle = dataItem.name ?? ""
        customAddress = true
        currentLat = dataItem.lat ?? 0.0
        currentLong = dataItem.long ?? 0.0
        self.back()
    }
    
}


//Error handling Signup Api Here:-
extension ManageAddressVC: ManageAddressViewModelProtocol {
    func addAddress() {
        
    }
    
    func successAlert(susccessTitle: String, successMessage: String, from: Bool) {
        
        if from == false{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: successMessage, btnOkTitle: "OK") {
                self.objectViewModel.getParamForManageAddress(param: [:])
                      }
        }
        
    }
    
    func manageAddressApiResponse(message: String, modelArray response:  [ManageAddressModel],isError :Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "OK") {
            }
        }else{
            modelObject = response
            if modelObject.count == 0{
                self.tblAddress.isHidden = true
                self.noDataFound.isHidden = false

            }else{
                self.tblAddress.isHidden = false
                self.noDataFound.isHidden = true
            }
            
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
