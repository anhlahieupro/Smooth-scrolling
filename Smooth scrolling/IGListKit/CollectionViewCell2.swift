//
//  CollectionViewCell2.swift
//  Smooth scrolling
//
//  Created by pros on 5/16/22.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(model: Model2) {
        label.text = model.title
    }
}
