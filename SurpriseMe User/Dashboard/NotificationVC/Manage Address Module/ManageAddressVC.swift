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
    @IBOutlet weak var btnAddadress: ZFRippleButton!
    
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var noDataFound: UIView!
    //MARK:- Variables -
    var objectViewModel = ManageAddressViewModel()
    var modelObject = [ManageAddressModel]()
    var index = -1
    
    var indexSelected = -1
    var selectedIndex = Int()
    var selectedAddress = ""
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
        tblAddress.estimatedRowHeight = 120.0
        tblAddress.rowHeight = UITableView.automaticDimension
        objectViewModel.delegate = self
        objectViewModel.getParamForManageAddress(param: [:])
    }
    
    //MARk:- Custom Button's Action -
    @IBAction func btnAddAddress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ManualAddressVC") as! ManualAddressVC
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
        isEditValue = true
        controller.isEdit = true
        controller.modelObjectDict = modelData
        modelObjectAdress = modelData
               navigationController?.pushViewController(controller, animated: false)
    }
    
    @objc func btnBookAction(_ sender: UIButton){
        
        let dataItem = modelObject[sender.tag]
        currentAddress = dataItem.street_address ?? ""
        locationCurrentTitle = dataItem.name ?? ""
        customAddress = true
        currentLat = dataItem.lat ?? 0.0
        currentLong = dataItem.long ?? 0.0
        index = sender.tag
        self.tblAddress.reloadData()
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
            self.back()
        }
    }
    
    @objc func btnDeleteTapped(_ sender: UIButton){
      // use the tag of button as index
      let modelData = modelObject[sender.tag]
        
        selectedIndex = sender.tag
        
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
        cell.btnSeeArtist12.tag = indexPath.row
        if data.street_address == selectedAddress || index == indexPath.row{
            cell.imgSelected.image = #imageLiteral(resourceName: "Selected")
        }else{
            cell.imgSelected.image = #imageLiteral(resourceName: "Ellipse 111")
        }
        
//        if indexSelected == indexPath.row{
//            cell.viewContainer.backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.5579355955, blue: 0.6253077388, alpha: 0.2)
//        }else{
//            cell.viewContainer.backgroundColor = UIColor.white
//        }
         if data.name == "Home"{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 71")
        }else if data.name == "Work"{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 72")
        }else{
            cell.addressTypeImg.image = UIImage.init(named: "Mask Group 70")
        }
        cell.btnEdit.addTarget(self, action: #selector(btnEditTapped(_:)), for: .touchUpInside)
       cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped(_:)), for: .touchUpInside)
        
        cell.btnSeeArtist12.tag = indexPath.row
        cell.btnSeeArtist12.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        
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
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomManageAddressCell
        selectedAddress = ""
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
        cell.viewContainer.cornerRadius = 1
        cell.viewContainer.layer.borderWidth = 1
//        cell.viewContainer.layer.borderColor = UIColor.red.cgColor
        cell.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewContainer.layer.masksToBounds = true
//        cell.viewContainer.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.viewContainer.backgroundColor = .lightGray
        let dataItem = modelObject[indexPath.row]
        currentAddress = dataItem.street_address ?? ""
        locationCurrentTitle = dataItem.name ?? ""
        customAddress = true
        currentLat = dataItem.lat ?? 0.0
        currentLong = dataItem.long ?? 0.0
        index = indexPath.row
        indexSelected = indexPath.row
        self.tblAddress.reloadData()

        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
            self.back()
        }
    }
    
}


//Error handling Signup Api Here:-
extension ManageAddressVC: ManageAddressViewModelProtocol {
    func addAddress() {
        
    }
    
    func successAlert(susccessTitle: String, successMessage: String, from: Bool) {
        
        if from == false{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: successMessage, btnOkTitle: "OK") {
                
                
                self.modelObject.remove(at: self.selectedIndex)
                self.tblAddress.reloadData()
//                self.objectViewModel.getParamForManageAddress(param: [:])
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
                self.btnAddadress.isHidden = false
                self.btnPlus.isHidden = true
            }else{
                self.btnAddadress.isHidden = true
                self.btnPlus.isHidden = false
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
