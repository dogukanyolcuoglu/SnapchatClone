//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    
    
    //MARK: - Variables

    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    
    //MARK: - State funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snap = selectedSnap {
            
            timeLeftLabel.text = "Time left: \(snap.timeLeft)"
            
            for imageUrl in snap.imageUrlArray {
                
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
        }
        
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
        
        imageSlideShow.backgroundColor = UIColor.white
       
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        
        imageSlideShow.pageIndicator = pageIndicator
        
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideShow.setImageInputs(inputArray)
        
        self.view.addSubview(imageSlideShow)
        self.view.bringSubviewToFront(timeLeftLabel)
    }

}
