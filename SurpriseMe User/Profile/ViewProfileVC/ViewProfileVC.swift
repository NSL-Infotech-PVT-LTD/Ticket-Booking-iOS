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
import youtube_ios_player_helper
import Cosmos

class ViewProfileVC: UIViewController {
    
    //MARK:- Outlets -

    @IBOutlet weak var crossBack: UIView!
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
    @IBOutlet var viewContainerPreview: UIView!
    @IBOutlet var imgViewUserPreview: UIImageView!
    @IBOutlet weak var dashlineView: UIImageView!
    @IBOutlet weak var lblGallery: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLiveShowPrice: UILabel!
    @IBOutlet weak var lblDigitalShowPrice: UILabel!
    @IBOutlet weak var lblYoutubeSubscribers: UILabel!
    @IBOutlet weak var lblInstagramSubscribers: UILabel!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnCrossImage: UIButton!
    @IBOutlet weak var youTubePlayer: YTPlayerView!
    
    @IBOutlet weak var lblNewBrandArtist: UILabel!
    
    
    @IBOutlet weak var viewImageViewContainer: UIView!
    @IBOutlet weak var viewCosmoRating: CosmosView!
    //MARK:- Variable -
    var getProfileVMObject = GetArtistProfileViewModel()
    var getArtistProfile : GetArtistModel?
    var youtubeImageUrl = String()
    var youtubeID = String()
    var VideoLink = String()
    var photo = [UIImage]()
   var localVideoUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tap)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewBack.addBottomShadow()
        
        getProfileVMObject.delegate = self //Mark: Delegate call
        //Mark:Api Hitp
        let dictParam = ["id":userArtistID]
        getProfileVMObject.getProfileData(param:dictParam)
        novideoLbl.isHidden = true
        viewContainerPreview.isHidden = true
        imgViewUserPreview.isHidden = true
        btnCrossImage.isHidden = true
        crossBack.isHidden = true
        viewImageViewContainer.isHidden = true

        
        
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
//        self.viewLiveShow.viewLiveShowDashline()
//        self.viewDigitalShow.viewLiveShowDashline()
        
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAboutUs(_:)))
              imgProfile.addGestureRecognizer(tapviewAboutUs)
        
    }
    
    //Mark: CollectionView Height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = serviceCollectionView.collectionViewLayout.collectionViewContentSize.height
        serviceCollectionViewHeight.constant = height
        self.view.layoutIfNeeded()
  }
    
    
    
    @IBAction func btnCrossProfileAction(_ sender: UIButton) {
        viewContainerPreview.isHidden = true
         imgViewUserPreview.isHidden = true
         btnCrossImage.isHidden = true
        crossBack.isHidden = true
        viewImageViewContainer.isHidden = true
    }
    
    @objc func handletapviewAboutUs(_ sender: UITapGestureRecognizer? = nil) {
        //        let photosViewController = NYTPhotosViewController(photos: photo)
        //     present(photosViewController, animated: true)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = CATransitionType(rawValue: "flip")
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        imgViewUserPreview.layer.add(transition, forKey: kCATransition)
        viewContainerPreview.isHidden = false
        imgViewUserPreview.isHidden = false
        viewImageViewContainer.isHidden = false
        btnCrossImage.isHidden = false
        crossBack.isHidden = false
        imgViewUserPreview.image = imgProfile.image
    }

    @IBAction func btnPlayVideoAction(_ sender: UIButton) {
        if youtubeID == "" || youtubeID.isEmpty == true{
            if  let url = URL(string: localVideoUrl) {
                playVideo(url: url)
            }
        }else{
//        playerView.load(withVideoId: youtubeID)
//        print(c)
        }
    }
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)

        let vc = AVPlayerViewController()
        vc.player = player
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) { vc.player?.play() }
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
            if youtubeID == "" || youtubeID.isEmpty == true{
                self.playerView.isHidden = false
                self.youTubePlayer.isHidden = true
            }else{
                youtubeImageUrl = "https://img.youtube.com/vi/\(youtubeID)/0.jpg"
                //MARK: Image banner
                youTubePlayer.load(withVideoId: youtubeID)
                let urlImg = URL(string: youtubeImageUrl)
                imgViedoPlay.sd_setImage(with: urlImg)
                self.playerView.isHidden = true
                self.youTubePlayer.isHidden = false
                return youtubeID
            }
        }else{
            let url = URL(string: Api.videoUrl + link)!
            self.localVideoUrl = Api.videoUrl + link
            if let thumbnailImage = getThumbnailImage(forUrl: url) {
                imgViedoPlay.image =  thumbnailImage
                self.playerView.isHidden = false
                self.youTubePlayer.isHidden = true
            }
        }
        return ""
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    @IBAction func btnReviewonPress(_ sender: UIButton) {
                let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        controller.artistID = userArtistID
        
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
//
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)
        
    }
    
    func profileData(profile :GetArtistModel?)  {
        let imageUrl = Api.imageURLArtist
        self.lblName.text = profile?.name ?? ""
        self.lblLiveShowPrice.text = "\(profile?.converted_currency ?? "")\(" ")\(      profile?.converted_live_price ?? 0)"
        
        if profile?.ratingValue == 0{
            self.viewCosmoRating.isHidden = true
            self.lblNewBrandArtist.isHidden = false
            self.lblNewBrandArtist.text = "BRAND NEW ARTIST"
        }else{
            self.viewCosmoRating.isHidden = false
            self.lblNewBrandArtist.isHidden = true
            self.viewCosmoRating.rating = Double("\(profile?.ratingValue ?? 0)") ?? 0.0
            
        }
        
//        UserDefaults.standard.setValue(profile?.currency ?? "", forKey: UserdefaultKeys.userCurrency)
        self.lblDigitalShowPrice.text = "\(profile?.converted_currency ?? "")\(" ")\(    profile?.converted_digital_price ?? 0)"
        var urlSting : String = "\(Api.imageURLArtist)\(profile?.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let urlImage = URL(string: urlStringaa)!
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        if profile?.image == ""{
            self.imgProfile.isUserInteractionEnabled = false
        }else{
            self.imgProfile.isUserInteractionEnabled = true
        }
        
        
        let attributedString = NSMutableAttributedString(string: profile?.descriptionValue ?? "")
        txtViewAbout.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.blue] as [NSAttributedString.Key: Any]?
        txtViewAbout.attributedText = attributedString
        
        
        //        self.txtViewAbout.text = profile?.descriptionValue ?? ""
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
            if self.getArtistProfile?.categoryArtist.count ?? 0 != 0{
                return self.getArtistProfile?.categoryArtist.count ?? 0
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.serviceCollectionView {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCollectionViewCell", for: indexPath) as! serviceCollectionViewCell
            
          
            
            cell1.lblService.text = "\( getArtistProfile?.categoryArtist[indexPath.row].category_name ?? "")"
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.showCollectionView{
        
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "showCollectionViewCell", for: indexPath) as! showCollectionViewCell
        
        if indexPath.row == 0{
            let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_1 ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))

            let transition = CATransition()
                   transition.duration = 0.5
                   transition.timingFunction = CAMediaTimingFunction(name: .linear)
                   transition.type = CATransitionType(rawValue: "flip")
                   transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromTop
                   imgViewUserPreview.layer.add(transition, forKey: kCATransition)
           viewContainerPreview.isHidden = false
           imgViewUserPreview.isHidden = false
           viewImageViewContainer.isHidden = false
           btnCrossImage.isHidden = false
            crossBack.isHidden = false
            imgViewUserPreview.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        }else if indexPath.row == 1{
            let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_2 ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            let transition = CATransition()
                   transition.duration = 0.5
                   transition.timingFunction = CAMediaTimingFunction(name: .linear)
                   transition.type = CATransitionType(rawValue: "flip")
                   transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromTop
                   imgViewUserPreview.layer.add(transition, forKey: kCATransition)
           viewContainerPreview.isHidden = false
           imgViewUserPreview.isHidden = false
           viewImageViewContainer.isHidden = false
           btnCrossImage.isHidden = false
            crossBack.isHidden = false
            imgViewUserPreview.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            
        }else if indexPath.row == 2{
            let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_3 ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            
            let transition = CATransition()
                   transition.duration = 0.5
                   transition.timingFunction = CAMediaTimingFunction(name: .linear)
                   transition.type = CATransitionType(rawValue: "flip")
                   transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromTop
                   imgViewUserPreview.layer.add(transition, forKey: kCATransition)
           viewContainerPreview.isHidden = false
           imgViewUserPreview.isHidden = false
           viewImageViewContainer.isHidden = false
           btnCrossImage.isHidden = false
            crossBack.isHidden = false
            imgViewUserPreview.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            
        }else{
            let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_4 ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            
            
            let transition = CATransition()
                   transition.duration = 0.5
                   transition.timingFunction = CAMediaTimingFunction(name: .linear)
                   transition.type = CATransitionType(rawValue: "flip")
                   transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromTop
                   imgViewUserPreview.layer.add(transition, forKey: kCATransition)
           viewContainerPreview.isHidden = false
           imgViewUserPreview.isHidden = false
           viewImageViewContainer.isHidden = false
           btnCrossImage.isHidden = false
            crossBack.isHidden = false
            imgViewUserPreview.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        }
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         if collectionView == self.serviceCollectionView {
//            
//            
//            
//         }else{
//            
//        }
//    }
    
    
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


