//
//  ReviewVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import Cosmos

class ReviewVC: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var ReviewTableView: UITableView!
    @IBOutlet weak var viewAvgRate: CosmosView!
    
    
    
    //Mark: Variables
    var ReviewRatingVMObject = ReviewRatingViewModel()//ViewModel Declare
    var arrayReviewRatingList = [ReviewRatingModel]()
    var arrayReviewRatingListLoadMore = [ReviewRatingModel]()
    var artistID = Int()
    
    //For Pagination
    var pageInt = 1
    var isLoadMore = Bool()
    
    var refreshControl = UIRefreshControl()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBack.addBottomShadow()
        
        //Mark:tableview delegate/datasource
        ReviewTableView.delegate = self
        ReviewTableView.dataSource = self
        ReviewTableView.reloadData()
        
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.black
        self.ReviewTableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action:#selector(methodPullToRefresh), for: .valueChanged)
        self.ReviewTableView.addSubview(self.refreshControl)
        ReviewTableView.rowHeight = UITableView.automaticDimension
            ReviewTableView.estimatedRowHeight = 44
        
    }
    
    @objc func methodPullToRefresh(){
        self.refreshControl.beginRefreshing()
        let param = ["limit":"20","artist_id": self.artistID,"page":1] as [String : Any]
        ReviewRatingVMObject.getReviewRatingData(param: param)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Mar: ViewModel Object
        LoaderClass.shared.loadAnimation()
        ReviewRatingVMObject.delegate = self
        let param = ["limit":"20","artist_id": self.artistID,"page":1] as [String : Any]
        ReviewRatingVMObject.getReviewRatingData(param: param)
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((ReviewTableView.contentOffset.y + ReviewTableView.frame.size.height) >= ReviewTableView.contentSize.height)
        {
            print("scrollViewDidEndDragging")
            if isLoadMore == false{
                self.pageInt = self.pageInt + 1
                print("scrollViewDidEndDragging page number is \(self.pageInt)")
                let param = ["limit": "20","page": pageInt] as [String : Any]
                ReviewRatingVMObject.getReviewRatingData(param: param)
            }
        }
    }
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ReviewVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return arrayReviewRatingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let indexData = arrayReviewRatingList[indexPath.row]

        //Mark: CustomerProfile Image Set
        let imageUrl = Api.imageURL
        let urlProfile = URL(string: imageUrl + (indexData.customerDetail?.imageProfile)! )
        cell.imgCustomerProfile.sd_setImage(with: urlProfile, placeholderImage: UIImage(named: "image_placeholder"))

        cell.lblCustomerName.text = indexData.customerDetail?.name
        cell.lblReview.text = indexData.review
        cell.viewRating.rating = indexData.rate ?? 0.0
        let dateConvertedCreate = self.convertDateToStringCreate(profile: indexData.createdAt ?? "")
        cell.lblDate.text = "\(dateConvertedCreate )"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReviewVC : ReviewRatingViewModelProtocol{
    func getReviewRatingApiResponse(success: String, message: String, response: [ReviewRatingModel]) {
        LoaderClass.shared.stopAnimation()
        
        if success == "Success" {
            //self.viewAvgRate.rating = response[0].avg_rate ?? 0.0
            
            if self.pageInt == 1{
                self.arrayReviewRatingList = response
                self.refreshControl.endRefreshing()
            }else{
                self.arrayReviewRatingListLoadMore = response.map({$0})
                self.arrayReviewRatingList = self.arrayReviewRatingList + self.arrayReviewRatingListLoadMore
                self.refreshControl.endRefreshing()
            }
            
            if arrayReviewRatingListLoadMore.count > 0{
                isLoadMore = true
            }else{
                isLoadMore = false
            }
            
            arrayReviewRatingList = response
            if arrayReviewRatingList.isEmpty == true {
                ReviewTableView.isHidden = true
            }
            else {
                ReviewTableView.isHidden = false
            }
            self.ReviewTableView.reloadData()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        //Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}

extension ReviewVC{
    //Mark:Date Convert to String Format and Call ViewDidLoad
    func convertDateToStringCreate(profile : String) -> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString =  profile // string purpose I add here
        // convert your string to date
        
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        //formatter.dateFormat = "hh:mm a"
        formatter.dateFormat = "dd MMMM, yyyy"
        // again convert your date to string
        let createDate = formatter.string(from: yourDate ?? Date())
        return createDate
    }
}
