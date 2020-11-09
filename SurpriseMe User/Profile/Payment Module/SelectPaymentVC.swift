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
        
        
        let alert = UIAlertController(title: "", message: "This feature is coming soon", preferredStyle: UIAlertController.Style.alert)
        //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        //
        //
        //        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
        
    }
    
    @IBAction func btnCashAction(_ sender: UIButton) {
        
        if arrayCardListCommom.count > 0{
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "SelectPayMentTypeVC") as! SelectPayMentTypeVC
                          navigationController?.pushViewController(controller, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
                          navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    

}
