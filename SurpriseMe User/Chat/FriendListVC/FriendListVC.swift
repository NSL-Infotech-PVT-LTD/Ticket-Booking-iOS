//
//  FriendListVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class FriendListVC: UIViewController {
    
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewMsgDash: UIView!
    @IBOutlet weak var MessageTableView: UITableView!
    
    
    
    //MARK:- Variable -
    var arrayFreind = [GetFreindListModel]()
    var arrayFreindLoadMore = [GetFreindListModel]()
    
    var objectModelView : GetUserChatListViewM?
    var isLoadMore = Bool()
    var pageInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark: UIView DashLine
        self.viewMsgDash.addDashedBorderMsg()
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    
    
    
    
    
    func hideTable(page:Int)  {
        //        viewNoData.isHidden = true
        MessageTableView.isHidden = true
        viewNoData.isHidden = true
        
        LoaderClass.shared.loadAnimation()
        let dictParam = ["limit":"20" , "page":page] as [String : Any]
        objectModelView?.delegate = self
        //        self.objectModelView?.getFriendList(param: dictParam)
        
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) as! String)"]
        if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.getFreindList, method: .post, param: dictParam, header: header) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            if let dataDetail = response["data"] as? [String : Any]{
                                
                                
                                //pagination is start from here ..
                                if self.pageInt == 1{
                                    
                                    self.arrayFreind.removeAll()
                                    if let data = dataDetail["list"] as? [[String:Any]] {
                                        for getcategory in data {
                                            print("dictionary paer dlsnfsad \(getcategory)")
                                            self.arrayFreind.append(GetFreindListModel.init(resposne: getcategory ))
                                        }
                                    }
                                    
                                }else{
                                    self.arrayFreindLoadMore.removeAll()
                                    
                                    
                                    if let data = dataDetail["list"] as? [[String:Any]] {
                                        for getcategory in data {
                                            print("dictionary paer dlsnfsad \(getcategory)")
                                            self.arrayFreindLoadMore.append(GetFreindListModel.init(resposne: getcategory ))
                                        }
                                    }
                                    
                                    self.arrayFreind = self.arrayFreind + self.arrayFreindLoadMore
                                    if (self.arrayFreindLoadMore.count == 0){
                                        self.isLoadMore = true
                                    }else{
                                        self.isLoadMore = false
                                    }
                                    print("the number of running fixture is \(self.arrayFreindLoadMore.count)")
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                print("the freind List is \(self.arrayFreind.count)")
                                
                                if self.arrayFreind.count >  0{
                                    
                                    self.MessageTableView.isHidden = false
                                    self.viewNoData.isHidden = true
                                    
                                    
                                }else{
                                    self.MessageTableView.isHidden = true
                                    self.viewNoData.isHidden = false
                                    
                                }
                                
                                self.MessageTableView.reloadData()
                                //
                                
                            }
                        }else{
                            self.MessageTableView.isHidden = true
                            self.viewNoData.isHidden = false
                            if let error = response["error"] as? String {
                                //                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error)
                            }
                        }
                    }else{
                        //                        self.delegate?.errorAlert(errorTitle: Alerts.Error, errorMessage: error?.localizedDescription ?? "")
                    }
                }
            }
        }else{
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideTable(page: 1)
        
        
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((MessageTableView.contentOffset.y + MessageTableView.frame.size.height) >= MessageTableView.contentSize.height)
        {
            print("scrollViewDidEndDragging")
            if isLoadMore == false{
                self.pageInt = self.pageInt + 1
                print("scrollViewDidEndDragging page number is \(self.pageInt)")
                let dictParam = ["limit":"20" , "page":pageInt] as [String : Any]
                self.hideTable(page: self.pageInt)
                //                   objectViewModel.getParamForNotification(param: dictParam)
            }
        }
    }
    
}
extension FriendListVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFreind.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        let dataItem = arrayFreind[indexPath.row]
      //  cell.viewHeader.addShadowWithCornerRadius(viewObject: cell.viewHeader)
        
        
        let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
        
        if   dataItem.is_read == 0{
            cell.lblUnreadCount.isHidden = true
        }else{
            cell.lblUnreadCount.isHidden = false
            
        }
        
        
        if userName == dataItem.receiver_name ?? ""{
            cell.lblFrindName.text = dataItem.sender_name ?? ""
            //Mark: Reciver Profile Image Set
            let urlSting : String = "\(Api.imageURLArtist)\(dataItem.sender_image ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            print(urlStringaa)
            let urlImage = URL(string: urlStringaa)!
            cell.imgUserFriend.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUserFriend.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "Group 1337"))
            
        }else{
            cell.lblFrindName.text = dataItem.receiver_name ?? ""
            //Mark: Reciver Profile Image Set
            let urlSting : String = "\(Api.imageURLArtist)\(dataItem.receiver_image ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            print(urlStringaa)
            let urlImage = URL(string: urlStringaa)!
            cell.imgUserFriend.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUserFriend.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "Group 1337"))
        }
        
        
        
        
        cell.lblLastMssg.text = dataItem.message ?? ""
        dateTimeCommenMethod.sharesDateTime.date(dateSet: dataItem.created_at ?? "")
        print("the timing is \(self.convertTimeInto24(timeData: dataItem.created_at ?? ""))")
        
        cell.lblTime.text = self.convertTimeInto24(timeData: dataItem.created_at ?? "")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        controller.reciverData =  arrayFreind[indexPath.row]
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension UIView {
    func addDashedBorderMsg() {
        let color = UIColor.white.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 6).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}


extension FriendListVC : getUseChatListListViewModelProtocol{
    func errorAlert(errorTitle: String, errorMessage: String) {
        print("dsfdsfds")
        
    }
    
    func getFriendListViewArray(response:[GetFreindListModel]){
        arrayFreind = response.map({$0})
        if arrayFreind.count > 0{
            MessageTableView.isHidden = false
            viewNoData.isHidden = true
        }else{
            print("the list is\(arrayFreind.count)")
            
            MessageTableView.isHidden = true
            viewNoData.isHidden = false
        }
        
        self.MessageTableView.reloadData()
        
    }
    
    
}

