//
//  GetUserChatListViewM.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 24/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol getUseChatListListViewModelProtocol {
    
    func getFriendListViewArray(response:[GetFreindListModel])
    func errorAlert(errorTitle: String, errorMessage: String)
}

class GetUserChatListViewM{
    var delegate: getUseChatListListViewModelProtocol?
    var getFriendlList =  [GetFreindListModel]()
    
    func getFriendList(param: [String: Any]){
        print(param)
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) as! String)"]
        if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.getFreindList, method: .post, param: param, header: header) { (response, error) in
                print(response)
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            if let dataDetail = response["data"] as? [String : Any]{
                                
                                self.getFriendlList.removeAll()
                                if let data = dataDetail["list"] as? [[String:Any]] {
                                    for getcategory in data {
                                        print("dictionary paer dlsnfsad \(getcategory)")
                                        self.getFriendlList.append(GetFreindListModel.init(resposne: getcategory ))
                                    }
                                }
                                print("the freind List is \(self.getFriendlList.count)")
                                self.delegate?.getFriendListViewArray(response:self.getFriendlList)
                                
                            }
                        }else{
                            if let error = response["error"] as? String {
                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error)
                            }
                        }
                    }else{
                        //                        self.delegate?.errorAlert(errorTitle: Alerts.Error, errorMessage: error?.localizedDescription ?? "")
                    }
                }
            }
        }else{
            //            self.delegate?.errorAlert(errorTitle: Alerts.Alert, errorMessage: AlertMessage.internetConn)
        }
    }
}
