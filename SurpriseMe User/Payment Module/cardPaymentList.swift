//
//  cardPaymentList.swift
//  Lanaguage Change
//
//  Created by Loveleen Kaur Atwal on 06/11/20.
//

import UIKit

class cardPaymentList: UIViewController {
    
    @IBOutlet weak var cardPaymentListTV: UITableView!
    
    var arrayCardList = [GetCardModel]()
    var arrayIndex = [Int]()
    var cardID = String()
    var arraySelectedzIndex = -1
    var arraySelectedzIndexCVV = -1

    
    @IBOutlet weak var lblSelectCard: UILabel!
    @IBOutlet weak var lblChooseMethod: UILabel!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var btnPayNow: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var noData: UILabel!
    @IBOutlet var viewHeader: UIView!
    var isBookingDetails = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark:tableview delegate/datasource
        self.getCard()
        self.viewHeader.addBottomShadow()
        noData.text = "NO_DATA".localized()
        noData.isHidden = true
        cardPaymentListTV.isHidden = true
        
        btnBack.setTitle("back".localized(), for: .normal)
        btnPayNow.setTitle("PAY_NOW".localized(), for: .normal)
        lblSelectCard.text = "SELECT_CARD".localized()
        lblChooseMethod.text = "CARD_METHOD".localized()
        btnAddCard.setTitle("ADD_CARD".localized(), for: .normal)
        
    }
    
    @IBAction func btnAddCardAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        controller.isBookingDetails = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btnPayNowAction(_ sender: UIButton) {
        
        let buttonTitle = sender.titleLabel?.text
        
        if buttonTitle ?? "" == "Add Card"{
            self.back()
        }else{
            
            if cardID == ""{
                Helper.showOKAlert(onVC: self, title: "SELECT_CARD".localized(), message: "")
            }else{
                let param = ["booking_id":bookingPaymentID ?? 0 , "status":"confirmed" , "card_id":cardID,"payment_method":"card"] as [String : Any]
                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
                let navController = UINavigationController(rootViewController: VC1)
                navController.modalPresentationStyle = .overCurrentContext
                navController.isNavigationBarHidden = true
                self.present(navController, animated:true, completion: nil)
                self.getPaymentForBooking(param: param)
            }
            
        }
        
    }
    
    
    func getCard() {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            let dict = ["search":"","limit":"20"]
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerCardList, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    self.arrayCardList.removeAll()
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let dataDict = GetCardModel.init(resposne: index)
                                    self.arrayCardList.append(dataDict)
                                }
                            }
                            
                            if self.arrayCardList.count > 0{
                                self.noData.isHidden = true
                                self.cardPaymentListTV.isHidden = false
                                
                            }else{
                                self.btnPayNow.setTitle("Add Card", for: .normal)
                                self.noData.isHidden = false
                                self.cardPaymentListTV.isHidden = true
                            }
                            
                            self.cardPaymentListTV.reloadData()
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? String {
                            Helper.showOKAlert(onVC: self, title: "Error", message: error_message)
                        }
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
            Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: "INTERNET_CONN".localized())
        }
    }
    
    
    
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        if isBookingDetails == true{
        self.back()
        }else{
            let alert = UIAlertController(title: "CANCEL_SLOT".localized(), message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "NO".localized(), style: .default) { (alert) in

        }
            let confirm = UIAlertAction(title: "YES".localized(), style: .destructive) { (alert) in
            let param = ["booking_id":bookingPaymentID ?? 0 , "status":"cancel"] as [String : Any]
            LoaderClass.shared.loadAnimation()
            self.callApiDeletebookingSlot(param: param)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)

        self.present(alert,animated: true)
        }
    }
    
    func callApiDeletebookingSlot(param: [String: Any]){
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
        if Reachability.isConnectedToNetwork() {
            // LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.changeBookingStatus, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                           let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                            let controller1 = storyboard1.instantiateViewController(withIdentifier: "DashboardTabBarController") as! DashboardTabBarController
                            
                            self.navigationController?.pushViewController(controller1, animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                        }
                    }
                    else {
                        Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                    }
                }
                else {
                    //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                    Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                }
            }
            
        }else{
            Helper.showOKAlert(onVC: self, title: "ALERT".localized(), message: "INTERNET_CONN".localized())
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    func getPaymentForBooking(param: [String: Any]) {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
        if Reachability.isConnectedToNetwork() {
            // LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.changeBookingStatus, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                self.dismiss(animated: true, completion: nil)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            let storyboard1 = UIStoryboard(name: "Dashboard", bundle: nil)
                            let controller1 = storyboard1.instantiateViewController(withIdentifier: "SuccessPaymentVC") as! SuccessPaymentVC
                            idealPayment = true
                            self.navigationController?.pushViewController(controller1, animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            if let error_message = response["error"] as? String {
                                Helper.showOKAlert(onVC: self, title: error_message, message: "")
                            }
                        }
                    }
                    else {
                        Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: "ERROR".localized(), message: error?.localizedDescription ?? "")
                    //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    @objc func btnBookAction(sender:UIButton)  {
        
        let dataItem = arrayCardList[sender.tag]
        
        let alert = UIAlertController(title: "", message: "CARD_REMOVE".localized(), preferredStyle: UIAlertController.Style.alert)
        //
        alert.addAction(UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.destructive, handler: { action in
            self.removeCard(cardNumber: dataItem.id ?? "")
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel, handler: nil))
        //
        //
        //        // show the alert
        self.present(alert, animated: true, completion: nil)
        //
        //
        
        
        
        
    }
    
    func removeCard(cardNumber : String)  {
        
        
        
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            let dict = ["card_id":cardNumber]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerdeleteCard, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.arraySelectedzIndex = -1
                            self.cardID = ""
                            self.getCard()
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }
                else {
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
        
    }
    
    
    
    
    
}

