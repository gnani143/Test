//
//  RideCategoryCollectionView.swift
//  Test
//
//  Created by Gnani on 28/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class RideCategoryCollectionView: UICollectionView, RideChangeDelegate {
    
    let NUMBER_OF_PAGES = 2
    
    var rideChangeDelegate: RideChangeDelegate?
    
    private var currentPageNumber = 0
    private var secondaryLabelOriginX: CGFloat?
    
    private var headerLabelsArray = [UILabel]()
    
    private var lastContentOffsetX: CGFloat = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.white
        self.dataSource = self
        self.delegate = self
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.register(RideCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "RideCategoryCollectionViewCell")
        
        self.addHeaderLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addHeaderLabels() {
        let economyLabel = UILabel(frame: CGRect(x: (self.frame.width-120)/2, y: 12, width: 120, height: 20))
        economyLabel.text = "Economy"
        economyLabel.textAlignment = .center
        self.addSubview(economyLabel)
        headerLabelsArray.append(economyLabel)
        
        let premiumLabel = UILabel(frame: CGRect(x: self.frame.width-60, y: 12, width: 120, height: 20))
        premiumLabel.text = "Premium"
        premiumLabel.textAlignment = .center
        premiumLabel.alpha = 0.5
        premiumLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.addSubview(premiumLabel)
        headerLabelsArray.append(premiumLabel)
    }
    
    func rideChangedToType(type: RideType) {
        if let delegate = self.rideChangeDelegate {
            delegate.rideChangedToType(type: type)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if currentPageNumber != pageNumber {
            if let cell = self.cellForItem(at: IndexPath(item: pageNumber, section: 0)) as? RideCategoryCollectionViewCell {
                cell.didSelectCurrentCell()
            }
        }
        currentPageNumber = pageNumber
        self.secondaryLabelOriginX = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollDirectionAnchor = scrollView.panGestureRecognizer.translation(in: scrollView.superview).x
        
        var primaryLabel = UILabel()
        var secondaryLabel = UILabel()
        var secondaryLabelOffsetX: CGFloat
        let pageNumberToScroll = Int((scrollView.contentOffset.x-1)/scrollView.frame.width)
        
        if scrollDirectionAnchor < 0 {
            
            secondaryLabelOffsetX = (scrollView.contentOffset.x - (scrollView.frame.width*CGFloat(pageNumberToScroll)))/2
            
            if currentPageNumber + 1 < headerLabelsArray.count && currentPageNumber >= 0 {
                secondaryLabel = headerLabelsArray[currentPageNumber+1]
            }
            
        } else {

            secondaryLabelOffsetX = (scrollView.contentOffset.x - (scrollView.frame.width*CGFloat(pageNumberToScroll+1)))/2
            
            if currentPageNumber - 1 < headerLabelsArray.count && currentPageNumber > 0 {
                secondaryLabel = headerLabelsArray[currentPageNumber-1]
            }
        }
        
        if let secondaryLabelOriginX = self.secondaryLabelOriginX {
            let secondaryLabelNewOrigin = CGPoint(x: secondaryLabelOriginX + secondaryLabelOffsetX, y: secondaryLabel.frame.origin.y)
            secondaryLabel.frame.origin = secondaryLabelNewOrigin

        } else {
            self.secondaryLabelOriginX = secondaryLabel.frame.origin.x
        }
        
        
        if currentPageNumber < headerLabelsArray.count {
            primaryLabel = headerLabelsArray[currentPageNumber]
            let currentLabelNewOrigin = CGPoint(x: primaryLabel.frame.origin.x + (scrollView.contentOffset.x/2) - (lastContentOffsetX/2), y: primaryLabel.frame.origin.y)
            primaryLabel.frame.origin = currentLabelNewOrigin
        }
        lastContentOffsetX = scrollView.contentOffset.x
        
        var primaryLabelAlpha: CGFloat
        var secondaryLabelAlpha: CGFloat
        
        if secondaryLabelOffsetX < 0 {
            primaryLabelAlpha = 1.0+(secondaryLabelOffsetX/(scrollView.frame.width))
            secondaryLabelAlpha = 0.5-(secondaryLabelOffsetX/(scrollView.frame.width))
        } else {
            
            primaryLabelAlpha = 1.0-(secondaryLabelOffsetX/(scrollView.frame.width))
            secondaryLabelAlpha = 0.5+(secondaryLabelOffsetX/(scrollView.frame.width))
        }
        
        primaryLabel.alpha = primaryLabelAlpha
        secondaryLabel.alpha = secondaryLabelAlpha
        
        let primaryLabelFontSize: CGFloat = 15.0 + ((primaryLabelAlpha-0.5)*4)
        let secondaryLabeFontSize: CGFloat = 15.0 + ((secondaryLabelAlpha-0.5)*4)
        
        primaryLabel.font = UIFont.systemFont(ofSize: primaryLabelFontSize)
        secondaryLabel.font = UIFont.systemFont(ofSize: secondaryLabeFontSize)
    }

}

extension RideCategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_PAGES
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RideCategoryCollectionViewCell", for: indexPath) as? RideCategoryCollectionViewCell {
            cell.delegate = self
            if indexPath.row == 0 {
                cell.setDataWithRideCategory(rideCategory: .economy)
                
            } else if indexPath.row == 1 {
                cell.setDataWithRideCategory(rideCategory: .premium)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RideCategoryCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - 63.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 63, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
