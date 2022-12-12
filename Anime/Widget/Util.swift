//
//  Util.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 4/11/2565 BE.
//

import Foundation
import UIKit

//MARK: - ProgressView

var activityView: UIView?

extension UIViewController {
    
    func startLoading() {
        activityView = UIView(frame: self.view.bounds)
        //aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        activityView?.backgroundColor = .clear
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.layer.cornerRadius = 6
        ai.center = activityView!.center
        ai.startAnimating()
        activityView?.addSubview(ai)
        self.view.addSubview(activityView!)
    }
    
    func stopLoading() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    
}
