//
//  LoginViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol LoginViewModelProtocol {
    func loginApiResponse(message: String, response: [String : Any] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class LoginViewModel {
    
//    var loginModelObject: SignupModel?
    var delegate: LoginViewModelProtocol?
    
    func getParamForLogin(param: [String: Any]){
        self.getLoginData(param: param)
    }
    
    func getLoginData(param: [String: Any]) {
           if Reachability.isConnectedToNetwork() {
               ApiManeger.sharedInstance.callApi(url: Api.login, method: .post, param: param) { [weak self] (response, error)  in
                   print(response)
                   if error == nil {
                       let result = response
                    print("the result is \(result)")
                    let code = result["status"] as? Int
                    let dictData = result["data"] as? [String:Any]
                    if code == 1{
                        self?.delegate?.loginApiResponse(message: dictData?["message"]  as! String, response: dictData ?? [:], isError: false)
                    }else{
                         let errorMssg = result["error"] as? String
                        self?.delegate?.loginApiResponse(message: errorMssg ?? "", response:  [:], isError: true)
                    }
                   }else{
                    self?.delegate?.loginApiResponse(message: error!.localizedDescription, response:  [:], isError: true)
                }
            }
           }else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
}
}
