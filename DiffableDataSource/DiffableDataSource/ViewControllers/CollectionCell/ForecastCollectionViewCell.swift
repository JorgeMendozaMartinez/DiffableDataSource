//
//  ForcastCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastCollectionViewCell: UICollectionViewCell {
    static let nibName = "ForecastCollectionViewCell"
    
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var tempetureLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var forecast: Forecast? {
        didSet {
            if let forecast = forecast {
                conditionLabel.text = forecast.weather.first?.description ?? ""
                windSpeedLabel.text = "\(forecast.wind.speed) mph"
                tempetureLabel.text = forecast.kelvinToCelsiusDegreeString(forecast.main.temp)
                dateLabel.text = forecast.date
                if let weather = forecast.weather.first {
                    imageView.sd_setImage(with: RestClient.default.url(path: "img/w/\(weather.icon).png"),
                                          placeholderImage: UIImage(systemName: "cloud.heavyrain.fill"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           forecast = nil
    }
}
