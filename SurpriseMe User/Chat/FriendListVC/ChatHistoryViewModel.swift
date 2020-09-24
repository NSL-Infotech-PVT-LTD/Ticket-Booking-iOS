//
//  ChatHistoryViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 24/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol chatHistoryViewModelProtocol {
    func chatHistoryApiResponse(message: String, response: [ChatHistoryModel] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class ChatHistoryViewModel {
    
    //    var loginModelObject: GetProfileModel?
    
    var arrayObject = [ChatHistoryModel]()
    var delegate: chatHistoryViewModelProtocol?
    
    func getParamForChatHistory(param: [String: Any]){
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.getItemsByReceiverId, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            //
                            
                            self.arrayObject.removeAll()
                            
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let dataDict = ChatHistoryModel.init(response: index)
                                    self.arrayObject.append(dataDict)
                                }
                            }
                            self.delegate?.chatHistoryApiResponse(message: "success", response: self.arrayObject, isError: false)
                            
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

