//
//  OutletsViewController.swift
//  30 NORTH
//
//  Created by vinay on 21/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import GoogleMaps

class OutletsViewController: UIViewController {

    //MARK:- Variable Declaration
    var shop: Shop?
    let locationManager = CLLocationManager()
    var currentLocationCoordinate: CLLocationCoordinate2D? = nil
    var didFindMyLocation:Bool = false
    let buttonColor = UIColor(displayP3Red: 0.176, green: 0.192, blue: 0.235, alpha: 1)
    var allOutlets : [Outlet]?
    var selectedOutletCoordinates: CLLocationCoordinate2D? = nil
    var bounds = GMSCoordinateBounds()



    //MARK:- Property
	@IBOutlet weak var topView: UIView! {
		didSet {
			topView.backgroundColor = self.buttonColor
		}
	}

	@IBOutlet weak var listButton: UIButton! {
		didSet {
			listButton.layer.borderColor = UIColor.black.cgColor
			listButton.layer.borderWidth = 1.0
			listButton.layer.cornerRadius = 3.0
			listButton.clipsToBounds = true
		}
	}

	@IBOutlet weak var mapButton: UIButton! {
		didSet {
			mapButton.layer.borderColor = UIColor.black.cgColor
			mapButton.layer.borderWidth = 1.0
			mapButton.layer.cornerRadius = 3.0
			mapButton.clipsToBounds = true
            self.addAnnotations()

		}
	}

	@IBOutlet weak var storeTableView: UITableView! {
		didSet {
			storeTableView.delegate = self
			storeTableView.dataSource = self
			storeTableView.separatorStyle = .none

			storeTableView.estimatedRowHeight = 40
			storeTableView.backgroundColor = .clear
		}
	}

//	@IBOutlet weak var mapView: MKMapView! {
//		didSet {
//			mapView.delegate = self
//			mapView.mapType = .standard
//		}
//	}
    
    @IBOutlet weak var outletMapView: GMSMapView! {
        didSet {
            outletMapView.mapType = .normal
            outletMapView.delegate = self
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {

            if let myLocation: CLLocation = change?[.newKey] as? CLLocation {
                self.outletMapView.settings.myLocationButton = true
                self.cameraMoveToLocation(toLocation: myLocation.coordinate)
            }
            didFindMyLocation = true
        }
    }


    

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        
        DispatchQueue.main.async {
            self.outletMapView.isMyLocationEnabled = true
            self.outletMapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        }


        configUI()
        getCurrentLocation()
        getRequestAPICall()
    }

    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        if(self.selectedOutletCoordinates != nil){
        self.cameraMoveToLocation(toLocation: self.selectedOutletCoordinates)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        //updateNavigationStuff()
        //self.perform(#selector(setRegionForMap), with: nil, afterDelay: 1)
		self.showCartButton()
    }

    private func configUI() {
		self.listButton.sendActions(for: .touchUpInside)
    }

	@IBAction func listButtonAction(_ sender: UIButton) {
		sender.backgroundColor = .black
		mapButton.backgroundColor = self.buttonColor

		sender.isEnabled = false
		storeTableView.isHidden = false

		self.mapButton.isEnabled = true
        self.outletMapView.isHidden = true
	}

	@IBAction func mapButtonAction(_ sender: UIButton) {
		sender.backgroundColor = .black
		listButton.backgroundColor = self.buttonColor

		sender.isEnabled = false
        self.outletMapView.isHidden = false

		self.listButton.isEnabled = true
		storeTableView.isHidden = true
        
       
        
	}

    /*
	func showOutlet(outlet:Outlet) {
		var zoomRect = MKMapRect.null

		guard let lat = outlet.lat, let latitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!) else {
			return
		}
		guard let long = outlet.lon, let longitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!) else {
			return
		}
		let location = CLLocation(latitude: latitude, longitude: longitude)
		let annotation = self.outletMapView.annotations.first { (annotation) -> Bool in
			return annotation.coordinate.latitude == location.coordinate.latitude && annotation.coordinate.longitude == location.coordinate.longitude
		}
		if let aAnnotation = annotation {
			let annotationPoint = MKMapPoint(aAnnotation.coordinate)
			let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
			if (zoomRect.isNull) {
				zoomRect = pointRect
			} else {
				zoomRect = zoomRect.union(pointRect)
			}
			self.outletMapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
		}

	}
 */

    @objc func setRegionForMap(){
        if let locationCoordinate = currentLocationCoordinate {
            /*
			let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
            let region = MKCoordinateRegion(center: locationCoordinate, span: span)
            //mapView.setRegion(region, animated: true)
            self.outletMapView.setRegion(region, animated: true)
 */
            self.cameraMoveToLocation(toLocation: locationCoordinate)

        }
    }
    
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            //self.outletMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 4)
            self.outletMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 10)

        }
    }


    private func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.Outlets
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK:- GET OUTLET  API CALL
    func getRequestAPICall()  {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.GetOutlets).responseCollection {
            (response: DataResponse<[Outlet]>) in
            DispatchQueue.main.async {
                _ = EZLoadingActivity.hide()
            if response.result.isSuccess {
                if let outlets: [Outlet] = response.result.value {
                    self.allOutlets = outlets
                    //self.shop = shops.first
                    self.addAnnotations()
                    self.storeTableView.reloadData()
                    } else {
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
                }
            }
        }
    }
}

