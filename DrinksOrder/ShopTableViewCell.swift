//
//  ShopTableViewCell.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/27.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    var shops = [ShopField]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellSize()
        // Initialization code
    }

    func configureCellSize() {
        let itemSpace: Double = 4
        let columnCount: Double = 2
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount)
        flowLayout?.itemSize = CGSize(width: width, height: 130)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.minimumInteritemSpacing = itemSpace
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension ShopTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ShopCollectionViewCell.self)", for: indexPath) as! ShopCollectionViewCell
        let shop = shops[indexPath.item]
        cell.shopNameLabel.text = shop.shopName
        cell.phoneLabel.text = shop.phone
        cell.addressLabel.text = shop.address
        cell.phoneButton.tag = indexPath.item
        cell.mapButton.tag = indexPath.item
        return cell
    }
}
