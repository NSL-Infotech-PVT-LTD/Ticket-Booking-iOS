//
//  HomeScreenViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 08/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol HomeViewModelProtocol {
    func bookingListApiResponse(message: String, response: [GetArtistListHomeModel] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class HomeScreenViewModel {
    
    var arrayObject =  [GetArtistListHomeModel]()
    var delegate: HomeViewModelProtocol?
    
    func getParamForBookingList(param: [String: Any]){
        self.getBookingListData(param: param)
    }
    
    func getBookingListData(param: [String: Any]) {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.artistList, method: .post, param: param, header: headerToken) { (response, error) in
                LoaderClass.shared.stopAnimation()
                print("the response is without virtual \(response)")
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.arrayObject.removeAll()
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    let dataDict = GetArtistListHomeModel.init(resposne: index)
                                    self.arrayObject.append(dataDict)
                                }
                            }
                            self.delegate?.bookingListApiResponse(message: "", response: self.arrayObject, isError: false)
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? String {
                            self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message)
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
