//
//  SearchArtistViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol SearchArtistViewModelProtocol {
    func getProfileApiResponse(message: String, response: [SearchArtistModel] , isError : Bool,isLoadMore:Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
    
}


class SearchArtistViewModel {
    
    //    var loginModelObject: GetProfileModel?
    
    var arrayObject = [SearchArtistModel]()
    var arrayObjectLoadMore = [SearchArtistModel]()

    var delegate: SearchArtistViewModelProtocol?
    
    func getParamForGetProfile(param: [String: Any] , pageNo : Int){
        self.artistBookingListData(param: param , pageNo : pageNo)
    }
    
    
    func artistBookingListData(param: [String: Any] , pageNo : Int) {
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
//            LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.artistList, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
//                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            if pageNo == 1{
                                self.arrayObject.removeAll()
                                let dataDict = result["data"] as? [String : Any]
                                
                                let current_pagedataDict = result["current_page"] as? String
                                let last_pagedataDict = result["last_page"] as? String
                                if current_pagedataDict == last_pagedataDict{
                                    if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                        for index in dataArray{
                                            print("the index value is \(index)")
                                            let dataDict = SearchArtistModel.init(resposne: index)
                                            self.arrayObject.append(dataDict)
                                        }
                                    }
                                    
                                    self.delegate?.getProfileApiResponse(message: "", response: self.arrayObject, isError: false,isLoadMore:true)
                                }else{
                                    self.delegate?.getProfileApiResponse(message: "", response: self.arrayObject, isError: false,isLoadMore:false)
                                }

                            }else{
                                     self.arrayObjectLoadMore.removeAll()
                                let dataDict = result["data"] as? [String : Any]
                                if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                    for index in dataArray{
                                        print("the index value is \(index)")
                                        let dataDict = SearchArtistModel.init(resposne: index)
                                        self.arrayObjectLoadMore.append(dataDict)
                                    }
                                    
                                    self.arrayObject = self.arrayObject + self.arrayObjectLoadMore
                                    if (self.arrayObjectLoadMore.count == 0){
 self.delegate?.getProfileApiResponse(message: "", response: self.arrayObject, isError: false,isLoadMore:true)                                    }else{
 self.delegate?.getProfileApiResponse(message: "", response: self.arrayObject, isError: false,isLoadMore:false)                                    }
                                    print("the number of running fixture is \(self.arrayObjectLoadMore.count)")
                                    
                                }

                            }
                            //
                            
                            
                            
                            
                           
                            
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
