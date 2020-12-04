//
//  ReviewRatingViewModel.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 08/10/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol ReviewRatingViewModelProtocol {
    func getReviewRatingApiResponse(success: String, message: String,response: [ReviewRatingModel])
    func errorAlert(errorTitle: String, errorMessage: String)
}

class ReviewRatingViewModel{
    
    var delegate: ReviewRatingViewModelProtocol?
    var getReviewRatingModelObject = [ReviewRatingModel]()
    
    //Mark: Api GetProfile
    func getReviewRatingData(param: [String: Any]) {
        print(param)
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.artistGetArtistRating, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.getReviewRatingModelObject.removeAll()
                            if let data = response["data"] as? [[String:Any]] {
                                for getList in data {
                                    self.getReviewRatingModelObject.append(ReviewRatingModel.init(resposne: getList))
                                }
                                self.delegate?.getReviewRatingApiResponse(success: "Success", message: "msg", response: self.getReviewRatingModelObject)
                                
                            }else{
                                if let error = response["error"] as? String {
                                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error)
                                }
                            }
                        }else{
                            if let error = response["error"] as? String {
                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error)
                            }
                        }
                    }else{
                        self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error?.localizedDescription ?? "")
                    }
                }
            }
        }else{
            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
            
        }
    }
}
