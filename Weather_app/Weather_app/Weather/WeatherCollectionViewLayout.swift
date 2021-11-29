//
//  WeatherCollectionViewLayout.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class WeatherCollectionViewLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnsCount = 2
        
    private var totalCellsHeight: CGFloat = 0

    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        let cellHeight: CGFloat = collectionView.bounds.width / CGFloat(columnsCount)

        guard itemsCount > 0 else { return }
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnsCount)
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let isBigCell = self.isBigCell(index: index,
                                           columnsCount: columnsCount)
            
            if isBigCell {
                attributes.frame = CGRect(x: 0,
                                          y: lastY,
                                          width: bigCellWidth,
                                          height: cellHeight)
                lastY += cellHeight
            } else {
                attributes.frame = CGRect(x: lastX,
                                          y: lastY,
                                          width: smallCellWidth,
                                          height: cellHeight)
                let isLastColumn = self.isBigCell(index: index + 1, columnsCount: columnsCount) || index == itemsCount - 1
                if isLastColumn {
                    lastX = 0
                    lastY += cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            cacheAttributes[indexPath] = attributes
        }
        self.totalCellsHeight = lastY
        
    }
    
    private func isBigCell(index: Int, columnsCount: Int) -> Bool {
        return (index + 1) % (columnsCount + 1) == 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0,
                      height: self.totalCellsHeight)
    }
    
}
