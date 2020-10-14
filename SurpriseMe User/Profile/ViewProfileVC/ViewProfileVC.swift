//
//  ViewProfileVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 26/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

//    class globalVariable: NSObject {
//        static var profile = GetProfileModel()
//    }

import UIKit
import SDWebImage
import NVActivityIndicatorView
import YoutubePlayer_in_WKWebView
import AVKit
import AVFoundation

class ViewProfileVC: UIViewController {
    
    
    @IBOutlet weak var showCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLiveShow: UIView!
    @IBOutlet weak var viewDigitalShow: UIView!
    
    
    @IBOutlet weak var novideoLbl: UILabel!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var imgViedoPlay: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgProfileYoutube: UIImageView!
    @IBOutlet weak var imgProfileInsta: UIImageView!
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var lblInstaLink: UILabel!
    @IBOutlet weak var lblYoutubeLink: UILabel!
    
    @IBOutlet weak var dashlineView: UIImageView!
    @IBOutlet weak var lblGallery: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLiveShowPrice: UILabel!
    @IBOutlet weak var lblDigitalShowPrice: UILabel!
    @IBOutlet weak var lblYoutubeSubscribers: UILabel!
    @IBOutlet weak var lblInstagramSubscribers: UILabel!
    @IBOutlet weak var txtViewAbout: UITextView!
    
    @IBOutlet weak var viewBack: UIView!
    var getProfileVMObject = GetArtistProfileViewModel()
    var getArtistProfile : GetArtistModel?
    var youtubeImageUrl = String()
    var youtubeID = String()
    var VideoLink = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewBack.addBottomShadow()
        
        getProfileVMObject.delegate = self //Mark: Delegate call
        //Mark:Api Hitp
        let dictParam = ["id":userArtistID]
        getProfileVMObject.getProfileData(param:dictParam)
        novideoLbl.isHidden = true
        
        //Mark: CollectionView Delegate
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        self.serviceCollectionView.reloadData()
        //getProfileVMObject.delegate = self
        
        //Mark: CollectionView Delegate
        showCollectionView.delegate = self
        showCollectionView.dataSource = self
        self.showCollectionView.reloadData()
        
        //Mark: UIView border dash
        self.viewLiveShow.viewLiveShowDashline()
        self.viewDigitalShow.viewLiveShowDashline()
        