extension OutletsViewController: CLLocationManagerDelegate,MKMapViewDelegate{
    
    
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.outletMapView.isMyLocationEnabled = true
        }
    }


    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCoordinate = manager.location!.coordinate
        
        //We are not showing current location
        //self.cameraMoveToLocation(toLocation: currentLocationCoordinate)
        //Finally stop updating location otherwise it will come again and again in this delegate
        
        if(self.currentLocationCoordinate != nil){
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        guard let shopTitle = view.annotation?.title, let outlets = self.outlets() else {
			return
		}
		let aOutlet = outlets.first { (outlet) -> Bool in
			return shopTitle == outlet.name
		}
		guard let outlet = aOutlet else {
			return
		}
        pushToOutletDetail(outlet: outlet)
    }

    func pushToOutletDetail(outlet: Outlet){
        
        
        
        
                guard let lat = outlet.lat else{
                      //print("Error lat")
                      return
                  }
                  guard let long = outlet.lon else{
                      //print("Error long")
                      return
                  }
               
                  let latitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
                  let longitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
                  
                  //let annotation = MKPointAnnotation()
                 self.selectedOutletCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let outletDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "OutletDetailViewController") as! OutletDetailViewController
        outletDetailViewController.shop = shop
		outletDetailViewController.outlet = outlet
        outletDetailViewController.currentLocationCoordinate = currentLocationCoordinate
        self.navigationController?.pushViewController(outletDetailViewController, animated: true)
    }
 
   
    
    func addAnnotations(){
		guard let outlets = self.outlets() else {
            return
        }
        

        bounds = GMSCoordinateBounds()
        
        for outlet in outlets {
            
            guard let lat = outlet.lat else{
				//print("Error lat")
				return
			}
            guard let long = outlet.lon else{
				//print("Error long")
				return
			}
            guard let name = outlet.name else {
				//print("Error name")
				return
			}
            
            let latitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
            let longitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
            
            //let annotation = MKPointAnnotation()
            let locValue = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            //let annotation = MKPointAnnotation()
            //annotation.coordinate = locValue
            //annotation.title = shopName
            //annotation.subtitle = "current location"
            //outletMapView.addAnnotation(annotation)

            let marker = GMSMarker()
            marker.position = locValue
            marker.title = name
            marker.map = self.outletMapView
            bounds = bounds.includingCoordinate(marker.position)


//            let locValue = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            annotation.coordinate = locValue
//            annotation.title = name
//            mapView.addAnnotation(annotation)
        }
       // mapView.reloadInputViews()
     // self.outletMapView.reloadInputViews()
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
                  let update = GMSCameraUpdate.fit(self.bounds, withPadding: 50)
                  self.outletMapView.animate(with: update)
              })
                       
       
    }
    
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
//        mapView.delegate = self
//        mapView.mapType = .standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//		mapView.showsUserLocation = true
//
//        if let coor = mapView.userLocation.location?.coordinate{
//            mapView.setCenter(coor, animated: true)
//        }
        
        if let coor = self.outletMapView.myLocation?.coordinate {
            self.cameraMoveToLocation(toLocation: coor)
        }

    }
}
extension OutletsViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        guard let shopTitle = marker.title else {
            return
        }
        let selectedShopArray = allOutlets?.filter({ (shop) -> Bool in
            if shop.name == shopTitle{
                return true
            }
            return false
        })
        pushToOutletDetail(outlet: selectedShopArray![0])

    }

//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        guard let shopTitle = marker.title else {
//            return false
//        }
//        let selectedShopArray = allOutlets?.filter({ (shop) -> Bool in
//            if shop.name == shopTitle{
//                return true
//            }
//            return false
//        })
//        pushToOutletDetail(outlet: selectedShopArray![0])
//
//        return true
//    }
}


extension OutletsViewController: UITableViewDelegate, UITableViewDataSource {

	@objc func onMore(_ sender: UIButton) {
		guard let cell = sender.superview?.superview?.superview as? StoreListCell, let indexPath = storeTableView.indexPath(for: cell) else {
			return
		}
		guard let outlets = self.outlets() else {
			return
		}
		let outlet = outlets[indexPath.row]
		pushToOutletDetail(outlet: outlet)
	}

	func outlets() -> [Outlet]? {
        
        guard let outlets = self.allOutlets else {
            return nil
        }
        return outlets.filter { (outlet) -> Bool in
            if /*let pickup = outlet.has_pickup, pickup == 1,*/ let show = outlet.show_in_list, show == 1 {
                return true
            }
            return false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let outlets = self.outlets() else {
			return 0
		}
		return outlets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: StoreListCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell") as? StoreListCell else {
                // Never fails:
				return UITableViewCell(style: .subtitle, reuseIdentifier: "StoreListCell") as! StoreListCell
            }
            return cell
        }()

