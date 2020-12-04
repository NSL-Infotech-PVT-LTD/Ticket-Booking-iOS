//
//  NotificationVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 26/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var NotificationTableView: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    //MARK:- Variable -
    var objectViewModel = NotificationViewModel()
    var arrayNotification = [NotificationModel]()
    var arrayNotificationLoadMore = [NotificationModel]()
    var pageInt = 1
    var isLoadMore = Bool()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationTableView.delegate = self
        NotificationTableView.dataSource = self
        NotificationTableView.reloadData()
       // refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         // refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
         // NotificationTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // self.hideTable()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.hideTable()
        let userIsNotify = UserDefaults.standard.value(forKey: UserdefaultKeys.is_notify) as? String
        print("the status is \(userIsNotify)")
    }
    
    @IBAction func btnSwitchedAction(_ sender: UISwitch) {
        if sender.isOn{
            let dictParam = ["is_notify":1]
            objectViewModel.getParamForChangeNotificationStatus(param: dictParam)
            
        }else{
            let dictParam = ["is_notify":0]
            objectViewModel.getParamForChangeNotificationStatus(param: dictParam)
        }
        
    }
    
     func convertTimeInto24(timeData : String) -> String {
               let dateAsString = timeData
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                   
                   let date = dateFormatter.date(from: dateAsString)
              dateFormatter.locale = Locale.current

                       dateFormatter.timeZone = TimeZone.current
                       dateFormatter.dateFormat = "dd-MMM ,h:mm a"
                   return dateFormatter.string(from: date ?? Date())
            
     
           }
    
    
    func hideTable()  {
        
        self.notificationListData(page: 1)
    }
    
    
      func notificationListData(page : Int) {
            
            let dictParam = ["limit":"20" , "page":page] as [String : Any]
            let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
            
            if Reachability.isConnectedToNetwork() {
                LoaderClass.shared.loadAnimation()
                
                ApiManeger.sharedInstance.callApiWithHeader(url: Api.getNotification, method: .post, param: dictParam, header: headerToken) { (response, error) in
                    print(response)
                    LoaderClass.shared.stopAnimation()
                    if error == nil {
                        let result = response
                        if let status = result["status"] as? Bool {
                            if status ==  true{
                                        if page == 1{
                                    print("the notification list is \(response)")
                                                            
                                                            self.arrayNotification.removeAll()

                                                            let dataDict = result["data"] as? [String : Any]
                                            
                                            let isNotifiy = dataDict?["is_notify"] as? String
                                            print("the notification status is \(isNotifiy)")
                                            
                                            if isNotifiy ?? "" == "1"{
                                                self.btnSwitch.isOn = true
                                            }else{
                                                self.btnSwitch.isOn = false

                                            }
                                            
                                            
                                            
                                            
                                            
                                                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                                                for index in dataArray{
                                                                   
                                                                    let dataDict = NotificationModel.init(resposne: index)
                                                                    self.arrayNotification.append(dataDict)
                                                                }
                                                            }
                                        }else{
                                            

                                                                                                       let dataDict = result["data"] as? [String : Any]
                                                                                                       if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                                                                                        
                                                                                                        self.arrayNotificationLoadMore.removeAll()

                                                                                                           for index in dataArray{
                                                                                                              
                                                                                                               let dataDict = NotificationModel.init(resposne: index)
                                                                                                               self.arrayNotificationLoadMore.append(dataDict)
                                                                                                           }
                                                                                                        self.arrayNotification = self.arrayNotification + self.arrayNotificationLoadMore
                                                                                                        if (self.arrayNotificationLoadMore.count == 0){
                                                                                                            self.isLoadMore = true
                                                                                                        }else{
                                                                                                            self.isLoadMore = false
                                                                                                        }
                                                   }
                                            
                                }
                                if self.arrayNotification.count > 0 {
                                    self.NotificationTableView.isHidden = false
                                    self.viewNoData.isHidden = true
                                }else{
                                    self.NotificationTableView.isHidden = true
                                    self.viewNoData.isHidden = false
                                }
                                self.NotificationTableView.reloadData()
                           }else{
                                
                            }
                        }
                        else {
                            if let error_message = response["error"] as? [String:Any] {
                                if (error_message["error_message"] as? String) != nil {
                                }
                            }
                        }
                    }else{
                        
                    }
                }}
            else{
                self.NotificationTableView.isHidden = true
                self.viewNoData.isHidden = false
                self.lblNoData.text = "No Internet Connection"
          }
        }
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.back()
    }
    
    
    @IBAction func btnTryAgainAction(_ sender: UIButton) {
        self.hideTable()

    }
    
 
    //Pagination
       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if ((NotificationTableView.contentOffset.y + NotificationTableView.frame.size.height) >= NotificationTableView.contentSize.height)
           {
               print("scrollViewDidEndDragging")
               print("scrollViewDidEndDragging page number is \(self.pageInt)")
                   self.pageInt = self.pageInt + 1
                   let dictParam = ["limit":"20" , "page":pageInt] as [String : Any]
               if isLoadMore == true{
                   self.showToast(message: "No More Data", font: .systemFont(ofSize: 12.0))
               }else{
                self.notificationListData(page: self.pageInt)
               }
           }
       }
    
}

extension NotificationVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let dataitem = self.arrayNotification[indexPath.row]
        cell.titleNotification.text = dataitem.body ?? ""
        cell.lblDetails.text = dataitem.title ?? ""
        cell.lblTime.text = self.convertTimeInto24(timeData: dataitem.created_at ?? "")
        if dataitem.is_read == 0{
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
            cell.notifyReadView.isHidden = false
        }else{
            cell.backgroundColor = UIColor.white
            cell.notifyReadView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let notiID = arrayNotification[indexPath.row].id ?? 0
        let dictParam = ["id":notiID]
        objectViewModel.getParamForChangenotificationRead(param: dictParam)
        let dictData = arrayNotification[indexPath.row]
               let bookingID = dictData.artist_detail?.booking_id ?? 0
        if dictData.artist_detail?.target_model == "Message"{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
                    controller.hidesBottomBarWhenPushed = true
             controller.comingFrom = "NotificationTabs"
             controller.recieverIDHistoryList = dictData.artist_detail?.booking_id ?? 0
             navigationController?.pushViewController(controller, animated: true)
            
        }else{
            let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
                          controller.hidesBottomBarWhenPushed = true
                  
                   controller.isComingFrom = "Notification"
                   controller.bookingID = bookingID
                   navigationController?.pushViewController(controller, animated: true)
        }
        
        
       
        
        
           
       }
}

//Error handling Get Profile Api Here:-
extension NotificationVC: NotificationViewModelProtocol {
    func getNotificationApiResponse(message: String, response: [NotificationModel], isError: Bool, isMorePagination: Bool) {
        print("the notification list status value is \(isError)")
        if isError == false{
            self.arrayNotification.removeAll()
            self.arrayNotification = response.map({$0})
        }
        
        
        if self.arrayNotification.count > 0 {
            NotificationTableView.isHidden = false
            viewNoData.isHidden = true
        }else{
            NotificationTableView.isHidden = true
            viewNoData.isHidden = false
        }
        
        self.NotificationTableView.reloadData()

    }
    
    func changeNotificationRead(message: String, response: String, errorMessage: String) {
        print("the notifcation is getting")
    }
    
   
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    func changeNotificationStatus(message: String, response: ChangeNotificationModel? ,errorMessage: String){
        print("the notification status")
    }
    
}
