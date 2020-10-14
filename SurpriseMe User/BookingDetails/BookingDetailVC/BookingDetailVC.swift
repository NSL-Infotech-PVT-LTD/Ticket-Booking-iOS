//
//  BookingDetailVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 28/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import TagListView
import Cosmos

class BookingDetailVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewDash1: UIView!
    @IBOutlet weak var viewDash2: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTimeSection: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblBookingStatus: UILabel!
    @IBOutlet weak var viewList: TagListView!
    @IBOutlet weak var chatTopOutlet: NSLayoutConstraint!
    @IBOutlet weak var viewCosmo: CosmosView!
    @IBOutlet weak var ratingDesc: UITextView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet weak var lblShowType: UILabel!
    
    //MARK:- Variable -
    var id : String?
    
    var bookingID = Int()
    var isComingFrom  = String()
    
    var dictProfile : BookingDetailsModel?
    var viewModelObject = BookingDetailsModelView()
    var currentDate = Date()
    var currentTitle = String()


    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        self.setAllData()
    }
    func setAllData() {
      self.btnStatus.isHidden = true
             self.btnChat.isHidden = true
             self.viewModelObject.delegate = self
        
        if isComingFrom == "Notification"{
            let param = ["id":bookingID]
            print("the booking id is \(param)")
            self.viewModelObject.getParamForBookingDetails(param: param)
        }else{
            let param = ["id":bookingID]
          print("the booking id is \(param)")
          self.viewModelObject.getParamForBookingDetails(param: param)
        }
     }
    
    
   
    
    
    func compareTime(performTime : String) -> Bool {
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
               formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
               // formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                let crunnetDateStr = formatter.string(from: currentDate)
                print("the current date is \(crunnetDateStr)")

                
                let endDate = formatter.date(from: performTime) ?? Date()
        //        let endDateS = formatter.string(from: endDate)
        //        print(endDateS)
                let formatter1 = DateComponentsFormatter()
                formatter1.unitsStyle = .brief // May delete the word brief to let Xcode show you the other options
                formatter1.allowedUnits = [.hour, .minute]
                formatter1.maximumUnitCount = 2  // Show just one unit (i.e. 1d vs. 1d 6hrs)
                let stringDate = formatter1.string(from: currentDate, to: endDate)
                let currentSeconds = currentDate.timeIntervalSince1970
                let endseconds = endDate.timeIntervalSince1970
                let pendingSeconds = Int(endseconds - currentSeconds)
                let getHours = pendingSeconds / 3600
        print("the remaining hours \(getHours)")
        
        if getHours >= 1{
            return false
        }else{
            return true

        }
  
    }
    
    
   func convertTimeInto24(timeData: String) -> String {
        let dateAsString = timeData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date ?? Date())
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    
    func cancelBookingAction()  {
        let param = ["booking_id":bookingID , "status":"cancel"] as [String : Any]
        self.viewModelObject.getParamForCancelBooking(param: param)
    }
    
    func payNowAction()  {
           let param = ["booking_id":bookingID , "status":"confirmed"] as [String : Any]
           self.viewModelObject.getParamForCancelBooking(param: param)
       }
    
    @IBAction func btnRateArtistAction(_ sender: UIButton) {
        
        let buttonTitle = sender.titleLabel?.text
        print("the button title is \(buttonTitle ?? "")")
        currentTitle = buttonTitle ?? ""
        
        if buttonTitle ?? "" == "Cancel Booking"{
            self.cancelBookingAction()
        }else if buttonTitle ?? "" == "Pay Now"{
            self.payNowAction()
        }else if buttonTitle ?? "" == "Go To Home"{
            self.tabBarController?.selectedIndex = 0
            self.back()
        }else if buttonTitle ?? "" == "Did Artist reach at your location?"{
           let alert = UIAlertController(title: "", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                   

               }))
               alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
             
               // show the alert
               self.present(alert, animated: true, completion: nil)
           }else if buttonTitle ?? "" == "Rate your artist"{
           userArtistID =  dictProfile?.artist_detail?.ID ?? 0
                   let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
                   let controller = storyboard.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                   controller.artistName = dictProfile?.artist_detail?.name ?? ""
                   controller.userImg = dictProfile?.artist_detail?.imageProfile ?? ""
                   controller.bookingID = dictProfile?.id ?? 0
                   navigationController?.pushViewController(controller, animated: true)
           }
        
        
        
        
