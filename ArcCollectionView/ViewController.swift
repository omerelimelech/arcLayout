//
//  ViewController.swift
//  ArcCollectionView
//
//  Created by Omer Elimelech on 23/06/2020.
//  Copyright © 2020 Omer Elimelech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = ArcLayout(radius: view.frame.width / 2, center: view.center)
        setupCollectionView(withLayout: layout)
        
    }
    
    func setupCollectionView(withLayout layout: ArcLayout){
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CircleCollectionViewCell.reuseId, bundle: nil), forCellWithReuseIdentifier: CircleCollectionViewCell.reuseId)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getRandomNumber()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.reuseId, for: indexPath) as! CircleCollectionViewCell
        
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.titleLabel.text = "\(indexPath.item)"
        
        return cell
    }
    
    func getRandomNumber() -> Int{
        return Int.random(in: 0...200)
    }
    
}


