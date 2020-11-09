//
//  NotificationViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 05/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//




import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol NotificationViewModelProtocol {
    func getNotificationApiResponse(message: String, response: [NotificationModel] , isError : Bool,isMorePagination : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
    func changeNotificationStatus(message: String, response: ChangeNotificationModel? ,errorMessage: String)
    func changeNotificationRead(message: String, response: String ,errorMessage: String)
    
}


class NotificationViewModel {
    
        var loginModelObject: ChangeNotificationModel?
    
    var arrayObject = [NotificationModel]()
    var arrayFreindLoadMore = [NotificationModel]()

    
    var delegate: NotificationViewModelProtocol?
    
    func getParamForNotification(param: [String: Any] , page : Int){
        self.notificationListData(param: param ,page : page )
    }
    
    func getParamForChangeNotificationStatus(param: [String: Any]){
           self.notificationStatusData(param: param)
       }
    
    
    func getParamForChangenotificationRead(param: [String: Any]){
              self.notificationRead(param: param)
          }
    
    
    func notificationRead(param: [String: Any]){
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.notificationReadOrWrite, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
//                            let dictData = result["data"] as? [String:Any]
//
//                                                       self.loginModelObject =    ChangeNotificationModel.init(resposne: dictData ?? [:])
//                                                       self.delegate?.changeNotificationStatus(message: "Success", response: self.loginModelObject, errorMessage: "false")
                            
                        }else{
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else{
                    
                }
            }}
        else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }

    
    
    
    func notificationStatusData(param: [String: Any]){
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.ChangeNotificationStatus, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            let dictData = result["data"] as? [String:Any]
                                                      
                                                       self.loginModelObject =    ChangeNotificationModel.init(resposne: dictData ?? [:])
                                                       self.delegate?.changeNotificationStatus(message: "Success", response: self.loginModelObject, errorMessage: "false")
                            
                        }else{
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else{
                    
                }
            }}
        else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    
    func notificationListData(param: [String: Any] , page : Int) {
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.getNotification, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
//                                    if page == 1{
                                print("the notification list is \(response)")
                                                        
                                                        self.arrayObject.removeAll()

                                                        let dataDict = result["data"] as? [String : Any]
                                                        if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                                            for index in dataArray{
                                                               
                                                                let dataDict = NotificationModel.init(resposne: index)
                                                                self.arrayObject.append(dataDict)
                                                            }
                                                        }
                              self.delegate?.getNotificationApiResponse(message: "", response: self.arrayObject, isError: false, isMorePagination: true)
                                
//                            }else{
//
//                                self.arrayFreindLoadMore.removeAll()
//                                let dataDict = result["data"] as? [String : Any]
//                                                                                       if let dataArray = dataDict?["data"] as? [[String : Any]]{
//                                                                                           for index in dataArray{
//                                                                                               print("the index value is \(index)")
//                                                                                               let dataDict = NotificationModel.init(resposne: index)
//                                                                                               self.arrayFreindLoadMore.append(dataDict)
//                                                                                           }
//                                                                                       }
//                                self.arrayObject = self.arrayObject + self.arrayFreindLoadMore
//                                if (self.arrayFreindLoadMore.count == 0){
//                                    self.delegate?.getNotificationApiResponse(message: "", response: self.arrayObject, isError: false, isMorePagination: false)
//  }else{
//                                    self.delegate?.getNotificationApiResponse(message: "", response: self.arrayObject, isError: false, isMorePagination: true)
//
//                                }
//                                print("the number of running fixture is \(self.arrayFreindLoadMore.count)")
//
//
//                            }
                            
                            //
                            
                        
                            
                        }else{
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else{
                    
                }
            }}
        else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
}
