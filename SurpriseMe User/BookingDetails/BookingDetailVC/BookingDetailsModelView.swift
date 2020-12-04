//
//  BookingDetailsModelView.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 06/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//





import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol BookingDetailsModelViewDelegate {
    func bookingDetailsApiResponse(message: String, response: BookingDetailsModel? , isError : Bool)
    
     func cancelBookingApiResponse(message: String, isError : Bool)
    
    func errorAlert(errorTitle: String, errorMessage: String)
}


class BookingDetailsModelView {
    
    var detailsObject :  BookingDetailsModel?
    var delegate: BookingDetailsModelViewDelegate?
    
    func getParamForBookingDetails(param: [String: Any]){
        self.getBookingDetailsData(param: param)
    }
    
    func getParamForPayment(param: [String: Any]){
        self.getPaymentForBooking(param: param)
    }
    
    func getParamForCancelBooking(param: [String: Any]){
           self.getCancelBooking(param: param)
       }
    
       func getPaymentForBooking(param: [String: Any]) {
             let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
            print("the token is \(headerToken)")
            
                           if Reachability.isConnectedToNetwork() {
                            LoaderClass.shared.loadAnimation()

                            ApiManeger.sharedInstance.callApiWithHeader(url: Api.bookinDetaildById, method: .post, param: param, header: headerToken) { (response, error) in
                                print(response)
                                LoaderClass.shared.stopAnimation()
                                               if error == nil {
                                                   let result = response
                                                   if let status = result["status"] as? Bool {
                                                       if status ==  true{
            //
                                                      
                                                        
                                                        
                                                        let dictData = result["data"] as? [String:Any]
                                                                                  let userProfile = dictData?["user"] as? [String:Any]
                                                                                  self.detailsObject =    BookingDetailsModel.init(resposne: dictData ?? [:])
                                                                                  self.delegate?.bookingDetailsApiResponse(message: "Success", response: self.detailsObject, isError: false)
                                                        
                                                        
    //
     //self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
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
    
    
    func getBookingDetailsData(param: [String: Any]) {
         let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
                       if Reachability.isConnectedToNetwork() {
                        LoaderClass.shared.loadAnimation()

                        ApiManeger.sharedInstance.callApiWithHeader(url: Api.bookinDetaildById, method: .post, param: param, header: headerToken) { (response, error) in
                            print(response)
                            LoaderClass.shared.stopAnimation()
                                           if error == nil {
                                               let result = response
                                               if let status = result["status"] as? Bool {
                                                   if status ==  true{
        //
                                                  
                                                    
                                                    
                                                    let dictData = result["data"] as? [String:Any]
                                                                              let userProfile = dictData?["user"] as? [String:Any]
                                                                              self.detailsObject =    BookingDetailsModel.init(resposne: dictData ?? [:])
                                                                              self.delegate?.bookingDetailsApiResponse(message: "Success", response: self.detailsObject, isError: false)
                                                    
                                                    
//
 //self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
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
    
        func getCancelBooking(param: [String: Any]) {
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
                                                        
                                                        
                                                        
                                
                   self.delegate?.cancelBookingApiResponse(message: "String", isError : false)
                                                        
//
//                                                        let dictData = result["data"] as? [String:Any]
//                                                                                  let userProfile = dictData?["user"] as? [String:Any]
//                                                                                  self.detailsObject =    BookingDetailsModel.init(resposne: userProfile ?? [:])
//                                                                                  self.delegate?.bookingDetailsApiResponse(message: "Success", response: self.detailsObject, isError: false)
                                                        
                                                        
    //
     //self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
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
