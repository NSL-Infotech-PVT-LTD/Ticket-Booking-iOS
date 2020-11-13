//
//  SearchArtistByNameVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import SDWebImage

class SearchArtistByNameVC: UIViewController {
    
    //MARK:- Variable -
    var objectViewModel = SearchArtistViewModel()
    var arrayHomeArtistList = [SearchArtistModel]()
    
    //MARK:- Outlets -
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var tblArtist: UITableView!
    @IBOutlet var noFoundLbl: UILabel!
    
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        self.tblArtist.tableFooterView = view
        tblArtist.estimatedRowHeight = 60
        tblArtist.rowHeight = UITableView.automaticDimension
        searchTf.delegate = self
        self.objectViewModel.delegate = self
        self.tblArtist.isHidden = true
                self.viewNoData.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tblArtist.isHidden = true
//        self.noFoundLbl.isHidden = true
    }
    
    //MARK:- Custom Button's Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
     @IBAction func btnFilterAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        self.addChild(controller)
        controller.didMove(toParent: self)
        self.view!.addSubview(controller.view!)
    }
    
    
    
}
extension SearchArtistByNameVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHomeArtistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchArtistesdCustomCell
        
        cell.viewContainer.layer.cornerRadius = 8
        cell.viewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viewContainer.layer.shadowOpacity = 1
        cell.viewContainer.layer.shadowRadius = 3
        //MARK:- Shade a view
        cell.viewContainer.layer.shadowOpacity = 0.5
        cell.viewContainer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.viewContainer.layer.masksToBounds = false
        
        let dataItem = arrayHomeArtistList[indexPath.row]
        cell.lblName.text = dataItem.name ?? ""
        cell.categoryLbl.text = "\(dataItem.category?.map({$0}) ?? [] )"
        var urlSting : String = "\(Api.imageURLArtist)\(dataItem.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        print(urlStringaa)
        let urlImage = URL(string: urlStringaa)!
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userArtistID = arrayHomeArtistList[indexPath.row].id ?? 0
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ViewProfileVC)
    }
}


extension SearchArtistByNameVC : SendDataPrevoius{
    
    func getFilterData(message: String, response: [SearchArtistModel]) {
        print("the data is \(response.count)")
        arrayHomeArtistList = response.map({$0})
        
        if arrayHomeArtistList.count > 0{
            self.tblArtist.isHidden = false
            self.viewNoData.isHidden = true
        }else{
            self.tblArtist.isHidden = true
            self.viewNoData.isHidden = false
        }
        
        self.tblArtist.reloadData()
    }
    
}

extension SearchArtistByNameVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let userEnteredString = searchTf.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != ""{
            let dataParam = ["limit":"20","latitude":currentLat,"longitude":currentLong,"search":"\(searchTf.text!)\(string)"] as [String : Any]
            self.objectViewModel.getParamForGetProfile(param: dataParam)
            
        } else {
            self.tblArtist.isHidden = true
            self.viewNoData.isHidden = true
        }
        return true
    }
}

extension SearchArtistByNameVC : SearchArtistViewModelProtocol{
    func getProfileApiResponse(message: String, response: [SearchArtistModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            arrayHomeArtistList = response.map({$0})
            
            if arrayHomeArtistList.count > 0{
                self.tblArtist.isHidden = false
                self.viewNoData.isHidden = true
            }else{
                self.tblArtist.isHidden = true
                self.viewNoData.isHidden = false
            }
            
            
            
//            self.tblArtist.isHidden = false
            self.tblArtist.reloadData()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