//
    }
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        userArtistID =  dictProfile?.artist_detail?.ID ?? 0
       let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        controller.name = dictProfile?.artist_detail?.name ?? ""
        controller.userImage = dictProfile?.artist_detail?.imageProfile ?? ""
        navigationController?.pushViewController(controller, animated: true)
   }
    
    func convertDateToStringBook(profile : String)-> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMMM,yyyy"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate ?? Date())
        return bookDate
    }
    
    //MARK:- Custom Button Action -
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnRefreshAction(_ sender: UIButton) {
        
        if dictProfile?.status == "pending"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = false
                self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                self.btnStatus.setTitleColor(.white, for: .normal)
                self.btnStatus.setTitle("Cancel Booking", for: .normal)
            }else if dictProfile?.status == "cancel"{
                self.btnStatus.isHidden = true
                self.btnChat.isHidden = true
            }else if dictProfile?.status == "accepted"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = false
                self.btnStatus.setTitle("Pay Now", for: .normal)
                self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                self.btnStatus.setTitleColor(.white, for: .normal)
            }else if dictProfile?.status == "rejected"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = true
                self.btnStatus.setTitle("Go To Home", for: .normal)
                self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                self.btnStatus.setTitleColor(.white, for: .normal)
            }else if dictProfile?.status == "confirmed"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = false
                self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                self.btnStatus.setTitleColor(.white, for: .normal)
            let dateValue = "\("2020-10-09")" + " " + "\(dictProfile?.from_time ?? "")"

            let returnValue =   self.compareTime(performTime: "\(dateValue)")

                if returnValue == true{
                    self.btnStatus.setTitle("Did Artist reach at your location?", for: .normal)
                }else{
                    self.btnStatus.setTitle("Artist will reach at your location", for: .normal)
                }
            }else if dictProfile?.status == "processing"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = true
                self.btnStatus.backgroundColor = UIColor.white
                self.btnStatus.setTitleColor(.black, for: .normal)
                self.btnStatus.setTitle("Your artist is started to performing soon!", for: .normal)
            }else if dictProfile?.status == "completed"{
                self.btnStatus.isHidden = false
                self.btnChat.isHidden = true
                self.btnChat.setTitle("You artist completed his performance", for: .normal)
                self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                           self.btnStatus.setTitleColor(.white, for: .normal)
                self.btnStatus.setTitle("Rate your artist", for: .normal)
            }
        self.btnRateArtistAction(self.btnStatus)
        
    }
    
    func setInitialData(dataItem :BookingDetailsModel?)  {
        lblBookingStatus.text = "Status :- \(dataItem?.status ?? "")"
        dictProfile = dataItem
        
        if dataItem?.status == "completed_review"{
            chatTopOutlet.constant = 160
            self.viewCosmo.isHidden = false
            self.ratingDesc.isHidden = false
            self.viewCosmo.isUserInteractionEnabled = false
            self.ratingDesc.isUserInteractionEnabled = false
            self.ratingDesc.text = dataItem?.rate_detail?.review ?? ""
            self.viewCosmo.rating = Double(dataItem?.rate_detail?.rate ?? 0)

        }else{
            chatTopOutlet.constant = 39
            self.viewCosmo.isHidden = true
            self.ratingDesc.isHidden = true

        }
       self.lblName.text = dataItem?.artist_detail?.name ?? ""
        self.lblAddress.text = dataItem?.address ?? ""
        self.lblOTP.text = "OTP :- \(dataItem?.otp ?? 0)"
        self.lblShowType.text = "Show type :- \(dataItem?.type ?? "")"
               let urlSting : String = "\(Api.imageURLArtist)\(dataItem?.artist_detail?.imageProfile ?? "")"
               let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
               let urlImage = URL(string: urlStringaa)!
               self.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
               lblDate.text = self.convertDateToStringBook(profile: dataItem?.dateInString ?? "")
               let fromTime = self.convertTimeInto24(timeData: dataItem?.from_time ?? "")
               let toTime = self.convertTimeInto24(timeData: dataItem?.to_time ?? "")
               lblTime.text = "\(fromTime)" + " to " + "\(toTime)"
        let dateValue = "\("2020-10-09")" + " " + "\(dataItem?.from_time ?? "")"
        print("the date and time dateValue is \(dateValue)")
        let returnValue =   self.compareTime(performTime: "\(dateValue)")
        if dataItem?.status == "pending"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = false
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
            self.btnStatus.setTitle("Cancel Booking", for: .normal)
        }else if dataItem?.status == "cancel"{
            self.btnStatus.isHidden = true
            self.btnChat.isHidden = true
        }else if dataItem?.status == "accepted"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = false
            self.btnStatus.setTitle("Pay Now", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
        }else if dataItem?.status == "rejected"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = true
            self.btnStatus.setTitle("Go To Home", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
        }else if dataItem?.status == "confirmed"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = false
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
            if returnValue == true{
                self.btnStatus.setTitle("Did Artist reach at your location?", for: .normal)
            }else{
                self.btnStatus.setTitle("Artist will reach at your location", for: .normal)
            }
        }else if dataItem?.status == "processing"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = true
            self.btnStatus.backgroundColor = UIColor.white
            self.btnStatus.setTitleColor(.black, for: .normal)
            self.btnStatus.setTitle("Your artist is started to performing soon!", for: .normal)
        }else if dataItem?.status == "completed"{
            self.btnStatus.isHidden = false
            self.btnChat.isHidden = true
            self.btnChat.setTitle("You artist completed his performance", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
                       self.btnStatus.setTitleColor(.white, for: .normal)
            self.btnStatus.setTitle("Rate your artist", for: .normal)
        }
    }
}


extension BookingDetailVC :BookingDetailsModelViewDelegate{
    func cancelBookingApiResponse(message: String, isError: Bool) {
        if isError == false{
            self.back()
        }else{
            
        }
        
    }
    
    func bookingDetailsApiResponse(message: String, response: BookingDetailsModel?, isError: Bool) {
        

        self.setInitialData(dataItem: response)
    }
    
   
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
