//
//  CollectionViewCell1.swift
//  Smooth scrolling
//
//  Created by pros on 5/16/22.
//

import UIKit

class CollectionViewCell1: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(model: Model1) {
        label.text = model.text
    }
}
