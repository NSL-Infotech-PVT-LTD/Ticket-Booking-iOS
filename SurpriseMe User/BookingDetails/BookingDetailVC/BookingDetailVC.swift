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
    @IBOutlet weak var btnChatTopBar: UIButton!
    @IBOutlet weak var btnLiveConcert: UIButton!
    @IBOutlet weak var lblNewStatus: UILabel!
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
   @IBOutlet weak var lblRatingArtist: UILabel!
    @IBOutlet weak var viewContainerRating: UIView!
   @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet weak var viewRating: UILabel!
    @IBOutlet weak var viewCosmo: CosmosView!
    @IBOutlet weak var ratingDesc: UITextView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblOtpNumber: UILabel!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet weak var lblShowType: UILabel!
   @IBOutlet weak var reportReasonLbl: UILabel!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var viewOtherResons: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPicker: UIView!
    
    //MARK:- Variable -
    var id : String?
    var bookingID = Int()
    var bookingIDNotification : Any?
    var isComingFrom  = String()
    var dictProfile : BookingDetailsModel?
    var viewModelObject = BookingDetailsModelView()
    var currentDate = Date()
    var currentTitle = String()
    var arrayReport = ["Select Reason","Artist Denied Duty","Artist is unreachable","Artist not picking call","Other"]
    var resonReport = String()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.viewHeader.addBottomShadow()
        self.setAllData()
        self.viewOtp.isHidden = true
        self.viewContainer.isHidden = true
        self.viewPicker.isHidden = true
        self.viewOtherResons.isHidden = true
        self.lblOtpNumber.isHidden = true
        self.reportReasonLbl.isHidden = true
        self.pickerView.reloadAllComponents()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("BookingDetail"), object: nil)
    }
    
    
    @objc func userLoggedIn(userInfo:Notification){
        let data = userInfo.userInfo?["target_id"] as? String
        //MARK: Load start
   }
    
    func setAllData() {
        self.viewModelObject.delegate = self
        if isComingFrom == "Notification"{
            let param = ["id":bookingID]
            self.viewModelObject.getParamForBookingDetails(param: param)
        }else if  isComingFrom == "NotificationCame"{
            let param = ["id":userArtistIDBooking ?? 0]
            self.viewModelObject.getParamForBookingDetails(param: param as [String : Any])
        }
        else{
            let param = ["id":bookingID]
            self.viewModelObject.getParamForBookingDetails(param: param)
        }
    }
    
    @IBAction func btnChatTopBarOnPress(_ sender: UIButton) {
        userArtistID =  dictProfile?.artist_detail?.ID ?? 0
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        controller.name = dictProfile?.artist_detail?.name ?? ""
        controller.userImage = dictProfile?.artist_detail?.imageProfile ?? ""
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    @IBAction func btnCrosssAction(_ sender: UIButton) {
        self.viewOtp.isHidden = true
        self.viewContainer.isHidden = true
        self.lblOtpNumber.isHidden = true
    }
    
    func compareTime(performTime : String) -> Bool {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        let crunnetDateStr = formatter.string(from: currentDate)
        let endDate = formatter.date(from: performTime) ?? Date()
        let formatter1 = DateComponentsFormatter()
        formatter1.unitsStyle = .brief // May delete the word brief to let Xcode show you the other options
        formatter1.allowedUnits = [.hour, .minute]
        formatter1.maximumUnitCount = 2  // Show just one unit (i.e. 1d vs. 1d 6hrs)
        let stringDate = formatter1.string(from: currentDate, to: endDate)
        let currentSeconds = currentDate.timeIntervalSince1970
        let endseconds = endDate.timeIntervalSince1970
        let pendingSeconds = Int(endseconds - currentSeconds)
        let getHours = pendingSeconds / 3600
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
        return Date12
    }
    
    func cancelBookingAction()  {
        
        
        let alert = UIAlertController(title: "", message: "Do you want to cancel this booking?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            
            if  self.isComingFrom == "NotificationCame"{
                let param = ["booking_id":userArtistIDBooking ?? 0 , "status":"cancel"] as [String : Any]
                self.viewModelObject.getParamForCancelBooking(param: param)
            }else{
                let param = ["booking_id":self.bookingID , "status":"cancel"] as [String : Any]
                self.viewModelObject.getParamForCancelBooking(param: param)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func payNowAction()  {
        
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectPaymentVC") as! SelectPaymentVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        transition.type = .fade
        transition.subtype = .fromRight
        
        if  isComingFrom == "NotificationCame"{
            
            print("the id is \(bookingIDNotification)")
            bookingPaymentID = userArtistIDBooking as? Int
        }else  if isComingFrom == "Notification"{
                   
                   bookingPaymentID = bookingID as? Int
        }
        else{
            bookingPaymentID = bookingID
        }
        controller.hidesBottomBarWhenPushed = true
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
        
    }
    
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if  isComingFrom == "NotificationCame"{
            let param = ["booking_id":userArtistIDBooking ?? 0 , "status":"report","report":self.descriptionTxt.text!] as [String : Any]
            self.viewModelObject.getParamForCancelBooking(param: param)
        }else{
            let param = ["booking_id":bookingID , "status":"report","report":self.descriptionTxt.text!] as [String : Any]
            self.viewModelObject.getParamForCancelBooking(param: param)
        }
        
    }
    
    
    @IBAction func btnCrossDescAction(_ sender: UIButton) {
        self.viewContainer.isHidden = false
        self.viewPicker.isHidden = false
        self.viewOtherResons.isHidden = true
        pickerView.reloadAllComponents()
    }
    
    
    @IBAction func btnCancelPickerAction(_ sender: UIButton) {
        self.viewContainer.isHidden = true
        self.viewPicker.isHidden = true
        self.viewOtherResons.isHidden = true
        
    }
    
    
    func setInitialHome()  {
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
        let navigationController = UINavigationController(rootViewController: vc1)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        
        let buttonTitle = sender.titleLabel?.text
        currentTitle = buttonTitle ?? ""
        if buttonTitle ?? "" == "Cancel Booking"{
            self.cancelBookingAction()
        }else if buttonTitle ?? "" == "Pay Now" ||  buttonTitle ?? "" == "Pay Now"{
            self.payNowAction()
        }else if buttonTitle ?? "" == "Go To Home"{
            self.setInitialHome()
        }else if buttonTitle ?? "" == "Did Artist reach at your location?"{
            let alert = UIAlertController(title: "", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                self.viewOtp.isHidden = false
                self.viewContainer.isHidden = false
                self.lblOtpNumber.isHidden = false
                self.lblOtpNumber.text = "Your OTP is: \(self.dictProfile?.otp ?? 0)\n Share your OTP with your Artist"
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
                self.viewContainer.isHidden = false
                self.viewPicker.isHidden = false
                
            }))
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
        
        
        
        
        //        userArtistID =  dictProfile?.artist_detail?.ID ?? 0
        //        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        //        controller.name = dictProfile?.artist_detail?.name ?? ""
        //        controller.userImage = dictProfile?.artist_detail?.imageProfile ?? ""
        //        navigationController?.pushViewController(controller, animated: true)
    }
    
    func convertDateToStringBook(profile : String)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd MMMM,yyyy"
        let bookDate = formatter.string(from: yourDate ?? Date())
        return bookDate
    }
    
    
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        
        var reson = String()
        //        required w''hen you mark booking as report denyied,unreachable,unable to call, other
        
        if resonReport == "" || resonReport == "Select Reason"{
            Helper.showOKAlert(onVC: self, title: "", message: "Select your reason")
            
        }else{
            
            let alert = UIAlertController(title: "", message: "Do you want to report this artist?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
                if self.resonReport == "Artist is unreachable"{
                    reson = "unreachable"
                    
                }else if self.resonReport == "Artist not picking call"{
                    reson = "unable to call"
                }else if self.resonReport == "Artist Denied Duty"{
                    reson = "denyied"
                }
                if  self.isComingFrom == "NotificationCame"{
                    let param = ["booking_id":userArtistIDBooking ?? 0 , "status":"report","report":reson] as [String : Any]
                    self.viewModelObject.getParamForCancelBooking(param: param)
                }else{
                    let param = ["booking_id":self.bookingID , "status":"report","report":reson] as [String : Any]
                    self.viewModelObject.getParamForCancelBooking(param: param)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Custom Button Action -
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        
        if isComingFrom == "Payment"{
            
            for controller in (self.navigationController?.viewControllers ?? []) as Array {
                if controller.isKind(of: BookingVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }else{
                    self.setInitialHome()
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func setInitialData(dataItem :BookingDetailsModel?)  {
        lblNewStatus.text = "\(dataItem?.status?.capitalized ?? "")"
        btnLiveConcert.setTitle(dataItem?.type?.capitalized ?? "" , for: .normal)
        dictProfile = dataItem
        if dataItem?.status == "completed_review"{
            
            self.viewContainerRating.isHidden = false
            self.btnStatus.isHidden = true
            self.btnChatTopBar.isHidden = true
            self.reportReasonLbl.isHidden = false
            self.reportReasonLbl.text = dataItem?.rate_detail?.review ?? ""
            lblPaymentStatus.text =  "Paid: " + "\(dataItem?.artist_detail?.currency ?? "")" + " " + "\(dataItem?.price ?? 0.0)"
            
            self.lblRatingArtist.text = "\(dataItem?.rate_detail?.rate ?? 0)"
            
            //            chatTopOutlet.constant = 160
            self.viewCosmo.isHidden = false
            //            self.ratingDesc.isHidden = false
            self.viewCosmo.isUserInteractionEnabled = false
            //            self.ratingDesc.isUserInteractionEnabled = false
            //            self.ratingDesc.text = dataItem?.rate_detail?.review ?? ""
            self.viewCosmo.rating = Double(dataItem?.rate_detail?.rate ?? 0)
        }else{
            //            chatTopOutlet.constant = 39
            self.viewCosmo.isHidden = true
            //            self.ratingDesc.isHidden = true
        }
        self.lblName.text = dataItem?.artist_detail?.name ?? ""
        self.lblAddress.text = dataItem?.address ?? ""
        //        self.lblOTP.isHidden = true
        //        self.lblOTP.text = "OTP : \(dataItem?.otp ?? 0)\n Don't share this OTP with any one"
        //        self.lblShowType.text = "Show type :- \(dataItem?.type ?? "")"
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
            self.viewContainerRating.isHidden = true
            
            self.btnStatus.isHidden = false
            self.btnChatTopBar.isHidden = false
            lblPaymentStatus.text = "Not paid"
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
            self.btnStatus.setTitle("Cancel Booking", for: .normal)
        }else if dataItem?.status == "cancel"{
            self.viewContainerRating.isHidden = true
            self.btnStatus.setTitle("Go To Home", for: .normal)
            
            self.btnStatus.isHidden = false
            self.btnChatTopBar.isHidden = true
            lblPaymentStatus.text = "Not paid"
            
        }else if dataItem?.status == "accepted"{
            self.viewContainerRating.isHidden = true
            
            self.btnStatus.isHidden = false
            self.btnChatTopBar.isHidden = false
            lblPaymentStatus.text = "Not paid"
            
            self.btnStatus.setTitle("Pay Now", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
        }else if dataItem?.status == "rejected"{
            self.viewContainerRating.isHidden = true
            
            self.btnStatus.isHidden = false
            lblPaymentStatus.text = "Not paid"
            
            self.btnChatTopBar.isHidden = true
            self.btnStatus.setTitle("Go To Home", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
        }else if dataItem?.status == "confirmed"{
            self.btnStatus.isHidden = false
            self.viewContainerRating.isHidden = true
            
            self.btnChatTopBar.isHidden = false
            lblPaymentStatus.text =  "Paid: " + "\(dataItem?.artist_detail?.currency ?? "")" + " " + "\(dataItem?.price ?? 0.0)"
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
            if returnValue == true{
                self.btnStatus.setTitle("Did Artist reach at your location?", for: .normal)
            }else{
                self.btnStatus.setTitle("Artist will reach at your location", for: .normal)
            }
        }else if dataItem?.status == "processing"{
//            self.btnStatus.isHidden = false
//            self.viewContainerRating.isHidden = true
//            self.btnChatTopBar.isHidden = false
            self.viewContainerRating.isHidden = true
                       
                       self.btnStatus.isHidden = false
                       self.btnChatTopBar.isHidden = false
            
            lblPaymentStatus.text =  "Paid: " + "\(dataItem?.artist_detail?.currency ?? "")" + " " + "\(dataItem?.price ?? 0.0)"
            self.btnStatus.backgroundColor = UIColor.white
            self.btnStatus.setTitleColor(.black, for: .normal)
            self.btnStatus.setTitle("Your artist is start to perform!", for: .normal)
        }else if dataItem?.status == "completed"{
            self.btnStatus.isHidden = false
            self.viewContainerRating.isHidden = true
            
            self.btnChatTopBar.isHidden = true
            lblPaymentStatus.text =  "Paid: " + "\(dataItem?.artist_detail?.currency ?? "")" + " " + "\(dataItem?.price ?? 0.0)"
            self.btnStatus.setTitle("You artist completed his performance", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
            self.btnStatus.setTitle("Rate your artist", for: .normal)
        }else if dataItem?.status == "report"{
            self.btnStatus.isHidden = true
            self.viewContainerRating.isHidden = true
            lblPaymentStatus.text =  "Paid: " + "\(dataItem?.artist_detail?.currency ?? "")" + " " + "\(dataItem?.price ?? 0.0)"
            self.btnChatTopBar.isHidden = true
            self.reportReasonLbl.isHidden = false
            self.reportReasonLbl.text = "Reason:- \(dataItem?.reportReason?.report ?? "")"
        }else if dataItem?.status == "payment_failed"{
            self.viewContainerRating.isHidden = true
            
            self.btnStatus.isHidden = false
            self.btnChatTopBar.isHidden = false
            lblPaymentStatus.text = "Not paid"
            self.btnStatus.setTitle("Pay Now", for: .normal)
            self.btnStatus.backgroundColor = UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1)
            self.btnStatus.setTitleColor(.white, for: .normal)
        }
    }
}


extension BookingDetailVC :BookingDetailsModelViewDelegate{
    func cancelBookingApiResponse(message: String, isError: Bool) {
        if isError == false{
            
            if isComingFrom == "Payment"{
                for controller in (self.navigationController?.viewControllers ?? []) as Array {
                    if controller.isKind(of: BookingVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else{
                        self.setInitialHome()
                        
                    }
                }
            }else{
                self.back()
            }
        }else{
        }
    }
    
    func bookingDetailsApiResponse(message: String, response: BookingDetailsModel?, isError: Bool) {
        self.setInitialData(dataItem: response)
    }
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
    }
    
}


extension BookingDetailVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayReport.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayReport[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        resonReport = self.arrayReport[row]
        print("the reson is \(resonReport)")
        
        if resonReport == "Artist is unreachable"{
            
        }else if resonReport == "Artist not picking call"{
            
        }else if resonReport == "Artist is unreachable"{
            
        }else if resonReport == "Artist Denied Duty"{
            
        }
        if self.arrayReport[row] == "Other"{
            self.viewPicker.isHidden = false
            self.viewContainer.isHidden = false
            self.viewPicker.isHidden = false
            self.viewOtherResons.isHidden = false
        }
   }
}

extension BookingDetailVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your reason..."{
            textView.text = ""
        }}
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write your reason..."
        } }
}
