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
    
    
    @IBOutlet var txtYYYY: UITextField!
    @IBOutlet var txtCVV: UITextField!
    @IBOutlet var txtCardHolderName: UITextField!
    @IBOutlet var txtCvv: UITextField!
    @IBOutlet var txtExpire: UITextField!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var txtCardNumber: UITextField!
    
    var arrayExpire = ["11/2020","12/2020","1/2021","2/2021","3/2021","4/2021","5/2021"]
    let pickerView = UIPickerView()
    var months = String()
    var year = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addBottomShadow()
        self.createPickerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtYYYY.text = nil
        txtCVV.text = nil
         txtCardHolderName.text = nil
        txtCardNumber.text = nil

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
    
    
    @IBAction func btnAddCardAction(_ sender: Any) {
        self.getToken()
    }
    
    func getToken()  {
        
        if txtCardHolderName.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Account Holder Name", message: "")
        }else if txtCardNumber.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Card Number", message: "")
            
        }else if txtExpire.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter Card Expire Date", message: "")
            
        }else if txtYYYY.text == ""{
            Helper.showOKAlert(onVC: self, title: "Enter CVV Number", message: "")
            
        }else{
            let cardParams = STPCardParams()
            cardParams.number = txtCardNumber.text!
            cardParams.name = txtCardHolderName.text!
            cardParams.expMonth = UInt(months) ?? 0
            cardParams.expYear = UInt(year) ?? 0
            cardParams.cvc = txtYYYY.text!
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil else {
                    // Present error to user...
                    
                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    
                    
                    return
                }
                print(token.tokenId)
                self.addCardApi(token: token.tokenId)
                
            }
        }
        
        
    }
    
    
    func addCardApi(token : String)  {
        print("the token is \(token)")
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            let dict = ["token":token]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerAddCard, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            // self.back()
                            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
                                self.navigationController?.pushViewController(controller, animated: true)
                            //                                                            self.arrayObject.removeAll()
                            //
                            //                                                            let dataDict = result["data"] as? [String : Any]
                            //                                                           if let dataArray = dataDict?["data"] as? [[String : Any]]{
                            //                                                                for index in dataArray{
                            //                                                                    print("the index value is \(index)")
                            //                                                                                                                      let dataDict = GetArtistListHomeModel.init(resposne: index)
                            //                                                                    self.arrayObject.append(dataDict)
                            //                                                                                                                  }
                            //                                                            }
                            //        //
                            //                                                            self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
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
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
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
            
        }else if textField == txtYYYY{
            let maxLength = 4
            let currentString: NSString = (txtCvv.text ?? "") as NSString
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
