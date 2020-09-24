//
//  BookingVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class BookingVC: UIViewController {
    
    @IBOutlet weak var viewBookingDash: UIView!
    @IBOutlet weak var BookingTableView: UITableView!
    
    //MARK:- Variables -
    var objectViewModel = BookingListModelView()
    var arrayBookingList : [GetBookingListModel]?
    var arraySetBookingList : [GetBookingListModel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
         self.hideTable()
    }
    
    func hideTable()  {
        let dictParam = ["limit":"20" , "page":""] as [String : Any]
        objectViewModel.delegate = self
        objectViewModel.getParamForBookingList(param: dictParam)
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
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
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
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension BookingVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBookingList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        cell.viewBookingBorderDash.addDashedBorder( UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00), withWidth: 1, cornerRadius: 6, dashPattern: [5,4])
        cell.btnseeAllDetails.addTarget(self, action: #selector(btnseeAllDetailsOnPress(sender:)), for: .touchUpInside)
        cell.btnseeAllDetails.tag = indexPath.row
        let dataItem = self.arrayBookingList?[indexPath.row]
        cell.lblName.text =  dataItem?.artist_detail?.name ?? ""
        cell.lblDate.text = self.convertDateBook(profile: dataItem?.dateInString ?? "")
        cell.lblBookDate.text = self.convertDateToStringBook(profile: dataItem?.dateInString ?? "")
        let fromTime = self.convertTimeInto24(timeData: dataItem?.from_time ?? "")
        let toTime = self.convertTimeInto24(timeData: dataItem?.to_time ?? "")
        cell.lblBookingTime.text = "\(fromTime)" + " to " + "\(toTime)"
        var urlSting : String = "\(Api.imageURLArtist)\(dataItem?.image ?? "")"
                     let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            let urlImage = URL(string: urlStringaa)!
              cell.userImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.userImgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "ProfilePic"))
        cell.lblSkill.text = dataItem?.type ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        controller.hidesBottomBarWhenPushed = true
        controller.dictProfile = self.arrayBookingList?[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}


//Error handling Get Profile Api Here:-
extension BookingVC: BookingListModelViewDelegate {
    func bookingListApiResponse(message: String, response: [GetBookingListModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            let filterData = Set(response)
            arrayBookingList = filterData.map({$0})
            self.BookingTableView.reloadData()
        }
    }
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
