//
//  FavoriteCatsCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import UIKit

protocol FavoriteDelegate: AnyObject {
    func favoriteButtonPressed(indexPath: Int)
}

class FavoriteCatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var catImage: UIImageView!
    
    var cellDelegate: FavoriteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.backgroundColor = .black
        self.backgroundColor = .bgBlack
        setUpImageView()
        setUpButton()
    }

    func setUpImageView() {
        catImage.contentMode = .scaleAspectFill
        catImage.layer.cornerRadius = 12
    }
    
    func setUpButton() {
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)    //  버튼 defualt 
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("FavoriteCatsCollectionViewCell - favoriteButtonPressed()")
        cellDelegate?.favoriteButtonPressed(indexPath: sender.tag)
    }
}
