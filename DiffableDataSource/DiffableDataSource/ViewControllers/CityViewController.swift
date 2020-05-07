//
//  CityViewController.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
   
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
        
        self.title = city.name
        
    }
    
    // MARK: ViewState
    override func viewDidLoad() {
        collectionView.frame = self.view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        RestClient.default.requestCityForecasts(city) { (daily, err) in
            guard let result = daily?.forcastList else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(result, toSection: 0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: - Properties
    private var city: City
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collection.register(UINib(nibName: ForecastCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: "ForecastCell")
        return collection
    }()
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: DataSource
    lazy var dataSource = UICollectionViewDiffableDataSource<Int, Forecast>(collectionView: self.collectionView) { (collectionView, indexPath, forecast) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as? ForecastCollectionViewCell else { return nil }
        
        cell.forecast = forecast
        return cell 
    }
}



