//
//  HOmeViewController.swift
//  SwiftApp_Demo
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class HOmeViewController: UIViewController , UIGestureRecognizerDelegate {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewUpdateLocation: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tableView_out: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    //MARK:- Variable -
    var pinchGesture = UIPinchGestureRecognizer()

    
    //MARK:- View's Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setDashLine()
        self.SetInitialSetup()
        self.pinchGesture.delegate = self
      
        
        let tapviewimgUserProfile = UITapGestureRecognizer(target: self, action: #selector(self.handletaptapviewimgUserProfile(_:)))
        imgUserProfile.isUserInteractionEnabled = true
        imgUserProfile.addGestureRecognizer(tapviewimgUserProfile)
    }
    
    @IBAction func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {
       print("clicccccckkkkk")
    }
    
    @objc func handletaptapviewimgUserProfile(_ sender: UITapGestureRecognizer? = nil) {
        
       
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                          let transition = CATransition()
                          transition.duration = 0.5
                          transition.timingFunction = CAMediaTimingFunction(name: .default)
                          transition.type = .fade
                          transition.subtype = .fromRight
                   controller.hidesBottomBarWhenPushed = true
                          navigationController?.view.layer.add(transition, forKey: kCATransition)
                          navigationController?.pushViewController(controller, animated: false)

       }
    
    //MARK:- Setting tap gesture -
    func SetInitialSetup() {
        tabBarController?.tabBarItem.selectedImage = UIImage.init(named: "artist_navbar")
        self.searchTxt.isUserInteractionEnabled = false
        self.viewSearch.isUserInteractionEnabled = true
        let tapviewFacebook = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewSearch(_:)))
               viewSearch.addGestureRecognizer(tapviewFacebook)
        
        let viewTapUpdateLocation = UITapGestureRecognizer(target: self, action: #selector(self.handletapLocation(_:)))
                      viewUpdateLocation.addGestureRecognizer(viewTapUpdateLocation)

    }
    
    
    func setDashLine()  {
        let color = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00).cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = viewHeader.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 6).cgPath
        viewHeader.layer.addSublayer(shapeLayer)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- Handling tap Gesture Method -
   @objc func handletapviewSearch(_ sender: UITapGestureRecognizer? = nil) {
          // handling code
    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                   let VC = storyboard.instantiateViewController(withIdentifier: "SearchArtistVC") as! SearchArtistVC
                   let navController = UINavigationController(rootViewController: VC)
                   navController.modalPresentationStyle = .overCurrentContext
                   navController.modalTransitionStyle = .crossDissolve
                   VC.hidesBottomBarWhenPushed = true
                   navController.isNavigationBarHidden = true
                   self.present(navController, animated:true, completion: nil)
    
      }
    
    @objc func handletapLocation(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
               controller.hidesBottomBarWhenPushed = true
               navigationController?.pushViewController(controller, animated: true)
       }
    
    
    
    @IBAction func btnViewProfileAction(_ sender: UIButton) {
        
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                          let transition = CATransition()
                          transition.duration = 0.5
                          transition.timingFunction = CAMediaTimingFunction(name: .default)
                          transition.type = .fade
                          transition.subtype = .fromRight
                   controller.hidesBottomBarWhenPushed = true
                          navigationController?.view.layer.add(transition, forKey: kCATransition)
                          navigationController?.pushViewController(controller, animated: false)
        
        
    }
    
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
               let transition = CATransition()
               transition.duration = 0.5
               transition.timingFunction = CAMediaTimingFunction(name: .default)
               transition.type = .fade
               transition.subtype = .fromRight
        controller.hidesBottomBarWhenPushed = true
               navigationController?.view.layer.add(transition, forKey: kCATransition)
               navigationController?.pushViewController(controller, animated: false)
    }
    
}

extension HOmeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! homeTableCell
        let color = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00).cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = cell.viewContainer.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [5,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 6).cgPath
        cell.viewContainer.layer.addSublayer(shapeLayer)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
}

class homeTableCell: UITableViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var PlayPauseImage: UIImageView!
    @IBOutlet weak var nameLbl_out: UILabel!
    @IBOutlet weak var descriptionLbl_out: UILabel!
    @IBOutlet weak var RolePlayLbl_out: UILabel!
    @IBOutlet weak var ratingView_out: UIView!
    @IBOutlet weak var bookBtn_out: UIButton!
    @IBOutlet weak var viewContainer: UIView!
}


extension HOmeViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        self.presentViewController(viewController : "SearchArtistVC" ,value :"Dashboard")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
      textField.resignFirstResponder()

        return true
    }
}


