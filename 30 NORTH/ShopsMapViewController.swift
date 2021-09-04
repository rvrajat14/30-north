//
//  ShopsMapViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 17/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import CoreLocation

class ShopsMapViewController: UIViewController, CLLocationManagerDelegate {
    let regionRadius: CLLocationDistance = 1000
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var mapView: MKMapView!
    var shopAnno = [ShopAnnotation]()
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewBackground: UIView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    let locationManager = CLLocationManager()
    var slider = UISlider()
    var userLat: Double = 0.0
    var userLng: Double = 0.0
    var isLocationServiceError: Bool = false
    var allShops = [ShopModel]()
    var selectedShopArrayIndex: Int!
    var shopIndex: Int!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue.text = String(format: "%.01f", sender.value) + language.miles
    }
    
    @IBAction func searchByLocation(_ sender: AnyObject) {
        openRangePopup()
    }
    

    @IBAction func doSearch(_ sender: AnyObject) {
        popupView.isHidden = true
        popupViewBackground.isHidden = true
        if(!isLocationServiceError) {
        
            if(userLat != 0.0 && userLng != 0.0) {
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                Alamofire.request(APIRouters.ShopSearchByLocation(rangeSlider.value, userLat, userLng)).responseCollection {
                    (response: DataResponse<[Shop]>) in
                   _ = EZLoadingActivity.hide()
                    if response.result.isSuccess {
                        if let shops: [Shop] = response.result.value {
                            self.mapView.removeAnnotations(self.mapView.annotations)

                            
                            if(shops.count > 0) {
                                self.shopAnno.removeAll()
                                self.shopIndex = 0
                                for shop in shops {
                                    let oneShop = ShopAnnotation(index: self.shopIndex, id: shop.id!, title: shop.name!, locationName: shop.address!, lat: Double(shop.lat!)!, lng: Double(shop.lng!)!)
                                    self.shopAnno.append(oneShop)
                                    self.shopIndex = self.shopIndex + 1
                                    
                                }
                                self.mapView.addAnnotations(self.shopAnno)
                                self.mapView.delegate = self
                                
                            } else {
                                self.title = language.mapExplorePageTitle
                                _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.shopNotFount, style: AlertStyle.customImag(imageFile: "Logo"))
                            }
                        }
                        
                    } else {
                       //print(response.description)
                    }
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.allowLocationService, style: AlertStyle.customImag(imageFile: "Logo"))
        }
    }
    
    @IBAction func doClose(_ sender: AnyObject) {
        popupView.isHidden = true
        popupViewBackground.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        let initialLocation = CLLocation(latitude: Double(configs.regionLat)!, longitude: Double(configs.regionLng)!)
        centerMapOnLocation(initialLocation)
        loadShopAnnotation()
        preparePopupView()
        btnSearch.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius * 100.0, longitudinalMeters: regionRadius * 100.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadShopAnnotation() {
        /*
        if(ShopsListModel.sharedManager.shops.count > 0) {
            
            shopIndex = 0
            for shop in ShopsListModel.sharedManager.shops {
                let oneShop = ShopAnnotation(index: shopIndex, id: shop.id, title: shop.name, locationName: shop.address, lat: Double(shop.lat)!, lng: Double(shop.lng)!)
                self.shopAnno.append(oneShop)
                shopIndex = shopIndex + 1
                

            }
            self.mapView.addAnnotations(self.shopAnno)
            self.mapView.delegate = self
        } else {*/
           //print("need to laod from API")
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            Alamofire.request(APIRouters.GetShopByID(1)).responseCollection {
                (response: DataResponse<[Shop]>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let shops: [Shop] = response.result.value {
                        
                        
                        if shops.count > 1 {
                            self.shopIndex = 0
                            for shop in shops {
                                
                                let oneShop = ShopAnnotation(index: self.shopIndex, id: shop.id!, title: shop.name!, locationName: shop.address!, lat: Double(shop.lat!)!, lng: Double(shop.lng!)!)
                                self.shopAnno.append(oneShop)
                                self.shopIndex = self.shopIndex + 1
                                
                                let shopInfo = ShopModel(shop: shop)
                                self.allShops.append(shopInfo)
                                
                            }
                            
                            self.mapView.addAnnotations(self.shopAnno)
                            self.mapView.delegate = self
//                            ShopsListModel.sharedManager.shops = self.allShops
                            
                        } else {
                            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                        
                       //print(shops.count)
                        
                        
                        
                    }
                    
                    
                } else {
                   //print("Response is fail.")
                    _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.tryAgainToConnect, style: AlertStyle.customImag(imageFile: "Logo"))
                }
            }
            
//        }
        
        
    }
    
    func preparePopupView() {
        popupViewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popupView.clipsToBounds = true
        
        popupView.isHidden = true
        popupViewBackground.isHidden = true
        
    }
    
    func openRangePopup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        popupView.isHidden = false
        popupViewBackground.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
               //print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
                self.userLat = manager.location!.coordinate.latitude
                self.userLng = manager.location!.coordinate.longitude
                
            } else {
                _ = SweetAlert().showAlert(language.searchTitle, subTitle: language.geocoderProblem, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            
            if(locality != nil) {
                currentLocation.text = language.currentLocation + "( " + locality! + " )"
            } else {
                currentLocation.text = language.currentLocation + "( N.A )"
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       //print("Error while updating location " + error.localizedDescription)
        isLocationServiceError = true
    }

    
    
}

extension ShopsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        weak var annotation = annotation as? ShopAnnotation
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //self.navigationController?.popViewControllerAnimated(true)
        weak var location = view.annotation as? ShopAnnotation
        weak var selectedShopController = self.storyboard?.instantiateViewController(withIdentifier: "SelectedShop") as? SelectedShopViewController
        self.navigationController?.pushViewController(selectedShopController!, animated: true)
//        selectedShopController?.shopModel = ShopsListModel.sharedManager.shops[location!.index!]
        selectedShopController!.selectedShopArrayIndex = location!.index
        
    }
    
    
}
