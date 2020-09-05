//
//  ProfileViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol ProfileViewModelProtocol {
    func getProfileApiResponse(message: String, response: GetProfileModel? , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
    func logoutResponse(isError: Bool, errorMessage: String)
}


class ProfileViewModel {
    
    var loginModelObject: GetProfileModel?
    var delegate: ProfileViewModelProtocol?
    
    func getParamForGetProfile(param: [String: Any]){
        self.getGetProfileData(param: param)
    }
    
    func logout()  {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
           if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()

                              ApiManeger.sharedInstance.callApiWithHeader(url: Api.logout, method: .get, param: [:], header: headerToken) { (response, error) in
                                                 print(response)
                                                 if error == nil {
                                                     let result = response
                                                     if let status = result["status"] as? Bool {
                                                         if status ==  true{
                                                          let dictData = result["data"] as? [String:Any]
                                                            let message = dictData?["message"] as? String
                                                            self.delegate?.logoutResponse(isError: false, errorMessage: message ?? "")
                                                        
                                                         }
                                                         else{
                                                            self.delegate?.logoutResponse(isError: true, errorMessage: "message" )

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
    
    
    func getGetProfileData(param: [String: Any]) {
        
        
         let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]

                       if Reachability.isConnectedToNetwork() {
                        LoaderClass.shared.loadAnimation()

                        ApiManeger.sharedInstance.callApiWithHeader(url: Api.getProfile, method: .post, param: [:], header: headerToken) { (response, error) in
                                           print(response)
                                           if error == nil {
                                               let result = response
                                               if let status = result["status"] as? Bool {
                                                   if status ==  true{
        //
                                                    let dictData = result["data"] as? [String:Any]
                                                      let userProfile = dictData?["user"] as? [String:Any]
                                                    self.loginModelObject =    GetProfileModel.init(resposne: userProfile ?? [:])
                                                                                                               self.delegate?.getProfileApiResponse(message: "Success", response: self.loginModelObject, isError: false)
                                                  
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
        
        
//           if Reachability.isConnectedToNetwork() {
//            ApiManeger.sharedInstance.callApi(url: Api.getProfile, method: .post, param: [:]) { [weak self] (response, error)  in
//                   print(response)
//                   if error == nil {
//                       let result = response
//                    print("the result is \(result)")
//                    let code = result["status"] as? Int
//                    let dictData = result["data"] as? [String:Any]
//                    if code == 1{
//                        //self?.delegate?.getProfileApiResponse(message: dictData?["message"]  as! String, response: dictData ?? [:], isError: false)
//                    }else{
//                         let errorMssg = result["error"] as? String
//                       // self?.delegate?.getProfileApiResponse(message: errorMssg ?? "", response:  [:], isError: true)
//                    }
//                   }else{
//                   // self?.delegate?.getProfileApiResponse(message: error!.localizedDescription, response:  [:], isError: true)
//                }
//            }
//           }else{
//            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
//        }
}
}
