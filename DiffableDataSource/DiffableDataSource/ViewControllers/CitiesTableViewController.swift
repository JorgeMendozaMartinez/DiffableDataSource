//
//  CitiesTableViewController.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesTableViewController: UITableViewController {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cities"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Initial Data
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
        
        locationManager.delegate = self
        locationManager.updateLocation()
    }
    
    // MARK: - Properties
    let locationManager = LocationManager.default
    
    
    // MARK: - DataSource
    lazy var dataSource = UITableViewDiffableDataSource<Int, City>(tableView: self.tableView) { (tableView, indexPath, city) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.description.first?.description ?? ""
        return cell
    }
}

extension CitiesTableViewController: LocationManagerDelegate {
    func updatedLocation(coordinate: CLLocationCoordinate2D) {
        RestClient.default.requestCities(location: coordinate) { (result, err) in
            guard let result = result else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(result.cities, toSection: 0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
