//
//  IdelPaymentVC.swift
//  SurpriseMe User
//
//  Created by Apple on 10/11/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Stripe
import DropDown
import SafariServices

enum IDEALBank: Int, CaseIterable {
    case ABNAMRO = 0,
         ASNBank,
         Bunq,
         Handlesbanked,
         ING,
         Knab,
         Moneyou,
         Rabobank,
         RegioBank,
         SNSBank,
         TriodosBank,
         VanLoschot
    
    var displayName: String {
        switch self {
        case .ABNAMRO:
            return "ABN AMRO"
        case .ASNBank:
            return "ASN Bank"
        case .Bunq:
            return "Bunq"
        case .Handlesbanked:
            return "Handlesbanken"
        case .ING:
            return "ING"
        case .Knab:
            return "Knab"
        case .Moneyou:
            return "Moneyou"
        case .Rabobank:
            return "Rabobank"
        case .RegioBank:
            return "RegioBank"
        case .SNSBank:
            return "SNS Bank (De Volksbank)"
        case .TriodosBank:
            return "Triodos Bank"
        case .VanLoschot:
            return "Van Lanschot"
        }
    }
    
    //    var stripeCode: String {
    //        switch self {
    //        case .ABNAMRO:
    //            return "abn_amro"
    //        case .ASNBank:
    //            return "asn_bank"
    //        case .Bunq:
    //            return "bunq"
    //        case .Handlesbanked:
    //            return "handelsbanken"
    //        case .ING:
    //            return "ing"
    //        case .Knab:
    //            return "knab"
    //        case .Moneyou:
    //            return "moneyou"
    //        case .Rabobank:
    //            return "rabobank"
    //        case .RegioBank:
    //            return "regiobank"
    //        case .SNSBank:
    //            return "sns_bank"
    //        case .TriodosBank:
    //            return "triodos_bank"
    //        case .VanLoschot:
    //            return "van_lanschot"
    //        }
    //    }
}



class IdelPaymentVC: UIViewController {
    private let bankPicker = UIPickerView()
    var idelViewModel = IdelPaymentModel()
    private var paymentIntentClientSecret: String?
    @IBOutlet weak var dropDownView: UIView!
    let dropDown = DropDown()
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewNameContainer: UIView!
    
    
    var bookingID = Int()
    var bankName = ["ABN AMRO", "ASN Bank", "Bunq","Handlesbanken","ING","Knab","Moneyou","Rabobank","RegioBank","SNS Bank (De Volksbank)","Triodos Bank","Van Lanschot"]
    var bankStripeCode = ["abn_amro","asn_bank","bunq","handelsbanken","ing","knab","moneyou","rabobank","regiobank","sns_bank","triodos_bank","van_lanschot"]
    
    var bankCode = ""
    var isNext = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idelViewModel.delegate = self
        dropDown.anchorView = dropDownView
        
        dropDown.dataSource = bankName
        self.startCheckout()
        bookingID = bookingPaymentID ?? 0
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            //            dropDown.hide()
            self.bankCode = self.bankStripeCode[index]
            self.lblBankName.text = item
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        LoaderClass.shared.stopAnimation()
        
    }
    
    @IBAction func showDropDownOnPress(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:  true)
    }
    
    @IBAction func btnNextOnPress(_ sender: UIButton) {
        
        if  self.lblBankName.text == "Select Bank"{
            
            self.showToast(message: "Select Bank", font: .systemFont(ofSize: 12.0))

            
        }else if isNext == false {
            self.showToast(message: "Enter Name", font: .systemFont(ofSize: 12.0))

        }
        
        else{
           self.pay()
        }
        
    }
    
    func startCheckout() {
        let param = ["id":bookingPaymentID ?? 0]
        self.idelViewModel.getLoginData(param: param)
    }
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if restartDemo {
                alert.addAction(UIAlertAction(title: "Restart demo", style: .cancel) { _ in
                    self.startCheckout()
                })
            }
            else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    func pay() {
        
        idealPayment = true
        NotificationCenter.default.post(name: .myNotificationKey, object: self.index, userInfo: ["idealPayment": true])
        LoaderClass.shared.loadAnimation()
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        
        let iDEALParams = STPPaymentMethodiDEALParams()
        iDEALParams.bankName = bankCode
        // Collect customer information
        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.name = txtUserName.text
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        
        paymentIntentParams.paymentMethodParams = STPPaymentMethodParams(iDEAL: iDEALParams,
                                                                         billingDetails: billingDetails,
                                                                         metadata: nil)
       paymentIntentParams.returnURL = "surpriseme://stripe-redirect"
        
        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams,
                                                  authenticationContext: self)
        { (handlerStatus, paymentIntent, error) in
            switch handlerStatus {
            case .succeeded:
                idealPayment = true
                var param = ["booking_id":bookingPaymentID ?? 0 , "status": "confirmed" , "payment_method": "ideal"] as [String : Any]
                param["payment_params"] = ["clientSecret":paymentIntent?.clientSecret ?? "" as Any ,"paymentMethodId":paymentIntent?.paymentMethodId ?? "","created":paymentIntent?.created ?? ""]
            case .canceled:
                self.displayAlert(title: "Canceled",
                                  message: error?.localizedDescription ?? "",
                                  restartDemo: false)
            case .failed:
                self.displayAlert(title: "Payment failed",
                                  message: error?.localizedDescription ?? "",
                                  restartDemo: false)
            @unknown default:
                fatalError()
            }
        }
    }
}

extension IdelPaymentVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension IdelPaymentVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return IDEALBank.allCases.count
    }
}

extension IdelPaymentVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let bank = IDEALBank(rawValue: row) else {
            return nil
        }
        
        return bank.displayName
    }
}

extension IdelPaymentVC:IdelViewModelProtocol{
    func idelApiResponse(message: String, response: [String : Any], isError: Bool) {
        if isError == false{
            print(response)
            if let clientkey = response["client_secret"] as? String{
                self.paymentIntentClientSecret = clientkey
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
    
    func getPaymentForBooking(param: [String: Any]) {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.changeBookingStatus, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            NotificationCenter.default.post(name: .myNotificationKey, object: self.index, userInfo: ["idealPayment": true])
                            
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
                    //                                             self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                }
            }
            
        }else{
            Helper.showOKAlert(onVC: self, title: "Error", message: "Network Error")
            //                         self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
}


extension IdelPaymentVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let userEnteredString = txtUserName.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != ""{
            self.btnNext.backgroundColor = UIColor.init(red: 230/255, green: 0/255, blue: 83/255, alpha: 1)
            isNext = true
        } else {
            self.btnNext.backgroundColor = UIColor.init(red: 203/255, green: 203/255, blue: 203/255, alpha: 1)
            isNext = false
         }
        return true
    }
}

extension Notification.Name {
    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
}
