//
//  CatsCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import UIKit

protocol PostFavoriteCatDelegate: AnyObject {
    func favoriteButtonPressed(indexPath: Int)
}

class CatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imformationLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var cellDelegate: PostFavoriteCatDelegate?
    
    var isFavoriteCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = .black
        
        setUpImageView()
        self.backgroundColor = .bgBlack
    }
    
    func setUpImageView() {
        catImage.contentMode = .scaleAspectFill
        catImage.layer.cornerRadius = 12
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("CatsCollectionViewCell - favoriteButtonPressed()")
        
        
        //sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cellDelegate?.favoriteButtonPressed(indexPath: sender.tag)
    
    }
}
