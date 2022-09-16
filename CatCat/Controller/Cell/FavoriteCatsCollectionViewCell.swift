//
//  FavoriteCatsCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import UIKit

class FavoriteCatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var catImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .black
        setUpImageView()
    }

    func setUpImageView() {
        catImage.contentMode = .scaleAspectFill
        catImage.layer.cornerRadius = 12
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("FavoriteCatsCollectionViewCell - favoriteButtonPressed()")
    }
}
