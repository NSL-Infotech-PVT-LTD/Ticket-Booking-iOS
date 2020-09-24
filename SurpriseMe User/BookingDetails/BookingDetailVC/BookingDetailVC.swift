//
//  BookingDetailVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 28/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import TagListView

class BookingDetailVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewDash1: UIView!
    @IBOutlet weak var viewDash2: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var viewList: TagListView!
    //MARK:- Variable -
    var id : String?
    var dictProfile : GetBookingListModel?
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        self.setAllData()
    }
    
    func setAllData() {
        self.lblName.text = dictProfile?.artist_detail?.name ?? ""
        var urlSting : String = "\(Api.imageURLArtist)\(dictProfile?.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        print(urlStringaa)
        let urlImage = URL(string: urlStringaa)!
        self.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        lblDate.text = self.convertDateToStringBook(profile: dictProfile?.dateInString ?? "")
        lblTime.text = "\(dictProfile?.from_time ?? "")" + " to " + "\(dictProfile?.to_time ?? "")"
        viewList.addTag("\(dictProfile?.type ?? "")")

        
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
    
}


