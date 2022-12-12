//
//  FavoriteCell.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 9/11/2565 BE.
//

import Foundation
import UIKit
import Kingfisher
import Firebase

class FavoriteCell: UICollectionViewCell{
    
    @IBOutlet weak var animeImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var bgView:UIView!
    
    static let identifier = "FavoriteCell"
    
    var favList = [Menu]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 8
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 1
        
    }
    
    func setCell(list: UserFavMovies, positioin: Int, itemWidth: CGFloat){

        titleLabel.text = list.favTitle
        animeImage.kf.setImage(with: URL(string: list.favImage_url))
        
    }
}
