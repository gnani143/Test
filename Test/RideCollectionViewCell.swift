//
//  RideCollectionViewCell.swift
//  Test
//
//  Created by Gnani on 28/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class RideCollectionViewCell: UICollectionViewCell {
    
    private var rideImageView: UIImageView?
    private var titleLabel: UILabel?
    private var priceLabel: UILabel?
    
    private var rideImageViewWidthConstraint: NSLayoutConstraint?
    
    override var reuseIdentifier: String? {
        return "RideCollectionViewCell"
    }
    
    func setDataWithRideType(rideType: RideType, andIsSelectedRide isSelectedRide: Bool) {
        
        if self.rideImageView == nil, self.titleLabel == nil, self.priceLabel == nil {
            self.rideImageView = UIImageView()
            self.contentView.addSubview(self.rideImageView!)
            
            self.titleLabel = UILabel()
            self.contentView.addSubview(self.titleLabel!)
            
            self.priceLabel = UILabel()
            self.priceLabel!.textColor = UIColor.darkGray
            self.priceLabel!.font = UIFont.systemFont(ofSize: 13.0)
            self.contentView.addSubview(self.priceLabel!)
            
            self.addViewConstraints()
        }
        
        var rideImageName = "cab_disable"
        var rideImageViewWidth: CGFloat = 60.0
        if isSelectedRide {
            rideImageName = "cab"
            rideImageViewWidth = 65.0
        }
        
        if let rideImageViewWidthConstraint = self.rideImageViewWidthConstraint {
            rideImageViewWidthConstraint.constant = rideImageViewWidth
        }
        
        self.rideImageView!.image = UIImage(named: rideImageName)
        self.titleLabel!.text = rideType.title
        self.priceLabel!.text = rideType.price
    }
    
    private func addViewConstraints() {
        
        self.rideImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        let rideImageViewTop = NSLayoutConstraint(item: self.rideImageView!, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 20.0)
        self.contentView.addConstraint(rideImageViewTop)
        
        let rideImageViewCenterX = NSLayoutConstraint(item: self.rideImageView!, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(rideImageViewCenterX)
        
        self.rideImageViewWidthConstraint = NSLayoutConstraint(item: self.rideImageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0)
        self.rideImageView!.addConstraint(self.rideImageViewWidthConstraint!)
        
        let rideImageViewRatio = NSLayoutConstraint(item: self.rideImageView!, attribute: .width, relatedBy: .equal, toItem: self.rideImageView!, attribute: .height, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(rideImageViewRatio)
        
        self.priceLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        let priceLabelBottom = NSLayoutConstraint(item: self.priceLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        self.contentView.addConstraint(priceLabelBottom)
        
        let priceLabelCenterX = NSLayoutConstraint(item: self.priceLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(priceLabelCenterX)
        
        self.titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelBottom = NSLayoutConstraint(item: self.titleLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.priceLabel, attribute: .top, multiplier: 1.0, constant: -4.0)
        self.contentView.addConstraint(titleLabelBottom)
        
        let titleLabelCenterX = NSLayoutConstraint(item: self.titleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.contentView.addConstraint(titleLabelCenterX)
    }
}
