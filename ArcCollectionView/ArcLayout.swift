//
//  ArcLayout.swift
//  ArcCollectionView
//
//  Created by Omer Elimelech on 23/06/2020.
//  Copyright © 2020 Omer Elimelech. All rights reserved.
//

import UIKit


class ArcLayout: UICollectionViewFlowLayout {
    
    var radius: CGFloat!
    var center: CGPoint!
    var perimeter: CGFloat?
    var pi: CGFloat = CGFloat(Double.pi)
    
    let visibleCircles: CGFloat = 10
    var angleForCircle: CGFloat {
        return pi / visibleCircles
    }
    
    init(radius: CGFloat, center: CGPoint){
        super.init()
        self.radius = radius
        self.center = center
        self.perimeter = 2*pi*radius // perimeter calculation formula
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
           return true
    }
    
    var attributesList = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {return}
        attributesList = (0..<collectionView.numberOfItems(inSection: 0)).map { (i)
              -> UICollectionViewLayoutAttributes in
                
            let att = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            att.size = itemSize
               
            if let x = findX(byLocation: CGFloat(i)),
               let y = findY(byLocation: CGFloat(i)) {
                let point = CGPoint(x: center.x + x, y: center.y + y)
                att.center = point
            }else{
                
                // hiding the attribue will prevent from the collectionview to draw the cell.
                att.alpha = 0
            }
            return att
          }
        
        
    }
   
    var was = [CGPoint]()
    func findX(byLocation location: CGFloat) -> CGFloat?{
        // in order to find X position we need to find the point on the perimeter we are curretly "focusing" on , relative to the horizontal position of the scroll view.
        guard let perimeter = perimeter else { fatalError("Cant calculate location without perimeter") }
        
        let offset = (collectionView?.contentOffset.x ?? 0)
        let relativeLocationOnPerimeter = offset / perimeter
    
        // in order to calculate the X point we need the angle.
        let angle = pi*relativeLocationOnPerimeter
        
        if !shouldCalculate(location: location, angle: angle){
            return nil
        }
        // we are adding pi to the angleCos in order to relate the angle to + 180
        let angleCos = cos(location * angleForCircle - angle + pi)
        
        //according to the formula of x = r * cos(angle)
        var xPoint = radius * angleCos
        
        // adding the offset to the x point
        xPoint += offset
        
        return xPoint
     }
     
    func findY(byLocation location: CGFloat) -> CGFloat?{
        guard let perimeter = perimeter else { fatalError("Cant calculate location without perimeter") }
        
        let offset = (collectionView?.contentOffset.x ?? 0)
        let relativeLocationOnPerimeter = offset / perimeter
              
          // in order to calculate the X point we need the angle.
        let angle = pi*relativeLocationOnPerimeter
          
        if !shouldCalculate(location: location, angle: angle){
            return nil
        }
          // we are adding pi to the angleSin in order to relate the angle to + 180
        let angleSin = sin(location * angleForCircle - angle + pi)
          
        //according to the formula of x = r * sin(angle)
        let yPoint = radius * angleSin
        return yPoint

     }
    
    // checking if the layout should show the attribute accoring to its location on the circle
    func shouldCalculate(location: CGFloat, angle: CGFloat) -> Bool{
        
        let attributeLocation = location*angleForCircle - angle
        // checking if the location is not below a single angle, and not passing half of the circle (pi)
        return (attributeLocation >= -angleForCircle/2 && attributeLocation <=  pi)
                 
    }
    
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {return .zero}
        let numOfCells: CGFloat = CGFloat(collectionView.numberOfItems(inSection: 0))
        
        let nonVisibleCellsCount = numOfCells > visibleCircles ? numOfCells - visibleCircles : numOfCells
   
        
        let allAngles = (nonVisibleCellsCount + 1)*angleForCircle
        let allAnglesOnCircle = allAngles*radius*2
        let height = CGFloat(radius);
        return CGSize(width: allAnglesOnCircle + (self.collectionView?.bounds.size.width ?? 0),height: height * 2);
    }
    
     override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes]? = []
        for i in 0..<(collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let indexPath = IndexPath(row: i, section: 0)
            let cellAttributes = self.layoutAttributesForItem(at: indexPath)
            if rect.intersects((cellAttributes?.frame ?? CGRect.zero)) && cellAttributes?.alpha != 0 {
                if let layout = layoutAttributesForItem(at: indexPath) {
                      attributes?.append(layout)
                }
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return attributesList[indexPath.row]
    }
    
    
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
