//
//  OutletDetailViewController.swift
//  30 NORTH
//
//  Created by vinay on 21/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OutletDetailViewController: UIViewController {

    
    //MARK:- Variable Declaration
    var hoursArray: [String]?
    var shop: Shop!
    var outlet: Outlet?

    var currentLocationCoordinate: CLLocationCoordinate2D?
    var finalHoursArray = [String]()

    //MARK:- Property
    @IBOutlet weak var hoursTableView: UITableView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var openUntil: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var milesButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!

	@IBOutlet weak var foodServesTitleLabel: UILabel! {
		didSet {
			foodServesTitleLabel.text = ""
			foodServesTitleLabel.font = UIFont(name: AppFontName.bold, size: 14)
			foodServesTitleLabel.textColor = UIColor.gold
			foodServesTitleLabel.textAlignment = .left
			foodServesTitleLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var featuresTitleLabel: UILabel!{
		didSet {
			featuresTitleLabel.text = ""
			featuresTitleLabel.font = UIFont(name: AppFontName.bold, size: 14)
			featuresTitleLabel.textColor = UIColor.gold
			featuresTitleLabel.textAlignment = .left
			featuresTitleLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var amenitiesTitleLabel: UILabel!{
		didSet {
			amenitiesTitleLabel.text = ""
			amenitiesTitleLabel.font = UIFont(name: AppFontName.bold, size: 14)
			amenitiesTitleLabel.textColor = UIColor.gold
			amenitiesTitleLabel.textAlignment = .left
			amenitiesTitleLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var foodServesLabel: UILabel!{
		   didSet {
			foodServesLabel.text = ""
			foodServesLabel.font = UIFont(name: AppFontName.regular, size: 14)
			foodServesLabel.textColor = .white
			foodServesLabel.textAlignment = .left
			foodServesLabel.clipsToBounds = true
			foodServesLabel.numberOfLines = 0
			foodServesLabel.adjustsFontSizeToFitWidth = true
			foodServesLabel.minimumScaleFactor = 0.5
		}
	}
    @IBOutlet weak var featuresLabel: UILabel!{
		didSet {
			featuresLabel.text = ""
			featuresLabel.font = UIFont(name: AppFontName.regular, size: 14)
			featuresLabel.textColor = UIColor.white
			featuresLabel.textAlignment = .left
			featuresLabel.clipsToBounds = true
			featuresLabel.numberOfLines = 0
			featuresLabel.adjustsFontSizeToFitWidth = true
			featuresLabel.minimumScaleFactor = 0.5
		}
	}
    @IBOutlet weak var amenitiesLabel: UILabel!{
		didSet {
			//This location serves:
			amenitiesLabel.text = ""
			amenitiesLabel.font = UIFont(name: AppFontName.regular, size: 14)
			amenitiesLabel.textColor = UIColor.white
			amenitiesLabel.textAlignment = .left
			amenitiesLabel.clipsToBounds = true
			amenitiesLabel.numberOfLines = 0
			amenitiesLabel.adjustsFontSizeToFitWidth = true
			amenitiesLabel.minimumScaleFactor = 0.5
		}
	}

    @IBOutlet weak var mapButton: UIButton! {
        didSet {
            mapButton.layer.cornerRadius = 3.0
            mapButton.backgroundColor = UIColor.gold
            mapButton.clipsToBounds = true
            mapButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
            mapButton.setTitle("Show on Map", for: .normal)
            mapButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBOutlet weak var directionsButton: UIButton! {
        didSet {
            directionsButton.layer.cornerRadius = 3.0
            directionsButton.backgroundColor = UIColor.gold
            directionsButton.clipsToBounds = true
            directionsButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
            directionsButton.setTitle("Directions", for: .normal)
            directionsButton.setTitleColor(UIColor.white, for: .normal)
        }
    }


	lazy var tableViewHeightConstraint:NSLayoutConstraint? = {
		let tableViewHeightConstraint = self.hoursTableView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "TableViewHeightConstraint"
		}
		return tableViewHeightConstraint
	}()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        //TableViewHeightConstraint
        updateValuesForView()
        updateNavigationStuff()
    }

	override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        //updateNavigationStuff()
        //self.perform(#selector(setRegionForMap), with: nil, afterDelay: 1)
        self.showCartButton()
    }
    @IBAction func onCall(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneLabel.text!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func directionsAction(_ sender: Any) {
        
        if(currentLocationCoordinate == nil){
            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.currentLocationNotFound, style: AlertStyle.customImag(imageFile: "Logo"))
            return
        }
        
        guard let outlet = self.outlet, let lat = outlet.lat, let long = outlet.lon else {
                       return
                   }
        let urlDestination = URL.init(string: "comgooglemaps://?saddr=\(String(describing: currentLocationCoordinate?.latitude ?? 0.0)),\(String(describing: currentLocationCoordinate?.longitude ?? 0.0))&daddr=\(lat),\(long)&directionsmode=driving")
        print("Opening Map with URL \(String(describing: urlDestination))")
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
          //UIApplication.shared.openURL(URL(string:
            guard let outlet = self.outlet, let lat = outlet.lat, let long = outlet.lon else {
                return
            }
            
            
            let latuser: Double = currentLocationCoordinate!.latitude
            let user_lat : String = String(format:"%f", latuser)
            let longuser: Double = currentLocationCoordinate!.longitude
            let user_long : String = String(format:"%f", longuser)
            
            
            if let urlDestination = URL.init(string: "comgooglemaps://?saddr=\(user_lat),\(user_long)&daddr=\(lat),\(long)&directionsmode=driving") {
                print("Opening Map with URL \(urlDestination)")
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        } else {
          print("Can't use comgooglemaps://");
                   let shopLatitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
                   let shopLongitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
                   //let shopLocation = CLLocation(latitude: shopLatitude , longitude: shopLongitude)
                   //let currentLocation = CLLocation(latitude: currentLocationCoordinate?.latitude ?? 0.0, longitude: currentLocationCoordinate?.longitude ?? 0.0)
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)))
            source.name = "Current Location"

            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:currentLocationCoordinate?.latitude ?? 0.0, longitude: currentLocationCoordinate?.longitude ?? 0.0)))
            destination.name = self.outlet?.name

            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }

    @IBAction func showOnMapAction(_ sender: Any) {
                
        let viewController = self.navigationController?.viewControllers.first(where: { (vc) -> Bool in
            return vc is OutletsViewController
        })
        if let outletVC = viewController  as? OutletsViewController {
            outletVC.mapButton.sendActions(for: .touchUpInside)
			//outletVC.showOutlet(outlet: self.outlet!)
            self.navigationController?.popToViewController(outletVC, animated: true)
        }
    }

    //Gets future date by adding days to current date
    func getFutureDay(addDays:Int)->Date{
           var dayComponent    = DateComponents()
           dayComponent.day    = addDays // For removing one day (yesterday): -1
           let theCalendar     = Calendar.current
        return theCalendar.date(byAdding: dayComponent, to: Date())!
    }
   
    //Gets Sunday, Monday etc. for a day.
    func getDayOfWeek(date:Date)->String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let stDay : String = formatter.string(from: date)

		if outlet?.open_days!.range(of:stDay) != nil {
           //print("exists")
            var openToStr = outlet?.open_to
                
            if(outlet?.open_to == "00:00") {
                openToStr = "Midnight"
            }
            let timingString : String = ": " + (outlet?.open_from)! + " - " + (openToStr)!
            return String(stDay + timingString)
        } else {
            let timingString : String = ": " + "- Closed"
            return String(stDay + timingString)
        }
    }

    func updateValuesForView() {
		guard let outlet = self.outlet else {

			shopNameLabel.text = shop.name
			addressLabel.text = shop.address
			phoneLabel.text = shop.phone

			if let amenities = shop.amenities, amenities != "" {
				amenitiesTitleLabel.text = "Amenities:"
				amenitiesLabel.text = amenities
			} else {
				amenitiesTitleLabel.text = nil
				amenitiesLabel.text = nil
			}

			foodServesLabel.text = ""
			foodServesTitleLabel.text = ""
			featuresLabel.text = ""
			featuresTitleLabel.text = ""
            return
		}
		shopNameLabel.text = outlet.name
		addressLabel.text = outlet.address
		phoneLabel.text = outlet.phone
		var name = ""
		if let amenities = outlet.amenities, amenities.count > 0 {
            for amenity in amenities {
				if let amenity_name = amenity["amenity_name"] {
					name += amenity_name
					name += ", "
				}
            }
			amenitiesTitleLabel.text = "Amenities:"
            amenitiesLabel.text = String(name.dropLast(2))
		} else {
			amenitiesTitleLabel.text = nil
			amenitiesLabel.text = nil
		}

		if let display_food = outlet.display_food {
			foodServesTitleLabel.text = "This Location Serves:"
            foodServesLabel.text = display_food
		} else {
			foodServesTitleLabel.text = nil
            foodServesLabel.text = nil
		}

		var features = ""
		if let display_pickup = outlet.display_pickup {
            features = display_pickup
		}
		if let display_seating = outlet.display_seating {
			if features.count > 0 {
				features.append(", ")
			}
			features.append(display_seating)
		}
		if features.count > 0 {
			featuresTitleLabel.text = "Features:"
			featuresLabel.text = features
		} else {
			featuresTitleLabel.text = nil
			featuresLabel.text = nil
		}

      //Let's get seven days starting from today.
        let arrOFDays : [String] = [getDayOfWeek(date: getFutureDay(addDays:0))! as String,getDayOfWeek(date: getFutureDay(addDays:1))! as String,getDayOfWeek(date: getFutureDay(addDays:2))! as String,getDayOfWeek(date: getFutureDay(addDays:3))! as String,getDayOfWeek(date: getFutureDay(addDays:4))! as String,getDayOfWeek(date: getFutureDay(addDays:5))! as String,getDayOfWeek(date: getFutureDay(addDays:6))! as String]

		hoursArray = arrOFDays
		dateAndTimeCalculation()
		distanceBetweenTwoCoordinates()
		hoursTableView.reloadData()
    }
    
    func distanceBetweenTwoCoordinates() {
        guard let outlet = self.outlet, let lat = outlet.lat, let long = outlet.lon else {
            return
        }

        let shopLatitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
        let shopLongitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
        
        let shopLocation = CLLocation(latitude: shopLatitude , longitude: shopLongitude)
        let currentLocation = CLLocation(latitude: currentLocationCoordinate?.latitude ?? 0.0, longitude: currentLocationCoordinate?.longitude ?? 0.0)
        
        let distance : Double = getDistance(location1: currentLocation, location2: shopLocation)
        let distanceInKM = String(format: "%.1f KM", (distance/1000))
        milesButton.setTitle(distanceInKM, for: .normal)
    }
    
    func dateAndTimeCalculation(){
       //print(Date().dayOfWeek()!)
        
        let currentDay = Date().dayOfWeek()!
        guard let hoursArr = hoursArray else { return }

        let currentHourArray = hoursArr.filter({ (day) -> Bool in
            if day.contains(currentDay){
                return true
            }
            return false
        })
       //print(currentHourArray)
		if outlet?.is_opening_soon == "1" {
			openUntil.text = "Opening Soon"
		} else {
			if currentHourArray.count > 0 {

				let currentDayTime = currentHourArray[0]
				let toTimeArray = currentDayTime.components(separatedBy: "- ")

				openUntil.text = "Open until \(toTimeArray[1])"
				print(toTimeArray)

				let dateFromat = DateFormatter()
				dateFromat.dateFormat = "HH:mm"
				let dateFrom : Date = dateFromat.date(from: (outlet?.open_from)!)! // In your case its string1
				print(dateFrom)
				var dateTo : Date = dateFromat.date(from: (outlet?.open_to)!)! // In your case its string1
                if(outlet?.open_to == "00:00"){
                    dateTo = dateFromat.date(from: "23:59")!
                }
				print(dateTo)
				let currentDateString : String = dateFromat.string(from: Date())
				let currentDate : Date = dateFromat.date(from: (currentDateString))!
				print(currentDate)

				if(currentDate.isBetween(dateFrom, and: dateTo) == true){
                    if(toTimeArray[1] == "00:00"){
                        openUntil.text = "Open until Midnight"

                    }else{
                        openUntil.text = "Open until \(toTimeArray[1])"

                    }
				}
				else{
					if let openTiming = outlet?.open_from {
						openUntil.text = "Opens at \(openTiming)"
					}
				}
				if(outlet!.is_open == 0) {
					openUntil.text = "Closed"
				}
			}
		}

        
        for i in 0..<hoursArr.count{
            let currentDayAndTime = hoursArr[i]
            let timeArray = currentDayAndTime.components(separatedBy: ": ")
            let day = timeArray[0].trim()
            if currentDay == day{
                finalHoursArray.append("Today:  \(timeArray[1])")
            }else{
                if finalHoursArray.count > 0 {
                    finalHoursArray.append(hoursArray![i])
                }
            }
        }
        
        var i = 0
        while (finalHoursArray.count != hoursArr.count) {
            finalHoursArray.append(hoursArr[i])
            i = i + 1
        }
       //print(finalHoursArray)
        
        // hack second index to yesterday
        let secondDateTime = finalHoursArray[1]
        let tomorrow = convertNextDate(date: Date())
        finalHoursArray[1] = secondDateTime.replacingOccurrences(of: tomorrow, with: "Tomorrow")
    }
    
    func convertNextDate(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let somedateString = dateFormatter.string(from: tomorrow!)
       //print("your next Date is \(somedateString)")
        return somedateString
    }

    private func updateNavigationStuff(){
        self.navigationController?.navigationBar.topItem?.title = ""
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func getDistance(location1 : CLLocation, location2 : CLLocation) -> Double {
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters
    }
}

