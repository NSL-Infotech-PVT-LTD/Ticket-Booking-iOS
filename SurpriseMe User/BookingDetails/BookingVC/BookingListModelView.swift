//
//  BookingListModelView.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 08/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//




import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol BookingListModelViewDelegate {
    func bookingListApiResponse(message: String, response: [GetBookingListModel] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class BookingListModelView {
    
    var arrayObject =  [GetBookingListModel]()
    var delegate: BookingListModelViewDelegate?
    
    func getParamForBookingList(param: [String: Any]){
        self.getBookingListData(param: param)
    }
    
    func getBookingListData(param: [String: Any]) {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.bookinglist, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            //
                            let dataDict = result["data"] as? [String : Any]
                            self.arrayObject.removeAll()
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let dataDict = GetBookingListModel.init(resposne: index)
                                    self.arrayObject.append(dataDict)
                                }
                            }
                            self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
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
