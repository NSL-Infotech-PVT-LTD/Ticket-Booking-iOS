//
//  ForgetPasswordViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 01/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol ForgetPasswordViewModelProtocol {
    func forgetPasswordApiResponse(message: String, response: [String : Any] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class ForgetPasswordViewModel {
    
    var delegate: ForgetPasswordViewModelProtocol?
    
    func getParamForForgetPasswordView(param: [String: Any]){
        self.getForgetPasswordViewData(param: param)
    }
    
    func getForgetPasswordViewData(param: [String: Any]) {
           if Reachability.isConnectedToNetwork() {
               ApiManeger.sharedInstance.callApi(url: Api.resetPassword, method: .post, param: param) { [weak self] (response, error)  in
                   print(response)
                   if error == nil {
                       let result = response
                    print("the result is \(result)")
                    let code = result["status"] as? Int
                    let dictData = result["data"] as? [String:Any]
                    if code == 1{
                        self?.delegate?.forgetPasswordApiResponse(message: dictData?["message"]  as! String, response: dictData ?? [:], isError: false)
                    }else{
                         let errorMssg = result["errors"] as? [String:Any]
                        self?.delegate?.forgetPasswordApiResponse(message: errorMssg?["email"] as! String , response:  [:], isError: true)
                    }
                   }else{
                    self?.delegate?.forgetPasswordApiResponse(message: error!.localizedDescription, response:  [:], isError: true)
                }
            }
           }else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
}
}
