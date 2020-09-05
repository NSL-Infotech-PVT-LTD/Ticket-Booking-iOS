//
//  ApiManager.swift
//  WeKonnect
//
//  Created by Jujhar Singh on 26/06/20.
//  Copyright © 2020 Jujhar Singh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Storyboard {
    static let Main = "Main"
    static let DashBoard = "Dashboard"
}


struct StringFile {
    static let Name = "name"
    static let Email = "email"
    static let iOS = "ios"
    static let Password = "password"
    static let device_type = "device_type"
    static let device_token = "device_token"
    static let OK = "OK"
    static let Internet_Error = "Internet Error"
    static let Error = "Error"
    static let Enter_Confirm_Password = "Enter your confirm password"
    static let Enter_Password = "Enter your password"
    static let Enter_Email = "Enter your email"
    static let Enter_UserName = "Enter your user name"



    
    
    


    
}


struct ViewControllers {
    static let Login = "LoginVC"
    static let DashBoard = "Dashboard"


}



struct Api {
    
    //MARK : SurpriseMe User API
    static let baseUrl = "https://dev.netscapelabs.com/surpriseme/public/api/customer/"
    static let baseAuthUrl = "https://dev.netscapelabs.com/surpriseme/public/api/"
    
    static let login                    = baseAuthUrl + "login"
    static let Register                 = baseUrl + "register"
    static let resetPassword       = baseAuthUrl + "reset-password"
    static let addresslist            = baseUrl + "address/list"
    static let addressdelete         = baseUrl + "address/delete"
    static let getProfile              = baseAuthUrl + "get-profile"
    static let logout          = baseAuthUrl + "logout"
    
    //String Files -
    
}

class ApiManeger : NSObject{
    
    static let sharedInstance = ApiManeger()
    
    func callApi(url:String,method:HTTPMethod,param:[String:Any],completion:@escaping ([String:Any],NSError?)->()){
        
        Alamofire.request(url, method: method, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error?.localizedDescription != nil{
                completion([:], (response.result.error?.localizedDescription as? NSError))
                
                return
            }
            if let result = response.result.value as? [String:Any]{
                if let status = result["status"] as? Bool{
                    if status == true  {
                        completion(result, nil)
                    }else{
                        completion(result, response.result.error?.localizedDescription as? NSError )
                    }
                }else{
                    completion(result, nil)
                }
            }
        }
    }
    func callApiWithHeader(url:String,method:HTTPMethod,param:[String:Any],header:HTTPHeaders,completion:@escaping ([String:Any],NSError?)->()){
        
        Alamofire.request(url, method: method, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error?.localizedDescription != nil{
                print(response.result.error?.localizedDescription)
                completion([:], response.result.error?.localizedDescription as? NSError )
                
                return
            }
            if let result = response.result.value as? [String:Any]{
                if let status = result["status"] as? Bool{
                    if status == true  {
                        completion(result, nil)
                    }else{
                        completion(result, response.result.error?.localizedDescription as? NSError )
                    }
                }else{
                    completion(result, nil)
                }
            }
        }
    }
    
    
    func callApiWithOutHeaderWithoutParam(url:String,method:HTTPMethod,completion:@escaping ([String:Any],NSError?)->()){
        
        Alamofire.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String:Any]{
                if let status = result["status"] as? Bool{
                    if status == true  {
                        completion(result, nil)
                    }else{
                        completion(result, response.result.error?.localizedDescription as? NSError )
                    }
                }else{
                    completion(result, nil)
                }
            }
        }
    }
    
    func callApiWithHeaderWithoutParam(url:String,method:HTTPMethod,header:HTTPHeaders,completion:@escaping ([String:Any],NSError?)->()){
        
        Alamofire.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let result = response.result.value as? [String:Any]{
                if let status = result["status"] as? Bool{
                    if status == true  {
                        completion(result, nil)
                    }else{
                        completion(result, response.result.error?.localizedDescription as? NSError )
                    }
                }else{
                    completion(result, nil)
                }
            }
        }
    }
    
    
    func uploadImageDataWithoutHeader(inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,completion:@escaping(_ result : AnyObject, NSError?)->Void) {
        
        //    let imageData = imageFile.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData1 = imageFile.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(imageData1, withName: imageName, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            }
            //                  if  let imageData2 = policeDocImage.jpegData(compressionQuality: 0.5) {
            //                      multipartFormData.append(imageData2, withName: policeDoc, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            //                  }
            
            
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl)
            
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON
                    { response in
                        //print response.result
                        if let result = response.result.value as? NSDictionary{
                            if let status = result["status"] as? Bool{
                                if status == true  {
                                    completion(result, nil)
                                }else{
                                    completion(result, response.result.error?.localizedDescription as? NSError)
                                }
                            }else{
                                completion(result, nil)
                            }
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
    
    
    //Upload multiple images in array
    func uploadMultiImageData(inputUrl:String,header:HTTPHeaders,parameters:[String:Any],imageParamName: String, imagesData: [UIImage], completion:@escaping(_ result : AnyObject, NSError?)->Void) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            // import image to request
            for imageData in imagesData {
                
                let imageData1 = imageData.jpegData(compressionQuality: 0.001)
                multipartFormData.append(imageData1 ?? Data(), withName: imageParamName, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,method: .post,headers: header)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON
                    { response in
                        //print response.result
                        if let result = response.result.value as? NSDictionary{
                            if let status = result["status"] as? Bool{
                                if status == true  {
                                    completion(result, nil)
                                }else{
                                    completion(result, response.result.error?.localizedDescription as? NSError)
                                }
                            }else{
                                completion(result, nil)
                            }
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
    
}
