//
//  ManageAddressViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 01/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol ManageAddressViewModelProtocol {
    func manageAddressApiResponse(message: String, modelArray: [ManageAddressModel],isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
    func successAlert(susccessTitle: String, successMessage: String,from:Bool)
    func addAddress()

}


class ManageAddressViewModel {
    
    var mobelObject =  [ManageAddressModel]()
    var delegate: ManageAddressViewModelProtocol?
    
    //MARK:- Method for accepting param -
    func getParamForManageAddress(param: [String: Any]){
        self.getManageAddressData(param: param)
    }
    
    func getParamForAddAddress(param: [String: Any]){
        self.addAddress(param: param)
    }
    
    func getParamForEditAddress(param: [String: Any]){
        self.getEditAddress(param: param)
    }
    
    //MARK:- Method for accepting param -
       func getParamForDeleteAddress(param: [String: Any]){
           self.getDeleteAddressData(param: param)
       }
    
    
    func getEditAddress(param: [String: Any])  {
     let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
                           if Reachability.isConnectedToNetwork() {
                            ApiManeger.sharedInstance.callApiWithHeader(url: Api.addressUpdate, method: .post, param: param, header: headerToken) { (response, error) in
                                               print(response)
                                               if error == nil {
                                                   let result = response
                                                   if let status = result["status"] as? Bool {
                                                       if status ==  true{
                                                        let dictData = result["data"] as? [String:Any]
                                                        self.delegate?.addAddress()
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
    
    
    func addAddress(param: [String: Any])  {
                    
                    let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
                       if Reachability.isConnectedToNetwork() {
                        ApiManeger.sharedInstance.callApiWithHeader(url: Api.addressStore, method: .post, param: param, header: headerToken) { (response, error) in
                                           print(response)
                                           if error == nil {
                                               let result = response
                                               if let status = result["status"] as? Bool {
                                                   if status ==  true{
                                                    let dictData = result["data"] as? [String:Any]
                                                    self.delegate?.addAddress()
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
    
     func getDeleteAddressData(param: [String: Any]) {
            
            let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        LoaderClass.shared.loadAnimation()

               if Reachability.isConnectedToNetwork() {
                ApiManeger.sharedInstance.callApiWithHeader(url: Api.addressdelete, method: .post, param: param, header: headerToken) { (response, error) in
                                   print(response)
                    
                    LoaderClass.shared.stopAnimation()
                                   if error == nil {
                                       let result = response
                                       if let status = result["status"] as? Bool {
                                           if status ==  true{
                                            let dictData = result["data"] as? [String:Any]
                                            self.delegate?.successAlert(susccessTitle: "Success", successMessage: dictData?["message"] as? String ?? "", from: false)
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
    
    func getManageAddressData(param: [String: Any]) {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        LoaderClass.shared.loadAnimation()

           if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.addresslist, method: .get, param: [:], header: headerToken) { (response, error) in
                               print(response)
                LoaderClass.shared.stopAnimation()
                               if error == nil {
                                   let result = response
                                   if let status = result["status"] as? Bool {
                                       if status ==  true{
                                           self.mobelObject.removeAll()
                                           if let data = response["data"] as? NSArray {
                                               data.forEach({ (indexvalue) in
                                                   if let getData = indexvalue as? [String: Any] {
                                                       self.mobelObject.append(ManageAddressModel.init(resposne: getData))
                                                   }
                                               })
                                           }
                                        self.delegate?.manageAddressApiResponse(message: "Success", modelArray: self.mobelObject, isError: false)
                                       }
                                       else{
                                        self.delegate?.manageAddressApiResponse(message: "Error", modelArray: self.mobelObject, isError: true)
                                       }
                                   }
                                   else {
                                       if let error_message = response["error"] as? [String:Any] {
                                           if let message = error_message["error_message"] as? String {
               //                                self.delegate?.exploreErrorAlert(errorTitle: Alerts.Error, errorMessage: message)
                                           }
                                       }
                                   }
                               }
                               else {
               //                    self.delegate?.exploreErrorAlert(errorTitle: Alerts.Error, errorMessage: error as! String)
                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                               }
                           }

           }else{
            LoaderClass.shared.stopAnimation()

            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
}
}