extension cardPaymentList : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardPaymentListCell", for: indexPath) as! cardPaymentListCell
        
        
        // cell.viewContainer.addShadowWithCornerRadius(viewObject: cell.viewContainer)
        let dataItem = arrayCardList[indexPath.row]
        
        if arrayCardList.count > 1{
            if arraySelectedzIndex == indexPath.row{
                cell.img.image = UIImage.init(named: "tick")
            }else{
                cell.img.image = UIImage.init(named: "untick")
            }
        }else{
            if arrayIndex.contains(indexPath.row){
                cell.img.image = UIImage.init(named: "tick")

            }else{
                cell.img.image = UIImage.init(named: "untick")

            }
            
        }
        
        
        cell.lblCVVV.text = "CVV".localized()
        cell.lblTitleExpires.text = "EXPIRE".localized()


        cell.viewContainer.layer.cornerRadius = 8
        cell.viewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viewContainer.layer.shadowOpacity = 1
        cell.viewContainer.layer.shadowRadius = 3
        //MARK:- Shade a view
        cell.viewContainer.layer.shadowOpacity = 0.5
        cell.viewContainer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.viewContainer.layer.masksToBounds = false
        cell.lblName.text = dataItem.name ?? ""
        cell.lblCardDetail.text = "**** - **** - **** \(dataItem.last4 ?? "")"
        cell.lblExpireMonth.text = "\(dataItem.exp_month ?? 0)/\(dataItem.exp_year ?? 0)"
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arraySelectedzIndex = indexPath.row
        
        
        if arrayCardList.count > 0 && arrayCardList.count < 2{
            if arrayIndex.count > 0{
                
                let indexOfA = arrayIndex.firstIndex(of: indexPath.row ) ?? 0
                arrayIndex.remove(at: indexOfA)
                cardID = ""
                
            }else{
                arrayIndex.append(indexPath.row)
                let dataItem = arrayCardList[0]
                cardID = dataItem.id ?? ""
            }
            
        }else{
            let dataItem = arrayCardList[indexPath.row]
            cardID = dataItem.id ?? ""
        }
        
       
        
       
        self.cardPaymentListTV.reloadData()
        
    }
    
}
