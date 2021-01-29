//
//  SelectPayMentTypeVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 20/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import HSCycleGalleryView

class SelectPayMentTypeVC: UIViewController {
    
    //    let colors: [UIColor] = [.cyan, .blue, .green, .red]
    
    @IBOutlet var viewIdealPay: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Constants
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var arrayCardList = [GetCardModel]()
    
    // MARK: - Constants
//    let cellWidth = (1 / 4) * UIScreen.main.bounds.width
//    let sectionSpacing = (1 / 8) * UIScreen.main.bounds.width
//    let cellSpacing = (1 / 16) * UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.reloadData()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: 200)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView!.collectionViewLayout = layout
        
        
        //        screenSize = UIScreen.main.bounds
        //        screenWidth = screenSize.width
        //        screenHeight = screenSize.height
        
        //        let layout = PagingCollectionViewLayout()
        //        layout.scrollDirection = .horizontal
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        //        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        //        layout.minimumLineSpacing = cellSpacing
        //
        //        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.showsHorizontalScrollIndicator = false
        //        collectionView.backgroundColor = .white
        //        collectionView.decelerationRate = .normal
        //        collectionView.dataSource = self
        
        //        // Do any additional setup after loading the view, typically from a nib.
        //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        //        layout.itemSize = CGSize(width: cellWidth, height: 200)
        //        layout.minimumInteritemSpacing = 20
        //        layout.minimumLineSpacing = 20
        //        layout.scrollDirection = .horizontal
        //        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.showsHorizontalScrollIndicator = false
        //        collectionView.backgroundColor = .white
        //        collectionView.decelerationRate = .normal
        //        collectionView!.collectionViewLayout = layout
        
        //collectionView constraint
        design()
        //  applyConstraints()
        self.getCard()
        self.viewHeader.addBottomShadow()
        self.viewIdealPay.addShadowWithCornerRadius(viewObject: self.viewIdealPay)
        
    }
    
    
    @IBAction func btnSeeAllAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func getCollection() {
        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: intoCollection.frame.size.height)
        //        layout.scrollDirection = .horizontal
        //        intoCollection!.collectionViewLayout = layout
        //                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //                let  width = ((self.collectionView.frame.width - 20) / 3.2)
        //                let height = width + 30
        //                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //                layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: collectionView.frame.size.height)
        //        layout.scrollDirection = .vertical
        //                layout.minimumLineSpacing = 0
        //                layout.minimumInteritemSpacing = 0
        //                collectionView!.collectionViewLayout = layout
    }
    
    
    // MARK: - Setup
    
    private func design() {
        view.backgroundColor = .white
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customcell")
    }
//    private func applyConstraints() {
//        view.addSubview(collectionView)
//        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collectionView.heightAnchor.constraint(equalToConstant: cellWidth).isActive = true
//    }
    
    
    func getCard() {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            let dict = ["search":"","limit":"20"]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerCardList, method: .post, param: dict, header: headerToken) { (response, error) in
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    
                    
                    self.arrayCardList.removeAll()
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    let dataDict = GetCardModel.init(resposne: index)
                                    self.arrayCardList.append(dataDict)
                                }
                            }
                            
                            
                            self.collectionView.reloadData()
                            
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }
                else {
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
    }
    
    
    func removeCard(cardNumber : String)  {
        
        
        
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            let dict = ["card_id":cardNumber]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerdeleteCard, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.getCard()
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }
                else {
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
        
    }
    
    
    @objc func btnBookAction(sender:UIButton)  {
        
        let dataItem = arrayCardList[sender.tag]
        
        //    Helper.showOKCancelAlertWithCancelCompletion(onVC: self, title: "", message: "Do you want to delete this card", btnOkTitle: "Ok", btnCancelTitle: "No", onOk: {
        //        self.removeCard(cardNumber: dataItem.id ?? "")
        //
        //    }) {
        //        print("")
        //    }
        let alert = UIAlertController(title: "", message: "Do you want to delete this card", preferredStyle: UIAlertController.Style.alert)
        //
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
            self.removeCard(cardNumber: dataItem.id ?? "")
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        //
        //
        //        // show the alert
        self.present(alert, animated: true, completion: nil)
        //
        //
        
        
        
        
    }
    
    
    @IBAction func btnAddAnotherCardAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension SelectPayMentTypeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! CustomCardCollectionCell
        
        let dataItem = arrayCardList[indexPath.row]
        print(dataItem.name)
        
        //        cell.heightConstant.constant = view.frame.size.height
        //        cell.widthConstant.constant = self.view.frame.size.width
        
        cell.lblCardNumber.text = "****  -  ****  -  ****\(dataItem.last4 ?? "")"
        cell.lblUserName.text = "\(dataItem.name ?? "")"
        cell.lblExpire.text = "\(dataItem.exp_month ?? 0)/\(dataItem.exp_year ?? 0)"
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnBookAction), for: .touchUpInside)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width/2, height: collectionView.frame.size.height)
    }
}


