//
//  BookingVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import SDWebImage
import Toast_Swift

class BookingVC: UIViewController {
    
    @IBOutlet weak var viewBookingDash: UIView!
    @IBOutlet weak var BookingTableView: UITableView!
    @IBOutlet weak var lblBookingTitle: UILabel!
    @IBOutlet weak var lblBookingDescr: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblNoBookingRightNow: UILabel!
    @IBOutlet weak var lblUnableToFindBooking: UILabel!
    
    //MARK:- Variables -
    var objectViewModel = BookingListModelView()
    var arrayBookingList = [GetBookingListModel]()
    var arraySetBookingList = [GetBookingListModel]()
    var pageInt = Int()
    var isLoadMore = Bool()
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.systemPink
        self.BookingTableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action:#selector(methodPullToRefresh), for: .valueChanged)
        self.BookingTableView.addSubview(self.refreshControl)
    }
    
    @objc func methodPullToRefresh(){
        viewNoData.isHidden = true
        BookingTableView.isHidden = true
        self.getBookingListData(param: 1)
    }
    
    func setLocalisation(){
        self.lblBookingTitle.text = "BOOKINGS".localized()
        self.lblBookingDescr.text = "MANAGE_BOOKING_YOURS".localized()
        self.lblNoBookingRightNow.text = "NO_BOOKING_RIGHT".localized()
        self.lblUnableToFindBooking.text = "UNABLE_FIND_BOOKING_PAGE".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        pageInt = 1
        self.setLocalisation()
        if idealPayment == true && idealPaymentAppDelegate == true{
        }else if idealPayment == true && idealPaymentAppDelegate == false{
            let storyboard1 = UIStoryboard(name: "BookingDetail", bundle: nil)
            let controller1 = storyboard1.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            controller1.bookingID = bookingPaymentID ?? 0
            idealPaymentAppDelegate = true
            idealPayment = false
            controller1.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller1, animated: true)
        }else{
            self.hideTable()
        }
    }
    
    func checkIdealPayment(notification:Notification) -> Void {
        guard let idealPayment = notification.userInfo!["idealPayment"] as? Bool else { return }
        if idealPayment == true  {
            //
        }else{
            self.hideTable()
        }
    }
    
    func navigateToSuccess() {
        let storyboard1 = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller1 = storyboard1.instantiateViewController(withIdentifier: "SuccessPaymentVC") as! SuccessPaymentVC
        let navController = UINavigationController(rootViewController: controller1)
        navController.modalPresentationStyle = .overCurrentContext
        navController.isNavigationBarHidden = true
        self.navigationController?.pushViewController(controller1, animated: true)
    }
    
    
    func hideTable()  {
        viewNoData.isHidden = true
        BookingTableView.isHidden = true
        self.getBookingListData(param: 1)
    }
    
    
    func convertDateBook(profile : String)-> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMMM"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
    }
    
    
    func convertDateToStringBookUTC(profile : String)-> String{
        let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "yyyy-MM-dd"
                let myString =  profile // string purpose I add here
                // convert your string to date
                let yourDate = formatter.date(from: myString)
                //then again set the date format whhich type of output you need
                formatter.dateFormat = "dd MMMM , yyyy"
                // again convert your date to string
                let bookDate = formatter.string(from: yourDate ?? Date())
                return bookDate
    }
    
    
    func convertDateToStringBook(profile : String)-> String{
//        let formatter = DateFormatter()
//        // initially set the format based on your datepicker date / server String
//        formatter.dateFormat = "yyyy-MM-dd"
//        let myString =  profile // string purpose I add here
//        // convert your string to date
//        let yourDate = formatter.date(from: myString)
//        //then again set the date format whhich type of output you need
//        formatter.dateFormat = "dd MMMM , yyyy"
//        // again convert your date to string
//        let bookDate = formatter.string(from: yourDate ?? Date())
//        return bookDate
        
        let dateAsString = profile
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let date = dateFormatter.date(from: dateAsString)
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd MMMM , yyyy"
                return dateFormatter.string(from: date ?? Date())
        
        
    }
    
    func convertDateFormater(date: String) -> String {
//        let dateAsString = date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let date = dateFormatter.date(from: dateAsString)
//        dateFormatter.dateFormat = "h:mm a"
//        let Date12 = dateFormatter.string(from: date ?? Date())
//        return Date12
        
        
        let dateAsString = date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let date = dateFormatter.date(from: dateAsString)
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date ?? Date())
        
        
        
    }
    
    
    func convertTimeInto24(timeData : String) -> String {
        let dateAsString = timeData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date ?? Date())
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterOnPress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .coverVertical
        navController.isNavigationBarHidden = true
        self.present(navController, animated:true, completion: nil)
    }
    
    @objc func btnseeAllDetailsOnPress(sender: UIButton){
        //
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        controller.hidesBottomBarWhenPushed = true
        let bookingDict = self.arrayBookingList[sender.tag]
        controller.bookingID = bookingDict.id ?? 0
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    func getBookingListData(param: Int) {
        let dictParam = ["limit":"20" , "page":param] as [String : Any]
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.bookinglist, method: .post, param: dictParam, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            if param == 1{
                                self.arrayBookingList.removeAll()
                                let dataDict = result["data"] as? [String : Any]
                                if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                    for index in dataArray{
                                        print("the index value is \(index)")
                                        let dataDict = GetBookingListModel.init(resposne: index)
                                        self.arrayBookingList.append(dataDict)
                                    }
                                    print("the page number is value is \(param) and count is \(self.arrayBookingList.count)")
                                }
                            }else{
                                let dataDict = result["data"] as? [String : Any]
                                if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                    self.arraySetBookingList.removeAll()
                                    for index in dataArray{
                                        print("the index value is \(index)")
                                        let dataDict = GetBookingListModel.init(resposne: index)
                                        self.arraySetBookingList.append(dataDict)
                                    }
                                    self.arrayBookingList = self.arrayBookingList + self.arraySetBookingList
                                    if (self.arraySetBookingList.count == 0){
                                        self.isLoadMore = true
                                    }else{
                                        self.isLoadMore = false
                                    }
                                    print("the number of running fixture is \(self.arraySetBookingList.count)")
                                }
                            }
                            
                            if self.arrayBookingList.count > 0{
                                self.viewNoData.isHidden = true
                                self.BookingTableView.isHidden = false
                            }else{
                                print("the page number is no data found\(self.arrayBookingList.count )")
                                self.viewNoData.isHidden = false
                                self.BookingTableView.isHidden = true
                            }
                            self.refreshControl.endRefreshing()
                            
                            self.BookingTableView.reloadData()
                        }
                        else {
                            if let error_message = response["error"] as? [String:Any] {
                                if (error_message["error_message"] as? String) != nil {
                                }
                            }
                        }
                    }
                    else {
                        //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                    }
                }
            }}
        else{
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }
    
    
    func convertTimeIntoLocalInUTC(timeData : String) -> String {

        let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let showDate = inputFormatter.date(from: timeData)
                inputFormatter.dateFormat = "dd-MMM-yyyy"
                let resultString = inputFormatter.string(from: showDate!)
                print(resultString)
                return resultString
        
        
        
    }
    
    
    
    func convertTimeIntoLocal(timeData : String) -> String {

        let dateAsString = timeData
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let date = dateFormatter.date(from: dateAsString)
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                return dateFormatter.string(from: date ?? Date())
        
        
        
    }
    
    
    
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((BookingTableView.contentOffset.y + BookingTableView.frame.size.height) >= BookingTableView.contentSize.height)
        {
            print("scrollViewDidEndDragging")
            print("scrollViewDidEndDragging page number is \(self.pageInt)")
            self.pageInt = self.pageInt + 1
            let dictParam = ["limit":"20" , "page":pageInt] as [String : Any]
            if isLoadMore == true{
                var style = ToastStyle()
                // this is just one of many style options
                style.messageColor = .white
                self.view.makeToast("No More Data Found", duration: 3.0, position: .bottom, style: style)
            }else{
                self.getBookingListData(param: self.pageInt)
            }
        }
    }
}

