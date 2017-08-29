//
//  RideCategoryCollectionViewCell.swift
//  Test
//
//  Created by Gnani on 28/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

protocol RideChangeDelegate {
    func rideChangedToType(type: RideType)
}

class RideCategoryCollectionViewCell: UICollectionViewCell {
    
    var delegate: RideChangeDelegate?
    
    var collectionView: UICollectionView?
    
    var rideCategory: RideCategory?
    var selectedRideIndex: Int?
    
    override var reuseIdentifier: String? {
        return "RideCategoryCollectionViewCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDataWithRideCategory(rideCategory: RideCategory) {
        
        self.rideCategory = rideCategory
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: collectionViewLayout)
        self.collectionView!.backgroundColor = UIColor.white
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.isScrollEnabled = false
        self.collectionView!.register(RideCollectionViewCell.self, forCellWithReuseIdentifier: "RideCollectionViewCell")
        self.addSubview(self.collectionView!)
    }
    
    func didSelectCurrentCell() {
        self.collectionView?.reloadData()
        if let selectedRideIndex = self.selectedRideIndex, let rideCategory = self.rideCategory, selectedRideIndex < rideCategory.rides.count , let delegate = self.delegate {
            delegate.rideChangedToType(type: rideCategory.rides[selectedRideIndex])
        }
    }
}

extension RideCategoryCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rideCategory = self.rideCategory {
            return rideCategory.rides.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rideCategory = self.rideCategory, indexPath.row < rideCategory.rides.count, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RideCollectionViewCell", for: indexPath) as? RideCollectionViewCell {
            if let selectedRideIndex = self.selectedRideIndex {
                if selectedRideIndex == indexPath.row {
                    cell.setDataWithRideType(rideType: rideCategory.rides[indexPath.row], andIsSelectedRide: true)
                } else {
                    cell.setDataWithRideType(rideType: rideCategory.rides[indexPath.row], andIsSelectedRide: false)
                }
            } else {
                selectedRideIndex = 0
                cell.setDataWithRideType(rideType: rideCategory.rides[indexPath.row], andIsSelectedRide: true)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRideIndex = indexPath.row
        self.didSelectCurrentCell()
    }
}

extension RideCategoryCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
        return CGSize(width: collectionView.bounds.size.width / CGFloat(numberOfItems), height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
