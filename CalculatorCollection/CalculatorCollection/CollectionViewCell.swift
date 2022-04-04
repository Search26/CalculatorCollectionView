//
//  CollectionViewCell.swift
//  CalculatorCollection
//
//  Created by Ney on 05/06/2021.
//
protocol YourCellDelegate : ViewController {
    func didPressButton(_ sender : Button)
}
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var cellDelegate: YourCellDelegate?
    
    @IBAction func btnAction(_ sender: Button) {
        cellDelegate?.didPressButton(sender)
    }
    @IBOutlet weak var btn: Button!
}
