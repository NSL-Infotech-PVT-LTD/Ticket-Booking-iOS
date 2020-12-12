//
//  BookingStoreViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 15/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol BookingStoreViewModelProtocol {
    func bookingStoreApiResponse(message: String, response: [String : Any] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class BookingStoreViewModel {
    
    var delegate: BookingStoreViewModelProtocol?
    
    func getParamForBookingStore(param: [String: Any]){
        self.getBookingStore(param: param)
    }
    
    func getBookingStore(param: [String: Any]) {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        LoaderClass.shared.loadAnimation()
        
        if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.bookingStore, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                
                
                
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            let dictValue = response["data"] as? [String:Any]
                            
                            
                            self.delegate?.bookingStoreApiResponse(message: "Booking Success", response: dictValue ?? [:], isError: false)
                        }
                        else{
                            
                            print("the error is abhishek")
                            
                            self.delegate?.bookingStoreApiResponse(message: "Booking Success", response: response["error"] as? [String:Any] ?? [:], isError: true)
                            
                            
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                                print("the error is error_message")
                                
                                
                            }
                        }
                    }
                }
                else {
                    print("the error is errorAlert")
                    
                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
    }
}
