//
//  GetArtistViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol GetArtistCategoryViewModelDelegate {
    func fetArtistCategoryApiResponse(message: String, response: [GetArtistCategoryModel] , isError : Bool)
    func errorAlert(errorTitle: String, errorMessage: String)
}


class GetArtistCategoryViewModel {
    
    var objectModel = [GetArtistCategoryModel]()
    var delegate: GetArtistCategoryViewModelDelegate?
    
    func getParamForArtistCategory(param: [String: Any]){
        self.geArtistCategoryData(param: param)
    }
    
    func geArtistCategoryData(param: [String: Any]) {
        
        LoaderClass.shared.loadAnimation()
         let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        print("the param is \(param)")
                       if Reachability.isConnectedToNetwork() {
                        
                       ApiManeger.sharedInstance.callApi(url: Api.artistCategoryList, method: .post, param: param){ (response, error) in
                              print("the response is \(response)")
                        LoaderClass.shared.stopAnimation()
                              if error == nil {
                                  let result = response
                                  if let status = result["status"] as? Bool {
                                      if status ==  true{
                                          
                                         
                                        if let data = response["data"] as? [[String:Any]] {
                                              for getcategory in data {
                                            let dataDict = GetArtistCategoryModel.init(resposne: getcategory)
self.objectModel.append(dataDict)
                                              }
                                          }
                                        
                                        self.delegate?.fetArtistCategoryApiResponse(message: "Success", response: self.objectModel, isError: false)
                                         
                                      }else{
                                          if let error = response["error"] as? String {
                                             
                                          }
                                      }
                                  }
                              }

                     else{
                        self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
                    }
                        }
 
                       }else{
                        self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")

                        
        }
}
}
