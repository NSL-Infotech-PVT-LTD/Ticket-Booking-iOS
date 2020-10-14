//
//  RatingViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 05/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//





import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol RatingViewModelProtocol {
    func getRatingApiResponse(message: String,  isError : Bool)
    func getCompletedRatedApiResponse(message: String,  isError : Bool)

    func errorAlert(errorTitle: String, errorMessage: String)
}

class RatingViewModel {
    
    var delegate: RatingViewModelProtocol?
    
    func getParamForRating(param: [String: Any]){
        self.getratingData(param: param)
    }
    
    func getratingData(param: [String: Any]){
             let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
            print("the token is \(headerToken)")
            
                           if Reachability.isConnectedToNetwork() {
                            LoaderClass.shared.loadAnimation()

                            ApiManeger.sharedInstance.callApiWithHeader(url: Api.rateArtist, method: .post, param: param, header: headerToken) { (response, error) in
                                print(response)
                                LoaderClass.shared.stopAnimation()
                                               if error == nil {
                                                   let result = response
                                                   if let status = result["status"] as? Bool {
                                                       if status ==  true{
            //
     self.delegate?.getRatingApiResponse(message: "success",  isError : false)
                                                       }
                                                       else{
                                                        self.delegate?.getRatingApiResponse(message: "success",  isError : true)

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
    
    
    func getCompletedBooking(param: [String: Any]) {
                print("the param is \(param)")
                 let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
                print("the token is \(headerToken)")
                
                               if Reachability.isConnectedToNetwork() {
                                LoaderClass.shared.loadAnimation()
                                ApiManeger.sharedInstance.callApiWithHeader(url: Api.changeBookingStatus, method: .post, param: param, header: headerToken) { (response, error) in
                                    print(response)
                                    LoaderClass.shared.stopAnimation()
                                                   if error == nil {
                                                       let result = response
                                                       if let status = result["status"] as? Bool {
                                                           if status ==  true{
                //
                                                          print("the response is \(response)")
                                                            
                                                            
                                                            
                                    
                       self.delegate?.getCompletedRatedApiResponse(message: "String", isError : false)
                                                            
   
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
