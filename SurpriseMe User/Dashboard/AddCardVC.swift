//
//  AddCardVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 30/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Stripe

class AddCardVC: UIViewController {
    
    
    @IBOutlet weak var lblCardDebit: UILabel!
    @IBOutlet weak var cctSecureTxt: UITextField!
    @IBOutlet var txtYYYY: UITextField!
    @IBOutlet var txtCVV: UITextField!
    @IBOutlet var txtCardHolderName: UITextField!
    @IBOutlet var txtCvv: UITextField!
    @IBOutlet var txtExpire: UITextField!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var txtCardNumber: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var lblCArdHolderNAme: UILabel!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblExpireCard: UILabel!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    var arrayExpire = ["11/2020","12/2020","1/2021","2/2021","3/2021","4/2021","5/2021"]
    let pickerView = UIPickerView()
    var months = String()
    var year = String()
    var isMoreCount = Bool()
    var isPaymenrt = Bool()
    var isBookingDetails = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCArdHolderNAme.text = "CARD_HOLDER_NAME".localized()
        txtCardHolderName.placeholder = "ENTER_NAME".localized()
        lblCardNo.text = "CARD_NUMBER".localized()
        lblExpireCard.text = "EXPIRE_CARD".localized()
        lblCVV.text = "CVV".localized()
        btnAddCard.setTitle("ADD_CARD_TITLE".localized(), for: .normal)
        btnBack.setTitle("back".localized(), for: .normal)
        lblCardDebit.text = "DEBIT_CREDIT_CARD".localized()
        self.viewHeader.addBottomShadow()
        //        self.createPickerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtYYYY.text = nil
        txtCVV.text = nil
        txtExpire.text = nil
        txtCardHolderName.text = nil
        txtCardNumber.text = nil
        if isMoreCount == true{
            btnAddCard.setTitle("PAY_NOW".localized(), for: .normal)
        }else{
            btnAddCard.setTitle("ADD_CARD_TITLE".localized(), for: .normal)
        }
    }
    
    func createPickerView() {
        pickerView.delegate = self
        txtExpire.delegate = self
        txtExpire.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtExpire.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
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
                            
                            self.navigationController?.pushViewController(controller1, animated: true)
                            self.dismiss(animated: true, completion: nil)
   
                        }
                        else{
//                            if let error_message = response["error"] as? String {
//                                Helper.showOKAlert(onVC: self, title: "Error", message: error_message)
//                            }
                            let storyboard1 = UIStoryboard(name: "Dashboard", bundle: nil)
                            let controller1 = storyboard1.instantiateViewController(withIdentifier: "SuccessPaymentVC") as! SuccessPaymentVC
                            idealPaymentFailed = true
                            self.navigationController?.pushViewController(controller1, animated: true)
                            
                            
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
                    //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    
    @IBAction func btnAddCardAction(_ sender: UIButton) {
        
        let buttonTitle = sender.titleLabel?.text
        
        if buttonTitle ?? "" == "Add Card"{
            isPaymenrt = false
        }else{
            isPaymenrt = true
            
        }
        
        
        self.getToken()
    }
    
    func getToken()  {
        
        if txtCardHolderName.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Account Holder Name", message: "")
        }else if txtCardNumber.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Card Number", message: "")
            
        }else if txtExpire.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Card Expire Month", message: "")
            
        }else if txtYYYY.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Expire Year", message: "")
            
        }else if txtCVV.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter CVV Number", message: "")
            
        } else{
            LoaderClass.shared.loadAnimation()
            
            
            //            txtExpire
            //
            //            txtExpire
            
            
            let cardParams = STPCardParams()
            cardParams.number = txtCardNumber.text!
            cardParams.name = txtCardHolderName.text!
            cardParams.expMonth = UInt(txtExpire.text ?? "") ?? 0
            cardParams.expYear = UInt(txtYYYY.text ?? "") ?? 0
            cardParams.cvc = txtCVV.text!
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil else {
                    // Present error to user...
                    LoaderClass.shared.stopAnimation()

                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    
                    
                    return
                }
                print(token.tokenId)
                self.addCardApi(token: token.tokenId)
                
            }
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
                            Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                        }
                    }
                    else {
                        Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
                else {
                    //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                }
            }
            
        }else{
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please check your internet connection")
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    func addCardApi(token : String)  {
        print("the token is \(token)")
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            let dict = ["token":token]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerAddCard, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            if self.isPaymenrt == true{
                                
                                let dataItem = result["data"] as? [String:Any]
                                let dataValue = dataItem?["data"] as? [String:Any]
                                
                                let param = ["booking_id":bookingPaymentID ?? 0 , "status":"confirmed" , "card_id":dataValue?["id"] ?? "","payment_method":"card"] as [String : Any]
                                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
                                let navController = UINavigationController(rootViewController: VC1)
                                navController.modalPresentationStyle = .overCurrentContext
                                navController.isNavigationBarHidden = true
                                self.present(navController, animated:true, completion: nil)
                                self.getPaymentForBooking(param: param)
                                
                                
                                
                            }else{
                                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                        else{
                            if let error_message = response["error"] as? String {
                                Helper.showOKAlert(onVC: self, title: "Error", message: error_message)
                            }
                        }
                    }
                    else {
                        if let error_message = response["error"] as? String {
                            Helper.showOKAlert(onVC: self, title: "Error", message: error_message)
                        }
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            Helper.showOKAlert(onVC: self, title: "Error", message: "Please Check your Internet Connection")
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if isBookingDetails == true{
        self.back()
        }else{
        let alert = UIAlertController(title: "If you click yes your booking will be canceled from on hold and other customer can book same slot.", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .default) { (alert) in
        }
        let confirm = UIAlertAction(title: "Yes", style: .destructive) { (alert) in
            let param = ["booking_id":bookingPaymentID ?? 0 , "status":"cancel"] as [String : Any]
            LoaderClass.shared.loadAnimation()
            self.callApiDeletebookingSlot(param: param)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert,animated: true)
        }
    }
    
    
}


extension AddCardVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }else if textField == txtCardNumber{
            let cardNumber = self.txtCardNumber.text
            if cardNumber?.count == 4{
                print("hello -")
                self.txtCardNumber.text = (cardNumber ?? "") + " - "
            }else if  cardNumber?.count == 11{
                print("hello -")
                self.txtCardNumber.text = (cardNumber ?? "") + " - "
            }else if  cardNumber?.count == 18{
                print("hello -")
                self.txtCardNumber.text = (cardNumber ?? "") + " - "
            }
            let maxLength = 25
            let currentString: NSString = (txtCardNumber.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == txtExpire{
            let maxLength = 2
            let currentString: NSString = (txtExpire.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == txtYYYY{
            let maxLength = 4
            let currentString: NSString = (txtYYYY.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == txtCVV{
            let maxLength = 4
            let currentString: NSString = (txtCVV.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
        }else{
            return true
        }
        return true
    }
    
}



extension AddCardVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayExpire.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayExpire[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let itemValue = arrayExpire[row]
        txtExpire.text = itemValue
        let array = itemValue.components(separatedBy: "/")
        months = array[0]
        year = array[1]
    }
    
}