        //        self.viewLiveShow.addDashedBorder(UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00), withWidth: 1, cornerRadius: 4, dashPattern: [2,2])
    }
    
    //Mark: CollectionView Height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = serviceCollectionView.collectionViewLayout.collectionViewContentSize.height
        serviceCollectionViewHeight.constant = height
        self.view.layoutIfNeeded()
        
        
        
        
        
    }
    
    
    @IBAction func btnPlayVideoAction(_ sender: UIButton) {
        playerView.load(withVideoId: youtubeID )
        print(youtubeID)
    }
    
    //MARK: Youtuve Viedo URL ID get and convert thumnail banner
    func extractYoutubeId(fromLink link: String) -> String {
        let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regExp = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        let array: [Any] = (regExp?.matches(in: link, options: [], range: NSRange(location: 0, length: (link.count))))!
        if array.count > 0 {
            
            let result: NSTextCheckingResult? = array.first as? NSTextCheckingResult
            youtubeID = (link as NSString).substring(with: (result?.range)!)
            
            print(youtubeID)
            youtubeImageUrl = "https://img.youtube.com/vi/\(youtubeID)/0.jpg"
            //MARK: Image banner
            let urlImg = URL(string: youtubeImageUrl)
            imgViedoPlay.sd_setImage(with: urlImg)
            return youtubeID
        }
        return ""
    }
    
    
    @IBAction func btnReviewonPress(_ sender: UIButton) {
                let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
                navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    
    
    @IBAction func btnUpdateProfileOnPress(_ sender: UIButton) {
        //        _ = UIStoryboard(name: "Profile", bundle: nil)
        //        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        //        let navController = UINavigationController(rootViewController: VC1)
        //        navController.modalPresentationStyle = .overCurrentContext
        //        navController.isNavigationBarHidden = true
        //
        //        //Mark: Data pass to edit profile
        //        VC1.allDataProfile = self.getProfileModelObject
        //
        //        self.present(navController, animated:true, completion: nil)
    }
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.back()
        //        self.transitionViewPop()//Mark: common func
    }
    
    
    @IBAction func btnYoutubeLinkAction(_ sender: UIButton) {
        let YoutubeID =  "Ktync4j_nmA" // Your Youtube ID here
        let appURL = NSURL(string: "youtube://www.youtube.com/watch?v=\(YoutubeID)")!
        let webURL = NSURL(string: "https://www.youtube.com/watch?v=\(YoutubeID)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
        
    }
    
    
    
    @IBAction func btnInstagramAction(_ sender: UIButton) {
//        let instagramHooks = getArtistProfile?.social_link_insta ?? ""
        let instagramHooks = "https://www.instagram.com/abhishekmishra3676/"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        userArtistID =  getArtistProfile?.id ?? 0
        
        
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        controller.name = getArtistProfile?.name ?? ""
        controller.userImage = getArtistProfile?.image ?? ""
        //         controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    @IBAction func btnBookAction(_ sender: UIButton) {
        
        userArtistID =  getArtistProfile?.id ?? 0
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
        
    }
    
    func profileData(profile :GetArtistModel?)  {
        let imageUrl = Api.imageURLArtist
        self.lblName.text = profile?.name ?? ""
        self.lblLiveShowPrice.text = "\(profile?.currency ?? "")\(" ")\(      profile?.live_price_per_hr ?? 0)"
        
        
        self.lblDigitalShowPrice.text = "\(profile?.currency ?? "")\(" ")\(    profile?.digital_price_per_hr ?? 0)"
        var urlSting : String = "\(Api.imageURLArtist)\(profile?.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let urlImage = URL(string: urlStringaa)!
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        self.txtViewAbout.text = profile?.descriptionValue ?? ""
        self.lblInstagramSubscribers.text = profile?.social_link_insta ?? ""
        self.lblYoutubeSubscribers.text = profile?.social_link_youtube ?? ""
        
        self.VideoLink = profile?.shows_video ?? ""
        print(VideoLink)
        
        //MARK:Viedo play and URL banner set
        self.extractYoutubeId(fromLink: VideoLink)
        
                if profile?.shows_video ?? "" == "" {
                    imgViedoPlay.isHidden = true
                    novideoLbl.isHidden = false
                    playerView.isUserInteractionEnabled = false
                }else{
                    imgViedoPlay.isHidden = false
                    novideoLbl.isHidden = true
                    playerView.isUserInteractionEnabled = true

        
                }
        self.serviceCollectionView.reloadData()
        if profile?.shows_image_1 == "" && profile?.shows_image_2 == "" && profile?.shows_image_3 == "" && profile?.shows_image_4 == ""{
            heightConstant.constant = 0
            self.showCollectionView.isHidden = true
            self.dashlineView.isHidden = true
            self.lblGallery.isHidden = true
        }else{
            heightConstant.constant = 111
            self.showCollectionView.isHidden = false
            self.dashlineView.isHidden = false
            self.lblGallery.isHidden = false
            self.showCollectionView.reloadData()
        }
    }
}
//Mark: Protocol Function


extension ViewProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.showCollectionView {
            
             if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 == ""{
                return 1

            }else if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 == ""{
                return 2

            }else if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 == ""{
                return 3

             }else{
                return 4
            }
            
        }else{
            if self.getArtistProfile?.category?.count ?? 0 != 0{
                return self.getArtistProfile?.category?.count ?? 0
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.serviceCollectionView {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCollectionViewCell", for: indexPath) as! serviceCollectionViewCell
            cell1.lblService.text = "\( getArtistProfile?.category?[indexPath.row] ?? "")"
            return cell1
            
        }else {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "showCollectionViewCell", for: indexPath) as! showCollectionViewCell
            
            if indexPath.row == 0{
                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_1 ?? "")"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                let urlImage = URL(string: urlStringaa)!
                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                
            }else if indexPath.row == 1{
                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_2 ?? "")"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                let urlImage = URL(string: urlStringaa)!
                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                
            }else if indexPath.row == 2{
                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_3 ?? "")"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                let urlImage = URL(string: urlStringaa)!
                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                
            }else{
                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_4 ?? "")"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                let urlImage = URL(string: urlStringaa)!
                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            }
            
            return cell2
        }
    }
}

extension UIView {
    func viewLiveShowDashline() {
        let color = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00).cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}


extension ViewProfileVC : GetArtistProfileViewModelProtocol{
    func successAlert(susccessTitle: String, successMessage: GetArtistModel?, from: Bool) {
        if from == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "something went wrong!", btnOkTitle: "Done") {
            }
        }else{
            getArtistProfile = successMessage
            self.profileData(profile: successMessage)
        }
    }
    
    
    
    func addAddress() {
        
    }
    
    
}


