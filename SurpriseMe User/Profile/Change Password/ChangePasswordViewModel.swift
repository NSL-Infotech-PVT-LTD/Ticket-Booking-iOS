//
//  ChangePasswordViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 23/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol ChangePasswordViewModelProtocol {
    func loginApiResponse(message: String, response: [String : Any] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class ChangePasswordViewModel {
    
//    var loginModelObject: SignupModel?
    var delegate: ChangePasswordViewModelProtocol?
    
    func getParamForChangepassword(param: [String: Any]){
        self.getChangepasswordData(param: param)
    }
    
    func getChangepasswordData(param: [String: Any]) {
                
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
              
              if Reachability.isConnectedToNetwork() {
                  LoaderClass.shared.loadAnimation()
                  ApiManeger.sharedInstance.callApiWithHeader(url: Api.changePassword, method: .post, param: param, header: headerToken) { (response, error) in
                      print(response)
                    print("the base url is \(Api.changePassword)")
                    
                      if error == nil {
                          let result = response
                          if let status = result["status"] as? Bool {
                              if status ==  true{
                                  //
//                                  let dictData = result["data"] as? [String:Any]
//                                  let userProfile = dictData?["user"] as? [String:Any]
//                                  self.loginModelObject =    GetProfileModel.init(resposne: userProfile ?? [:])
//                                  self.delegate?.getProfileApiResponse(message: "Success", response: self.loginModelObject, isError: false)
                                  
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
                          self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                      }
                  }
                  
              }else{
                  self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
              }
           }
}
