//
//  UploadCollectionViewCell.swift
//  CatCat
//
//  Created by Ekko on 2022/09/21.
//

import UIKit

class UploadCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var uploadLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        uploadLabel.textColor = .white
        self.backgroundColor = .black
    }
}
