//
//  SignupViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol SignUpViewModelProtocol {
    func signupApiResponse(message: String, response: [String : Any],isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class SignUpViewModel {
    
    var loginModelObject: SignupModel?
    var delegate: SignUpViewModelProtocol?
    
    //MARK:- Method for accepting param -
    func getParamForSignUp(param: [String: Any]){
        self.getSignupData(param: param)
    }
    
    func getSignupData(param: [String: Any]) {
           if Reachability.isConnectedToNetwork() {
               ApiManeger.sharedInstance.callApi(url: Api.Register, method: .post, param: param) { [weak self] (response, error)  in
                   print(response)
                   if error == nil {
                       let result = response
                    let code = result["status"] as? Int
                    let dictData = result["data"] as? [String:Any]
                    if code == 1{
                        self?.delegate?.signupApiResponse(message: dictData?["message"]  as! String, response: dictData ?? [:], isError: false)
                    }else{
                        let dictError = result["errors"] as? [String:Any]
                        self?.delegate?.signupApiResponse(message: dictError?["email"]  as! String, response: dictData ?? [:], isError: true)
                    }
                   }else{
                    self?.delegate?.signupApiResponse(message: error!.localizedDescription, response:  [:], isError: true)
                }
            }
           }else{
            self.delegate?.errorAlert(errorTitle: StringFile.Internet_Error, errorMessage: "Please Check your Internet Connection")
        }
}
}
