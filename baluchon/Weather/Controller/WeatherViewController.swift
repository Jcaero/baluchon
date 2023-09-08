//
//  WeatherViewController.swift
//  baluchon
//
//  Created by pierrick viret on 02/09/2023.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    // MARK: - Properties

    let maps = MKMapView()
    let inputCity = UITextField()
    let searchCity = UIButton()

    // MARK: - WeatherValue
    let stackViewWeather = UIStackView()

    let nameAera = UIView()
    let cityName = UILabel()
    let countryName = UILabel()

    let weatherIcon = UIImageView()

    let temperatureLbl = UILabel()

    var weatherCollectionView: UICollectionView!
    var weatherCollectionViewData: [CellData] = [CellData(hour: "09", iconName: "01d")]

    // MARK: - init
    var page: Pages
    var initCity: City!

    init(with page: Pages) {
        self.page = page
        initCity = page.city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputCity.delegate = self
        view.backgroundColor = .white

        setupMaps()
        setupMapsLayout()

        if page.city.name != "New York" {
            setupCityLayout()
            setupCity()
        }
        setupWeatherCollectionView()
        setupWeatherCollectionViewLayout()

        setupWeatherInformation()
        setupWeatherInformationLayout()

        setupGestureRecogniser()

        updateWeather(with: initCity.coord)
    }

    // MARK: - Setup Maps
    private func setupMaps() {
        maps.mapType = .hybrid
        maps.isUserInteractionEnabled = false

        let initialLocation = CLLocation(latitude: initCity.coord.lat, longitude: initCity.coord.lon)
        maps.centerToLocation(initialLocation)
    }

    private func setupMapsLayout() {
        maps.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maps)
        NSLayoutConstraint.activate([
            maps.topAnchor.constraint(equalTo: view.topAnchor),
            maps.leftAnchor.constraint(equalTo: view.leftAnchor),
            maps.rightAnchor.constraint(equalTo: view.rightAnchor),
            maps.heightAnchor.constraint(equalToConstant: view.frame.height/4.2)
        ])
    }

    // MARK: - Weather information
    private func setupWeatherInformation() {
        nameAera.backgroundColor = .white

        setupStackView(stackViewWeather, axis: .vertical)
        stackViewWeather.distribution = .fillProportionally

        cityName.setup(with: .darkGray, alignment: .center, font: UIFont.boldSystemFont(ofSize: 50))
        cityName.text = initCity.name
        cityName.accessibilityIdentifier = "cityName"

        countryName.setup(with: .darkGray, alignment: .center, font: UIFont.systemFont(ofSize: 20))
        countryName.text = initCity.country

        weatherIcon.image = UIImage(named: "01")

        temperatureLbl.setup(with: .darkGray, alignment: .center, font: UIFont.boldSystemFont(ofSize: 45))
        temperatureLbl.text = prepareTemperatureText(with: 11.0)
    }

    private func setupWeatherInformationLayout() {
        [nameAera, cityName, countryName, temperatureLbl, weatherIcon, stackViewWeather].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        weatherIcon.heightAnchor.constraint(equalTo: weatherIcon.widthAnchor).isActive = true

        nameAera.addSubview(cityName)
        nameAera.addSubview(countryName)
        NSLayoutConstraint.activate([
            nameAera.heightAnchor.constraint(equalToConstant: 100),
            cityName.centerXAnchor.constraint(equalTo: nameAera.centerXAnchor),
            countryName.centerXAnchor.constraint(equalTo: nameAera.centerXAnchor),
            countryName.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 5)
        ])

        stackViewWeather.addArrangedSubview(nameAera)
        stackViewWeather.addArrangedSubview(weatherIcon)
        stackViewWeather.addArrangedSubview(temperatureLbl)

        view.addSubview(stackViewWeather)
        NSLayoutConstraint.activate([
            stackViewWeather.topAnchor.constraint(equalTo: maps.bottomAnchor, constant: 55),
            stackViewWeather.bottomAnchor.constraint(equalTo: weatherCollectionView.topAnchor, constant: -10),
            stackViewWeather.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - CitySearch
    private func setupCityLayout() {
        [inputCity, searchCity].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(searchCity)
        NSLayoutConstraint.activate([
            searchCity.topAnchor.constraint(equalTo: maps.bottomAnchor, constant: 20),
            searchCity.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchCity.heightAnchor.constraint(equalToConstant: 30),
            searchCity.widthAnchor.constraint(equalTo: searchCity.heightAnchor)
        ])

        view.addSubview(inputCity)
        NSLayoutConstraint.activate([
            inputCity.topAnchor.constraint(equalTo: searchCity.topAnchor),
            inputCity.bottomAnchor.constraint(equalTo: searchCity.bottomAnchor),
            inputCity.rightAnchor.constraint(equalTo: searchCity.leftAnchor, constant: -5),
            inputCity.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }

    private func setupCity() {
        inputCity.borderStyle = .roundedRect
        inputCity.layer.cornerRadius = 10
        inputCity.tintColor = .lightGray
        inputCity.placeholder = "Entrez une ville"
        inputCity.isUserInteractionEnabled = true
        inputCity.accessibilityIdentifier = "inputTextField"

        searchCity.backgroundColor = .lightGray
        searchCity.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchCity.tintColor = .white
        searchCity.layer.cornerRadius = 10
        searchCity.addTarget(self, action: #selector(tappedSearchCity), for: .touchUpInside)
    }

    // MARK: - Search button
    @objc func tappedSearchCity() {
        dismissKeyboard()
        guard inputCity.text?.isEmpty == false else {return}

        guard let city = inputCity.text, city.lowercased() != "new york" else {
            self.showSimpleAlerte(with: "Erreur", message: "Ville déjà existante")
            return
        }
        self.inputCity.text = ""
        let repository = GeocodingRepository()

        repository.getCoordinate(of: city) { result in
            switch result {
            case .success(let response):
                guard let city = response.first else { return }
                self.cityName.text = city.local_names?["fr"] ?? city.name
                self.countryName.text = city.country

                let initialLocation = CLLocation(latitude: city.lat, longitude: city.lon)
                self.maps.centerToLocation(initialLocation)

                self.updateWeather(with: Coord(lat: city.lat, lon: city.lon))
            case .failure(let error):
                self.showSimpleAlerte(with: error.title, message: error.description)
            }
        }
    }

    @objc func dismissKeyboard() {
        inputCity.resignFirstResponder()
    }

    private func setupGestureRecogniser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedSearchCity))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }

    // MARK: - Temperature
    private func prepareTemperatureText(with temperature: Double) -> String {
        let text = "\(Int(temperature)) °C"
        return text
    }

    // MARK: - getWeather
    private func updateWeather(with coord: Coord) {
        let repository = WeatherRepository()

        repository.getWheather(of: coord) { response in
            switch response {
            case .success(let weather):
                let icon = weather.list[0].weather[0].icon
                let nameIcon = self.formatImageIconName(with: icon)
                self.weatherIcon.image = UIImage(named: nameIcon)

                let temperature = weather.list[0].main.temp
                self.temperatureLbl.text = self.prepareTemperatureText(with: temperature)

                self.fillWeatherCollectionView(with: weather)

            case .failure(let error):
                self.showSimpleAlerte(with: error.title, message: error.description)
            }
        }
    }

    // return imageName of icon
    private func formatImageIconName( with name: String) -> String {
        let icon = String(name.prefix(2))
        switch icon {
        case "03", "50", "09", "04":
            return icon
        default:
            return name
        }
    }
}

// MARK: - Extension MapView
extension MKMapView {
    func centerToLocation (_ localisation: CLLocation, regionRadius: CLLocationDistance = 10000) {
        let coordinateRegion = MKCoordinateRegion(
            center: localisation.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        }
    }
// MARK: - Extension TextField
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputCity.resignFirstResponder()
        tappedSearchCity()
        return true
    }
}

// MARK: - Extension CollectionView
extension WeatherViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func setupWeatherCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        weatherCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self

        weatherCollectionView.backgroundColor = .white

        weatherCollectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
    }

    private func setupWeatherCollectionViewLayout() {
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherCollectionView)
        NSLayoutConstraint.activate([
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 50),
            weatherCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            weatherCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherCollectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            cell.data = self.weatherCollectionViewData[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }

    private func fillWeatherCollectionView(with weather: API.JSONDataType.WeatherResponse) {
        weatherCollectionViewData = []
        weather.list.forEach { data in
            let icon = formatImageIconName(with: data.weather[0].icon)

            let index12 = data.dt_txt.index(data.dt_txt.startIndex, offsetBy: 11)
            let index13 = data.dt_txt.index(data.dt_txt.startIndex, offsetBy: 12)
            let hour = String(data.dt_txt[index12...index13])

            weatherCollectionViewData.append(CellData(hour: hour, iconName: icon))
        }
        weatherCollectionView.reloadData()
    }
}
