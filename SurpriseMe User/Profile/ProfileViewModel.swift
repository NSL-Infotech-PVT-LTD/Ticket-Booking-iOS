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
    func getUpdateProfileApiResponse(message: String , isError : Bool)
    
    
}


class ProfileViewModel {
    
    var loginModelObject: GetProfileModel?
    var delegate: ProfileViewModelProtocol?
    
    func getParamForGetProfile(param: [String: Any]){
        self.getGetProfileData(param: param)
    }
    
    
    func updataProfileData(param: [String: Any], image: UIImage) {
        
        print(param)
        
        LoaderClass.shared.loadAnimation()
        if Reachability.isConnectedToNetwork() {
            let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
            ApiManeger.sharedInstance.alamofire_uploadVideo(url: Api.customerUpdate, method: .post, parameters: param, profileImage1: image, profileImgName: "image", hearders: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.delegate?.getUpdateProfileApiResponse(message: "Update Successfully", isError: false)
                        }else{
                            
                        }}
                }else{
                    
                }
            }
        }else{
            
        }
    }
    
    func logout()  {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            let deviceToken = UserDefaults.standard.value(forKey: "device_token")
                   print("the device token is \(deviceToken)")
//                   param = ["email":tfEmail.text! , "password" : tfPassword.text! , "device_type":"ios","device_token": deviceToken ?? ""]
            let dictParam = ["device_token":deviceToken ?? "" ,"device_type": "iOS"]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.logout, method: .post, param: dictParam, header: headerToken) { (response, error) in
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
        
    }
}
