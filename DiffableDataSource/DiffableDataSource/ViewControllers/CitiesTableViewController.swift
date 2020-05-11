//
//  CitiesTableViewController.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

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
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(for: .valueChanged, using: { [unowned self] _ in
            if let coordinate = self.locationManager.localCoordinates {
               self.updatedLocation(coordinate: coordinate)
            }
        })
    }
    
    // MARK: - Properties
    let locationManager = LocationManager.default
    
    
    // MARK: - DataSource
    lazy var dataSource = UITableViewDiffableDataSource<Int, City>(tableView: self.tableView) { (tableView, indexPath, city) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = city.name
        if let weather = city.weather.first {
            cell.detailTextLabel?.text = weather.description
            cell.imageView?.sd_setImage(with: RestClient.default.url(path: "img/w/\(weather.icon).png"),
                                        placeholderImage: UIImage(systemName: "cloud.heavyrain.fill"))
        }
       
        return cell
    }
    
    //MARK: TableView Delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        navigationController?.pushViewController(CityViewController(city: city), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let city = self.dataSource.itemIdentifier(for: indexPath) else { return  nil }
        
        var actions = [UIContextualAction]()
        
        actions.append(UIContextualAction.init(style: .destructive, backgroundColor: .systemRed, image: UIImage(systemName: "trash"), title: "Delete", handler: { (action, _, completion) in
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([city])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completion(true)
        }))
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

extension CitiesTableViewController: LocationManagerDelegate {
    func updatedLocation(coordinate: CLLocationCoordinate2D) {
        RestClient.default.requestCities(location: coordinate) { (result, err) in
            guard let result = result else { return }
            var snapshot = self.dataSource.snapshot()
            
            snapshot.deleteAllItems()
            snapshot.appendSections([0])
            snapshot.appendItems(result.list, toSection: 0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.refreshControl?.endRefreshing()
        }
    }
}
