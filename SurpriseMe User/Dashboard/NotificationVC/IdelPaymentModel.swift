//
//  IdelPaymentModel.swift
//  SurpriseMe User
//
//  Created by Apple on 10/11/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol IdelViewModelProtocol {
    func idelApiResponse(message: String, response: [String : Any] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class IdelPaymentModel {
    
//    var loginModelObject: SignupModel?
    var delegate: IdelViewModelProtocol?
    func getLoginData(param: [String: Any]) {
           if Reachability.isConnectedToNetwork() {
            let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.idelPayment, method: .post, param: param, header: headerToken) { [weak self] (response, error)  in
                   print(response)
                   if error == nil {
                       let result = response
                    print("the result is \(result)")
                    let code = result["status"] as? Int
                    let dictData = result["data"] as? [String:Any]
                    if code == 1{
                        self?.delegate?.idelApiResponse(message:"", response: dictData ?? [:], isError: false)
                    }else{
                         let errorMssg = result["error"] as? String
                        self?.delegate?.idelApiResponse(message: errorMssg ?? "", response:  [:], isError: true)
                    }
                   }else{
                    self?.delegate?.idelApiResponse(message: error!.localizedDescription, response:  [:], isError: true)
                }
            }
           }else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
}
}
