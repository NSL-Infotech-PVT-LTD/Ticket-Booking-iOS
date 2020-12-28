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

var selectedType = String()
var selectedDate = String()
var selectToTime = String()
var selectFromTime = String()
var cameFrom = Bool()
var currentLat = Double()
var currentLong = Double()
var customAddress = Bool()
var currentAddress = String()
var selectedIdentifier = String()
var userArtistIDBooking : Any?
var userArtistID = Int()
var arrayCategorySelected = [Int]()
var arrayCategorySelectedName = [String]()
var sendReceiveTime = String()
var bookingPaymentID : Int?
var idealPaymentFailed = Bool()

var arrayCardListCommom = [GetCardModel]()
var idealPayment = Bool()
var idealPaymentAppDelegate = Bool()
var locationCurrentTitle = String()
var showTypeTrueOrFalse = false
var whicShowTypeDigital = Bool()
var isCameFromCL = String()
var pageForFilter = false
var isEditAddress = false
var modelObjectAdress = ManageAddressModel()
var dictFilter = [String:Any]()
var SelfImage = String()
var addressIDEdit = String()
var addressTypeEdit = String()
var addressAdditionalDetailEdit = String()
var addressLandMarkEdit = String()
var otherAddresssFeildValue = String()
var isEditValue = Bool()
var searchTextValueData = String()
var startDateValue = String()
var endDateValue = String()

var isChatNotification = false


let googleKey = "AIzaSyCRpD5-6NTTmuzvDUUBgpSjbUgyrA71bOM"

struct Storyboard {
    static let Main = "Main"
    static let DashBoard = "Dashboard"
    static let Profile = "Profile"
    static let Chat = "Chat"
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
    static let Publish_Key = "pk_test_51HcYaaDVPC7KpoaUBqxarUUagXrI14GRCicyaZt8NztibJ4G9Y7KMtunrcWTg5PDm3PzcuBe1zkFFJiJRt1mXs8s009njabz8l"
//        static let Publish_Key =    "pk_live_51HcYaaDVPC7KpoaU4BhQKv4qykAVVtz3TYma2nb9Yuztmb5B3EsfDaNwA3KZpDHqNv9lRlZRKVvbo5grhmRrB3bl006lVXgjmr"

    





}


struct ViewControllers {
    static let Login = "LoginVC"
    static let DashBoard = "Dashboard"
    static let ChatDash = "Chat"
    static let FriendList = "FriendListVC"


    static let ManageAddressVC = "ManageAddressVC"
    static let UpdateLocationVC = "UpdateLocationVC"
    static let ScheduleBookingVC = "ScheduleBookingVC"
    
    
    
    
    static let SeleteDate = "SelectDateVC"
    static let EditDateVC = "EditDateVC"
    static let ManualAddressVC = "ManualAddressVC"
    static let ChangePasswordVC = "ChangePasswordVC"
    static let GetArtistCategoryVC = "GetArtistCategoryVC"
    static let FilterViewController = "FilterViewController"
    static let ViewProfileVC = "ViewProfileVC"
    static let SettingVC = "SettingVC"
    static let TermsProfileVC = "TermsProfileVC"
    
}



struct Api {
    
    //MARK : SurpriseMe User API
    static let baseUrl = "https://dev.netscapelabs.com/surpriseme/public/api/customer/"
    static let basePublicUrl = "https://dev.netscapelabs.com/surpriseme/public/api/"
    
    static let baseAuthUrl = "https://dev.netscapelabs.com/surpriseme/public/api/"
    static let imageURL = "https://dev.netscapelabs.com/surpriseme/public/uploads/users/customer/"
    
    static let imageURLArtist = "https://dev.netscapelabs.com/surpriseme/public/uploads/users/artist/"
    static let videoUrl = "https://dev.netscapelabs.com/surpriseme/public/uploads/artist/videos/"
    
    static let videoUrlThumbnail = videoUrl + "thumbnail/"

    
    
    static let login                  = baseUrl + "login"
    static let Register               = baseUrl + "register"
    static let FBregister            = baseUrl + "register/fb"
    static let AppleLogin             = baseUrl + "register/apple"
    static let update                 = baseUrl + "update"
    static let changePassword         = baseAuthUrl + "customer/change-password"
    static let resetPassword          = baseAuthUrl + "reset-password"
    static let addresslist            = baseUrl + "address/list"
    static let addressdelete          = baseUrl + "address/delete"
    static let getProfile             = baseAuthUrl + "get-profile"
    static let logout                 = baseAuthUrl + "logout"
    static let artistList             = baseUrl + "artist/list"
    static let bookinglist            = baseUrl + "booking/list"
    static let bookingStore           = baseUrl + "booking/store"
    static let addressStore           = baseUrl + "address/store"
    static let addressUpdate          = baseUrl + "address/update"
    static let customerUpdate         = baseUrl + "update"
    static let artistBookingList      = baseUrl + "artist/booking/list"
    static let artistCategoryList     = basePublicUrl + "category/list"
    static let customerArtist         = basePublicUrl + "customer/artist"
    static let getItemsByReceiverId   = basePublicUrl + "chat/getItemsByReceiverId"
    static let getFreindList          = basePublicUrl + "chat/getItemByReceiverId"
    static let getNotification        = basePublicUrl + "notification/list"
    static let rateArtist             = baseUrl + "rate-booking"
    static let bookinDetaildById      = basePublicUrl + "customer/booking"
    static let ChangeNotificationStatus   = basePublicUrl + "notification/status"
    static let changeBookingStatus    = basePublicUrl + "customer/change-booking-status"
    static let notificationReadOrWrite    = basePublicUrl + "notification/read"
    static let artistbookslot    = basePublicUrl + "customer/bookslot/list"
    static let customerCardList    = basePublicUrl + "customer/cards/list"
    static let customerdeleteCard    = basePublicUrl + "customer/cards/delete"

    static let customerAddCard    = basePublicUrl + "customer/cards/store"

    static let artistGetArtistRating    = basePublicUrl + "customer/getartistrating"
    static let artistAvailableSlot    = basePublicUrl + "customer/bookslot/list-date"
    static let idelPayment           = basePublicUrl + "customer/create-payment-intent"
    static let getStripeKey           = basePublicUrl + "payment-config"
    static let currencies               = basePublicUrl + "currencies"
    static let TermsAndCondi               = basePublicUrl + "config/terms_and_conditions"
    static let AboutUs               = basePublicUrl + "config/about_us"
    static let PrivacyPolicyApi               = basePublicUrl + "config/privacy_policy"

    
    
    
    //String Files -
    
}

class ApiManeger : NSObject{
    
    static let sharedInstance = ApiManeger()
    
    func callApiWithInternet(url:String,controller:UIViewController,method:HTTPMethod,param:[String:Any],completion:@escaping ([String:Any],NSError?)->()){
          
          
//        if Reachability.isConnectedToNetwork(){
//            controller.view.addSubview(<#T##view: UIView##UIView#>)
//        }else{
//            
//        }
          
          
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
                
            }else{
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
    }
    
    
    func alamofire_uploadVideo(url: String, method: HTTPMethod,parameters: [String: Any],profileImage1: UIImage?,profileImgName : String,  hearders: HTTPHeaders, completion:@escaping (_ result : AnyObject, NSError?) -> ()) {
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                //profile image
                if let imageData1 = profileImage1?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData1, withName: profileImgName, fileName: "file.jpg", mimeType: "image/jpg")
                }
                
                
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to: url, headers:hearders)
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
                            print("the response is \(result)")
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