extension OutletDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalHoursArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//Set Table Height
		if let heightConstraint = self.tableViewHeightConstraint {
			//heightConstraint.constant = CGFloat(30 * finalHoursArray.count)
			let screenBounds = UIScreen.main.bounds
			if screenBounds.height <= 667 { // small devices like SE
				heightConstraint.constant = 120
			} else if screenBounds.height <= 736 { // 8 Plus case
				heightConstraint.constant = 150
			} else if screenBounds.height <= 812 { // 11 pro case
				heightConstraint.constant = 180
			} else {
				heightConstraint.constant = 200
			}
		}
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HoursTableViewCell", for: indexPath) as! HoursTableViewCell
        
        let time = finalHoursArray[indexPath.row]
        let timeArray = time.components(separatedBy: ": ")
        
        if timeArray.count > 1 {
            let day = timeArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let timing = timeArray[1]
            
            cell.dayLabel.text = day
            cell.timeLabel.text = timing.replacingOccurrences(of: "- Closed", with: "Closed")
        }
        if indexPath.row == 0{
            cell.dayLabel.font = UIFont(name: "NexaBold", size: 14)
            cell.timeLabel.font = UIFont(name: "NexaBold", size: 14)
        }else{
            cell.dayLabel.font = UIFont(name: "NexaLight", size: 14)
            cell.timeLabel.font = UIFont(name: "NexaLight", size: 14)
        }
        return cell
    }
}

extension Date {
	func isBetween(_ date1: Date, and date2: Date) -> Bool {
		return (min(date1, date2) ... max(date1, date2)) ~= self
	}
}

