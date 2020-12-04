//
//  GetArtistProfileViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol GetArtistProfileViewModelProtocol {
   
    func successAlert(susccessTitle: String, successMessage:GetArtistModel? ,from:Bool)
    func addAddress()

}


class GetArtistProfileViewModel {
    
    var mobelObject :GetArtistModel?
    var delegate: GetArtistProfileViewModelProtocol?
    
    
    func getParamForProfile(param: [String: Any]){
        self.getProfileData(param: param)
    }
    
    
    
    func getProfileData(param: [String: Any])  {
        LoaderClass.shared.loadAnimation()
     let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
                           if Reachability.isConnectedToNetwork() {
                            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerArtist, method: .post, param: param, header: headerToken) { (response, error) in
                                               print(response)
                                LoaderClass.shared.stopAnimation()
                                               if error == nil {
                                                   let result = response
                                                   if let status = result["status"] as? Bool {
                                                       if status ==  true{
                                                        let dictData = result["data"] as? [String:Any]
                                                        
                                                       self.mobelObject =    GetArtistModel.init(resposne: dictData ?? [:])
                                                        self.delegate?.successAlert(susccessTitle: "Success", successMessage: self.mobelObject, from: false)
                                                        
                                                        
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
//                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                                               }
                                           }

                           }else{
//                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
                        }
        
    }
    
    
    
    
}
