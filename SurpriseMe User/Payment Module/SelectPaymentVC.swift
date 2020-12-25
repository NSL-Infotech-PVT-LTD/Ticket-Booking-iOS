//
//  SelectPaymentVC.swift
//  SurpriseMe User
//
//  Created by NetScape Labs on 11/6/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SelectPaymentVC: UIViewController {
    
    
    @IBOutlet var viewHeader: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewHeader.addBottomShadow()
        self.getCard()

        // Do any additional setup after loading the view.
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
                    
                    arrayCardListCommom.removeAll()
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let dataDict = GetCardModel.init(resposne: index)
                                    arrayCardListCommom.append(dataDict)
                                }
                            }
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
    

    @IBAction func btnIdealAction(_ sender: UIButton) {
        
        //        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
        //        navigationController?.pushViewController(controller, animated: true)
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IdelPaymentVC") as! IdelPaymentVC
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {

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
    
    
    @IBAction func btnCashAction(_ sender: UIButton) {
        
        if arrayCardListCommom.count > 0{
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
            controller.isBookingDetails = true
            navigationController?.pushViewController(controller, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
            controller.isBookingDetails = true
            controller.isMoreCount = true
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    

}
