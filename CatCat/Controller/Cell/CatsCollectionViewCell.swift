//
//  CatsCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import UIKit

protocol PostFavoriteCatDelegate: AnyObject {
    func favoriteButtonPressed()
}

class CatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imformationLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var cellDelegate: PostFavoriteCatDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        
        setUpImageView()
    }
    
    func setUpImageView() {
        catImage.contentMode = .scaleAspectFill
        catImage.layer.cornerRadius = 12
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("CatsCollectionViewCell - favoriteButtonPressed()")
        cellDelegate?.favoriteButtonPressed()
    
    }
}