		guard let outlets = self.outlets() else {
			return  cell
		}
		let outlet = outlets[indexPath.row]
		
		if let name = outlet.name {
			cell.titleLabel?.attributedText = NSAttributedString(string: name)
		}
		if let address = outlet.address {
			cell.addressLabel?.attributedText = NSAttributedString(string: address)
		}
		if let area = outlet.area {
			cell.areaLabel?.attributedText = NSAttributedString(string: area)
		}
		if let is_opening_soon = outlet.is_opening_soon, is_opening_soon == "1" {
			cell.openLabel?.attributedText = NSAttributedString(string: "Opening Soon")
		} else if let openFrom = outlet.open_from, let openTo = outlet.open_to {
            if(outlet.is_open == 0) {
                cell.openLabel?.attributedText = NSAttributedString(string: "Closed")
            } else {
                let dateFromat = DateFormatter()
                dateFromat.dateFormat = "HH:mm"
                let dateFrom : Date = dateFromat.date(from: (outlet.open_from)!)! // In your case its string1
                print(dateFrom)
                
                
                
                var dateTo : Date = dateFromat.date(from: (outlet.open_to)!)! // In your case its string1
                var openToStr = openTo;
                if(outlet.open_to == "00:00"){
                    dateTo = dateFromat.date(from: "23:59")!
                    openToStr = "Midnight";
                }
                print(dateTo)
                let currentDateString : String = dateFromat.string(from: Date())
                let currentDate : Date = dateFromat.date(from: (currentDateString))!
                print(currentDate)
                
                if(currentDate.isBetween(dateFrom, and: dateTo) == true){
                    //openUntil.text = "Open until \(toTimeArray[1])"
                    cell.openLabel?.attributedText = NSAttributedString(string: "\(openFrom) - \(openToStr)")
                }
                else{
                    cell.openLabel?.attributedText = NSAttributedString(string: "Opens at \((outlet.open_from)!)")
                }
			}
		}
		cell.iconImage?.image = UIImage(named: "1")
		cell.learnMore.addTarget(self, action: #selector(onMore(_:)), for: .touchUpInside)

		//Clear image hide imageview
		for i in 0...3 {
			let iconView = cell.iconView[i];
			iconView.image = nil
			iconView.isHidden = true
		}

		var index = 0
		if outlet.has_seating == "1" {
			let iconView = cell.iconView[index];
			iconView.image = UIImage(named: "seating")
			iconView.isHidden = false
			index += 1
		}
		if outlet.has_pickup == 1 {
			let iconView = cell.iconView[index];
			iconView.image = UIImage(named: "pickup")
			iconView.isHidden = false
			index += 1
		}
		if outlet.has_food == "1" {
			let iconView = cell.iconView[index];
			iconView.image = UIImage(named: "food")
			iconView.isHidden = false
			index += 1
		}
		if outlet.has_contactless == "1" {
			let iconView = cell.iconView[index];
			iconView.image = UIImage(named: "qrcode")
			iconView.isHidden = false
		}

		cell.selectionStyle = .none
		cell.backgroundColor = .clear
		return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let outlets = self.outlets() else {
			return
		}
		let outlet = outlets[indexPath.row]
		pushToOutletDetail(outlet: outlet)
    }
    
    func distanceBetweenTwoCoordinates(shop: Shop) -> String{
        guard let lat = shop.lat else{ return ""}
        guard let long = shop.lat else{ return ""}
        
        let shopLatitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
        let shopLongitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
        
        let shopLocation = CLLocation(latitude: shopLatitude , longitude: shopLongitude)
        let currentLocation = CLLocation(latitude: currentLocationCoordinate?.latitude ?? 0.0, longitude: currentLocationCoordinate?.longitude ?? 0.0)
        
        let distance : Double = getDistance(location1: currentLocation, location2: shopLocation)
        let distanceInKM = String(format: "%.1f KM", (distance/1000))
        return distanceInKM
    }

    func getDistance(location1 : CLLocation, location2 : CLLocation) -> Double {
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters
    }
    
    func dateAndTimeCalculation(shop: Shop) -> String{
        
       //print(Date().dayOfWeek()!)
        
        let currentDay = Date().dayOfWeek()!
        
        let workingHours = shop.working_hours
        let hoursArray = workingHours?.components(separatedBy: ",")

        guard let hoursArr = hoursArray else { return "Open until 11:00 PM"}
        
        let currentHourArray = hoursArr.filter({ (day) -> Bool in
            if day.contains(currentDay){
                return true
            }
            return false
        })
        if currentHourArray.count > 0 {
            let currentDayTime = currentHourArray[0]
            let toTimeArray = currentDayTime.components(separatedBy: "- ")
            return "Open until \(toTimeArray[1])"
        }
        return "Open until 11:00 PM"
    }
}
