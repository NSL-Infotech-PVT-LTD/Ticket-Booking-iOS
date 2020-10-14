//
//  EditDateVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 31/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class EditDateVC: UIViewController {
    var first: Int = -1
    var second: Int = -1
    //MARK:- Outlets -
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var dateListCollectionView:
    UICollectionView!
    
    //MARK:- Variable -
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var indxArr = [Int]()
    var viewModelObject = BookingStoreViewModel()
    var aarayTime = ["12:00 AM - 01:00 AM","01:00 AM - 02:00 AM","02:00 AM - 03:00 AM","03:00 AM - 04:00 AM","04:00 AM - 05:00 AM","05:00 AM - 06:00 AM","06:00 AM - 07:00 AM","07:00 AM - 8:00 AM","8:00 AM - 9:00 AM","9:00 AM - 10:00 AM","10:00 AM - 11:00 AM","11:00 AM - 12:00 PM","12:00 PM - 01:00 PM","01:00 PM - 02:00 PM","02:00 PM - 03:00 PM","03:00 PM - 04:00 PM","04:00 PM - 05:00 PM","05:00 PM - 06:00 PM","06:00 PM - 07:00 PM","07:00 PM - 8:00 PM","8:00 PM - 9:00 PM","9:00 PM - 10:00 PM","10:00 PM - 11:00 PM","11:00 PM - 12:00 AM"]
    var aarayTimeSecond = ["00:00 - 01:00","01:00 - 02:00","02:00 - 03:00","03:00 - 04:00","04:00 - 05:00","05:00 - 06:00","06:00 - 07:00","07:00 - 08:00","08:00 - 09:00","09:00 - 10:00","10:00 - 11:00","11:00 - 12:00","12:00 - 13:00","13:00 - 14:00","14:00 - 15:00","15:00 - 16:00","16:00 - 17:00","17:00 - 18:00","18:00 - 19:00","19:00 - 20:00","20:00 - 21:00","21:00 - 22:00","22:00 - 23:00","23:00 - 00:00"]
    var firstTime = String()
    var secondTime = String()
    
    var arrayTestingData = [[String : [[String : Any]]]]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setInitialSetup()
        
        print(aarayTime.count)
        print(aarayTimeSecond.count)
        
     
        
        
        
        
    }
    
    //MARK:- Set Initial Design -
    func setInitialSetup()  {
        self.viewBack.addBottomShadow()
        //Mark: CollectionView Delegate
        dateListCollectionView.delegate = self
        dateListCollectionView.dataSource = self
        self.dateListCollectionView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 20)/2, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        dateListCollectionView!.collectionViewLayout = layout
        self.viewBack.addBottomShadow()
        self.viewModelObject.delegate = self
        
        let selectDate = self.convertDateToStringBook(profile: selectedDate)
        self.lblDate.text = selectDate
        let selectday = self.convertdayToStringBook(profile: selectedDate)
        self.lblDay.text = selectday
        
        
        
    }
    func convertDateToStringBook(profile : String)-> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMMM , yyyy"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
    }
    
    func convertdayToStringBook(profile : String)-> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "EEEE"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
    }
    
    
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        
        
        
        // create the alert
        let alert = UIAlertController(title: "", message: "Do you want to book this Artist", preferredStyle: UIAlertController.Style.alert)

      alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in

            // do something like...
      
              
              
              
        if self.first != -1 && self.second == -1{
                  
                  let inputString = self.aarayTimeSecond[self.first]
                  let splits = inputString.components(separatedBy: " - ")
                  self.firstTime = splits[0]
                  self.secondTime = splits[1]
            let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID,"address":currentAddress] as [String : Any]
                  
                  print("the dict param is \(dataParam)")
                  
                  self.viewModelObject.getParamForBookingStore(param: dataParam)
                  
              }else if self.first == -1 && self.second == -1{
                   Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Please select Any Slot", btnOkTitle: "Done") {
                  }
              }
              
              else   {
                 
                  let inputString = self.aarayTimeSecond[self.first]
                  let splits = inputString.components(separatedBy: " - ")
                  self.firstTime = splits[0]
                  
                  
                  let inputString2 = self.aarayTimeSecond[self.second]
                  let splits2 = inputString2.components(separatedBy: " - ")
                  self.secondTime = splits2[1]
                 let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID,"address":currentAddress] as [String : Any]
                  
                  print("the dict param is \(dataParam)")
                  
                  self.viewModelObject.getParamForBookingStore(param: dataParam)
              }

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
     

        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
      
        
        
    }
    
    
    
    @IBAction func btnClearAllActtion(_ sender: UIButton) {
        
        first = -1
        second = -1
        self.dateListCollectionView.reloadData()
        
    }
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveOnPress(_ sender: UIButton) {
    }
    func checkRange(num: Int) -> Bool {
        
        if first < second{
            if first...second ~= num{
                return true
            }else{
                return false
            }
        }else{
            if second...first ~= num{
                return true
            }else{
                return false
            }
        }
        
    }
    
    
}
extension EditDateVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aarayTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateListCollectionViewCell", for: indexPath) as! dateListCollectionViewCell
        cell.lblTimeSelect.text = aarayTime[indexPath.row]
        
        if first != -1 && second != -1{
            if checkRange(num: indexPath.row){
                cell.viewCell.backgroundColor = UIColor(red: 54/255.0, green: 57/255.0, blue: 110/255.0, alpha: 1.00)
                cell.lblTimeSelect.textColor = UIColor.white
            }else{
                cell.viewCell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.00)
                cell.lblTimeSelect.textColor = UIColor.black
            }
        }else if first != -1 && first == indexPath.row{
            cell.viewCell.backgroundColor = UIColor(red: 54/255.0, green: 57/255.0, blue: 110/255.0, alpha: 1.00)
            cell.lblTimeSelect.textColor = UIColor.white
        }else{
            cell.viewCell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.00)
            cell.lblTimeSelect.textColor = UIColor.black
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dataItem = aarayTimeSecond[indexPath.row]
        print(dataItem)
        if first == -1{
            first = indexPath.row
        }else if first < indexPath.row{
            second = indexPath.row
        }else{
            let temp = first
            first = indexPath.row
            second = temp
            
        }
        print("the index array is \(indxArr)")
        self.dateListCollectionView.reloadData()
    }
}


extension EditDateVC : BookingStoreViewModelProtocol{
    func bookingStoreApiResponse(message: String, response: [String : Any], isError: Bool) {
        if isError == true{
            
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Booking Successfull", btnOkTitle: "Done") {
                userArtistID = 0
                
                for controller in (self.navigationController?.viewControllers ?? []) as Array {
                    if controller.isKind(of: HOmeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
