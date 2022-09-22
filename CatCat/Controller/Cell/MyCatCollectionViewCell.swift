//
//  MyCatCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/21.
//

import UIKit

class MyCatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myCatImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        setUpImageView()
    }
    func setUpImageView() {
        myCatImage.contentMode = .scaleAspectFill
        myCatImage.layer.cornerRadius = 12
    }
}
