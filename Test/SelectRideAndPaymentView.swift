//
//  PaymentConfirmationCell.swift
//  Test
//
//  Created by Gnani on 28/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class SelectRideAndPaymentView: UIView, RideChangeDelegate {
    
    private var rideCategoryCollectionView: RideCategoryCollectionView!
    private var higherFareLabel: UILabel!
    private var seperatorLineView: UIView!
    private var paymentButton: UIButton!
    private var noOfRidersButton: UIButton!
    private var confirmButton: UIButton!
    
    private let RIDE_COLLECTION_VIEW_HEIGHT: CGFloat = 210.0
    
    private let HIGHER_FARE_LABEL_TOP: CGFloat = 40.0
    
    private let SEPERATOR_VIEW_TOP: CGFloat = 0.0
    private let SEPERATOR_VIEW_LEADING: CGFloat = 30.0
    private let SEPERATOR_VIEW_TRAILING: CGFloat = 30.0
    private let SEPERATOR_VIEW_HEIGHT: CGFloat = 1.0
    
    private let PAYMENT_BUTTOM_LEADING: CGFloat = 24.0
    private let PAYMENT_BUTTOM_WIDTH: CGFloat = 110.0
    private let PAYMENT_BUTTOM_HEIGHT: CGFloat = 24.0
    private let PAYMENT_BUTTOM_BOTTOM: CGFloat = 12.0
    
    private let NO_OF_RIDERS_BUTTOM_TRAILING: CGFloat = 24.0
    private let NO_OF_RIDERS_BUTTOM_WIDTH: CGFloat = 63.0
    private let NO_OF_RIDERS_BUTTOM_BOTTOM: CGFloat = 16.0
    
    private let CONFIRM_BUTTOM_LEADING: CGFloat = 24.0
    private let CONFIRM_BUTTOM_TRAILING: CGFloat = 20.0
    private let CONFIRM_BUTTOM_BOTTOM: CGFloat = 20.0
    private let CONFIRM_BUTTOM_HEIGHT: CGFloat = 44.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.backgroundColor = UIColor.white
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 7.5
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        self.rideCategoryCollectionView = RideCategoryCollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: RIDE_COLLECTION_VIEW_HEIGHT), collectionViewLayout: collectionViewLayout)
        self.rideCategoryCollectionView.rideChangeDelegate = self
        self.addSubview(self.rideCategoryCollectionView)
        
        self.higherFareLabel = UILabel()
        self.higherFareLabel.text = "Fares are slightly higher due to increase in demand"
        self.higherFareLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.higherFareLabel.textColor = UIColor.lightGray
        self.higherFareLabel.textAlignment = .center
        self.addSubview(self.higherFareLabel)
        
        self.seperatorLineView = UIView()
        self.seperatorLineView.backgroundColor = UIColor.lightGray
        self.addSubview(self.seperatorLineView)
        
        self.paymentButton = UIButton()
        self.paymentButton.setImage(UIImage(named: "card"), for: .normal)
        self.paymentButton.setTitle("**** 9347", for: .normal)
        self.paymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        self.paymentButton.setTitleColor(UIColor.black, for: .normal)
        self.paymentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        self.paymentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.addSubview(self.paymentButton)
        
        self.noOfRidersButton = UIButton()
        self.noOfRidersButton.setImage(UIImage(named: "people"), for: .normal)
        self.noOfRidersButton.setTitle(RideType.pool.noOfRiders, for: .normal)
        self.noOfRidersButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.noOfRidersButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        self.noOfRidersButton.isUserInteractionEnabled = false
        self.noOfRidersButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        self.noOfRidersButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.addSubview(self.noOfRidersButton)
        
        self.confirmButton = UIButton()
        self.confirmButton.setTitle(RideType.pool.buttonTitle, for: .normal)
        self.confirmButton.backgroundColor = UIColor.black
        self.confirmButton.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(self.confirmButton)
        
        self.addViewConstraints()
    }
    
    func rideChangedToType(type: RideType) {
        self.noOfRidersButton.setTitle(type.noOfRiders, for: .normal)
        self.confirmButton.setTitle(type.buttonTitle, for: .normal)
    }
    
    private func addViewConstraints() {
        
        self.higherFareLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let higherFareLabelTop = NSLayoutConstraint(item: self.higherFareLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: HIGHER_FARE_LABEL_TOP)
        self.addConstraint(higherFareLabelTop)
        
        let higherFareLabelCenterX = NSLayoutConstraint(item: self.higherFareLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraint(higherFareLabelCenterX)
        
        self.rideCategoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let rideCategoryCollectionViewTop = NSLayoutConstraint(item: self.rideCategoryCollectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        self.addConstraint(rideCategoryCollectionViewTop)

        let rideCategoryCollectionViewLeading = NSLayoutConstraint(item: self.rideCategoryCollectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        self.addConstraint(rideCategoryCollectionViewLeading)
        
        let rideCategoryCollectionViewTrailing = NSLayoutConstraint(item: self.rideCategoryCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        self.addConstraint(rideCategoryCollectionViewTrailing)
        
        let rideCategoryCollectionViewHeight = NSLayoutConstraint(item: self.rideCategoryCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: RIDE_COLLECTION_VIEW_HEIGHT)
        self.addConstraint(rideCategoryCollectionViewHeight)
        
        self.seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        let seperatorLineViewTop = NSLayoutConstraint(item: self.seperatorLineView, attribute: .top, relatedBy: .equal, toItem: self.rideCategoryCollectionView, attribute: .bottom, multiplier: 1.0, constant: SEPERATOR_VIEW_TOP)
        self.addConstraint(seperatorLineViewTop)
        
        let seperatorLineViewLeading = NSLayoutConstraint(item: self.seperatorLineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: SEPERATOR_VIEW_LEADING)
        self.addConstraint(seperatorLineViewLeading)
        
        let seperatorLineViewTrailing = NSLayoutConstraint(item: self.seperatorLineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -SEPERATOR_VIEW_TRAILING)
        self.addConstraint(seperatorLineViewTrailing)
        
        let seperatorLineViewHeight = NSLayoutConstraint(item: self.seperatorLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: SEPERATOR_VIEW_HEIGHT)
        self.seperatorLineView.addConstraint(seperatorLineViewHeight)
        
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let confirmButtonLeading = NSLayoutConstraint(item: self.confirmButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: CONFIRM_BUTTOM_LEADING)
        self.addConstraint(confirmButtonLeading)
        
        let confirmButtonTrailing = NSLayoutConstraint(item: self.confirmButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -CONFIRM_BUTTOM_TRAILING)
        self.addConstraint(confirmButtonTrailing)
        
        let confirmButtonBottom = NSLayoutConstraint(item: self.confirmButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -CONFIRM_BUTTOM_BOTTOM)
        self.addConstraint(confirmButtonBottom)
        
        let confirmButtonHeight = NSLayoutConstraint(item: self.confirmButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CONFIRM_BUTTOM_HEIGHT)
        self.confirmButton.addConstraint(confirmButtonHeight)
        
        self.paymentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let paymentButtonBottom = NSLayoutConstraint(item: self.paymentButton, attribute: .bottom, relatedBy: .equal, toItem: self.confirmButton, attribute: .top, multiplier: 1.0, constant: -PAYMENT_BUTTOM_BOTTOM)
        self.addConstraint(paymentButtonBottom)
        
        let paymentButtonLeading = NSLayoutConstraint(item: self.paymentButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: PAYMENT_BUTTOM_LEADING)
        self.addConstraint(paymentButtonLeading)
        
        let paymentButtonWidth = NSLayoutConstraint(item: self.paymentButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: PAYMENT_BUTTOM_WIDTH)
        self.paymentButton.addConstraint(paymentButtonWidth)
        
        let paymentButtonHeight = NSLayoutConstraint(item: self.paymentButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: PAYMENT_BUTTOM_HEIGHT)
        self.paymentButton.addConstraint(paymentButtonHeight)
        
        self.noOfRidersButton.translatesAutoresizingMaskIntoConstraints = false
        
        let noOfRidersButtonBottom = NSLayoutConstraint(item: self.noOfRidersButton, attribute: .bottom, relatedBy: .equal, toItem: self.confirmButton, attribute: .top, multiplier: 1.0, constant: -NO_OF_RIDERS_BUTTOM_BOTTOM)
        self.addConstraint(noOfRidersButtonBottom)
        
        let noOfRidersButtonTrailing = NSLayoutConstraint(item: self.noOfRidersButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -NO_OF_RIDERS_BUTTOM_TRAILING)
        self.addConstraint(noOfRidersButtonTrailing)
        
        let noOfRidersButtonWidth = NSLayoutConstraint(item: self.noOfRidersButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: NO_OF_RIDERS_BUTTOM_WIDTH)
        self.noOfRidersButton.addConstraint(noOfRidersButtonWidth)

    }
}