extension BookingVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataItem = self.arrayBookingList[indexPath.row]
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        //        cell.viewBookingBorderDash.addDashedBorder( UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00), withWidth: 1, cornerRadius: 6, dashPattern: [5,4])
        cell.btnseeAllDetails.addTarget(self, action: #selector(btnseeAllDetailsOnPress(sender:)), for: .touchUpInside)
        cell.btnseeAllDetails.setTitle("BOOKING_DETAILS".localized(), for: .normal)
        cell.btnseeAllDetails.tag = indexPath.row
        cell.lblName.text =  dataItem.artist_detail?.name ?? ""
        cell.lblOrderID.text = "#\(dataItem.id ?? 0)"
        //        cell.lblDate.text = self.convertDateBook(profile: dataItem.dateInString ?? "")
      
        
        
        let timeZone = TimeZone.current.identifier
         print(timeZone)
        if timeZone == "Asia/Kolkata"{
            
            let localTime = self.convertTimeIntoLocalInUTC(timeData: dataItem.dateInString ?? "")
            cell.lblDate.text = localTime
            cell.lblBookDate.text = self.convertDateToStringBookUTC(profile: dataItem.dateInString ?? "")
            
        }else{
            let localTime = self.convertTimeIntoLocal(timeData: dataItem.dateInString ?? "")
            cell.lblDate.text = localTime
            cell.lblBookDate.text = self.convertDateToStringBook(profile: dataItem.dateInString ?? "")
        }
        
        
        
        
        cell.lblAddress.text = dataItem.address ?? ""
        //            cell.lblBookingStatus.text = "Status:- \(dataItem.status?.capitalized ?? "")"
        cell.lblBookingStatus.text = "\(dataItem.status?.capitalized ?? "")"
        let timeInto24 = self.convertDateFormater(date: dataItem.from_time ?? "")
        let timeInto24to_time = self.convertDateFormater(date: dataItem.to_time ?? "")
        cell.lblBookingTime.text = "\(timeInto24)" + " to " + "\(timeInto24to_time)"
        let urlSting : String = "\(Api.imageURLArtist)\(dataItem.artist_detail?.imageProfile ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlImage = URL(string: urlStringaa)!
        cell.userImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.userImgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "Group 489"))
        if dataItem.type == "live"{
            cell.lblSkill.text = "IN_PERSON_SHOW_HEADER".localized()
        }else{
            cell.lblSkill.text = "VIRTUAL_SHOW_HEADER".localized()
        }
        cell.viewBookingBorderDash.layer.cornerRadius = 8
        cell.viewBookingBorderDash.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viewBookingBorderDash.layer.shadowOpacity = 1
        cell.viewBookingBorderDash.layer.shadowRadius = 3
        //MARK:- Shade a view
        cell.viewBookingBorderDash.layer.shadowOpacity = 0.5
        cell.viewBookingBorderDash.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.viewBookingBorderDash.layer.masksToBounds = false
        
        if dataItem.status == "pending"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6784313725, blue: 0.2, alpha: 1)
        } else if dataItem.status == "rejected" || dataItem.status == "report"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.2784313725, blue: 0.2, alpha: 1)
        }else if dataItem.status == "cancel"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.2784313725, blue: 0.2, alpha: 1)
        }else if dataItem.status == "accepted"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.7725490196, blue: 0.4980392157, alpha: 1)
        }else if dataItem.status == "confirmed"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.7725490196, blue: 0.4980392157, alpha: 1)
        }else if dataItem.status == "processing"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6784313725, blue: 0.2, alpha: 1)
        }else if dataItem.status == "completed_review"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.7725490196, blue: 0.4980392157, alpha: 1)
            cell.lblBookingStatus.text = "COMPLETED".localized()
        }else if dataItem.status == "completed"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.7725490196, blue: 0.4980392157, alpha: 1)
        }else if dataItem.status == "payment_failed"{
            cell.tittelView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.2784313725, blue: 0.2, alpha: 1)
            cell.lblBookingStatus.text = "FAILED".localized()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataItem = self.arrayBookingList[indexPath.row]
        if dataItem.status == "completed_review"{
            return 230
        }else{
            return 230
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        controller.hidesBottomBarWhenPushed = true
        let bookingDict = self.arrayBookingList[indexPath.row]
        controller.bookingID = bookingDict.id ?? 0
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//Error handling Get Profile Api Here:-
extension BookingVC: BookingListModelViewDelegate {
    func bookingListApiResponse(message: String, response: [GetBookingListModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
            }
        }else{
            if self.pageInt == 1{
                arrayBookingList.removeAll()
                arrayBookingList = response.map({$0})
            }else{
                self.arraySetBookingList.removeAll()
                arraySetBookingList = response.map({$0})
                arrayBookingList = arrayBookingList + self.arraySetBookingList
                if arraySetBookingList.count == 0{
                    isLoadMore = true
                }
            }
            if arrayBookingList.count > 0{
                viewNoData.isHidden = true
                BookingTableView.isHidden = false
            }else{
                viewNoData.isHidden = false
                BookingTableView.isHidden = true
            }
            self.BookingTableView.reloadData()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
