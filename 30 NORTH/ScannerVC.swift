//
//  ScannerVC.swift
//  30 NORTH
//
//  Created by SOWJI on 02/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

protocol RewardPointsDelegate {
    func rewardpointsUpdated()
}
class ScannerVC: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet var topbar: UIView!
    @IBOutlet var logo: UIImageView!
    var rewardsDelegate : RewardPointsDelegate?
    var isFromRewards = false
    var id = 0
    var captureSession = AVCaptureSession()
    var isActive = false
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.id = UserDefaults.standard.integer(forKey: "userID")
        // Get the back-facing camera for capturing videos
        //        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        //
        //        guard let captureDevice = deviceDiscoverySession.devices.first else {
        //           //print("Failed to get the camera device")
        //            return
        //        }
        //
        //        do {
        //            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        //            let input = try AVCaptureDeviceInput(device: captureDevice)
        //
        //            // Set the input device on the capture session.
        //            captureSession.addInput(input)
        //
        //            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        //            let captureMetadataOutput = AVCaptureMetadataOutput()
        //            captureSession.addOutput(captureMetadataOutput)
        //
        //            // Set delegate and use the default dispatch queue to execute the call back
        //            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        //            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        //
        //        } catch {
        //            // If any error occurs, simply print it out and don't continue any more.
        //           //print(error)
        //            return
        //        }
        //
        //        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        //        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //        videoPreviewLayer?.frame = self.preview.layer.bounds
        //        preview.layer.addSublayer(videoPreviewLayer!)
        //
        //        // Start video capture.
        //        captureSession.startRunning()
        //
        //        // Move the message label and top bar to the front
        //        preview.bringSubview(toFront: topbar)
        //        preview.bringSubview(toFront: logo)
        //        // Initialize QR Code Frame to highlight the QR code
        //        qrCodeFrameView = UIView()
        //
        //        if let qrCodeFrameView = qrCodeFrameView {
        //            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        //            qrCodeFrameView.layer.borderWidth = 2
        //            preview.addSubview(qrCodeFrameView)
        //            preview.bringSubview(toFront: qrCodeFrameView)
        //        }
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        preview.frame  = CGRect.init(x: 0, y: -80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = UIScreen.main.bounds
        //        videoPreviewLayer?.videoGravity = .resizeAspectFill
        preview.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        //        preview.bringSubview(toFront: topbar)
        preview.bringSubviewToFront(logo)
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            
            qrCodeFrameView.frame = CGRect.init(x: 0, y: -80, width:self.view.bounds.size.width, height: self.view.bounds.size.height)
            qrCodeFrameView.layer.borderColor = UIColor.clear.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            preview.addSubview(qrCodeFrameView)
            preview.bringSubviewToFront(qrCodeFrameView)
        }
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession.stopRunning()
    }
    
    
    @IBAction func closeScanner(_ sender: Any) {
        captureSession.stopRunning()
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        self.isActive = true
        
        
        _ = SweetAlert().showAlert("", subTitle: "You got \(decodedURL) Reward points", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xAEDEF4), otherButtonTitle: "Confirm", action: { (isOk) in
                   if !isOk {
                      if self.isFromRewards {
                                     self.captureSession.stopRunning()
                                     self.addRewards(rewardPoints: decodedURL)
                                 }
                                 else {
                                     if let url = URL(string: decodedURL) {
                                         if UIApplication.shared.canOpenURL(url) {
                                             UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                                         }
                                     }
                                 }
                   }else{
                    self.isActive = false
            }
               })
        
        
        
        /*
        let alertPrompt = UIAlertController(title: "Reward Points", message: "You got \(decodedURL) Reward points", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            if self.isFromRewards {
                self.captureSession.stopRunning()
                self.addRewards(rewardPoints: decodedURL)
            }
            else {
                if let url = URL(string: decodedURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            self.isActive = false
        })
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
 */
    }
    func addRewards(rewardPoints : String) {
        self.view.endEditing(true)
        if let points = Int(rewardPoints) {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            //        let existedPoints = UserDefaults.standard.integer(forKey: "rewardpoints")
            let url = APIRouters.redeemPointsURLString + "\(id)&points=\(points)&type=1"

            Alamofire.request(url).responseJSON {  response  in
                _ = EZLoadingActivity.hide()
                
                if let result = response.result.value {
                   //print(result)
                    
                    let data = result as! [String : Any]
                                                  if let code = data["success"] as? Int {
                                                      if code == 1{
                                                        
                        _ = SweetAlert().showAlert(language.rewardsTitle, subTitle: data["message"] as? String, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Ok", buttonColor: UIColor.colorFromRGB(0xAEDEF4), action: { (isOk) in
                            if isOk {
                                self.rewardsDelegate?.rewardpointsUpdated()
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                                                    }}
                                                        
                }
            }
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async(execute: {
            if let window = UIApplication.shared.keyWindow {
                window.windowLevel = UIWindow.Level.statusBar + 1
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async(execute: {
            if let window = UIApplication.shared.keyWindow {
                window.windowLevel = UIWindow.Level.normal
            }
        })
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                if self.isActive == false {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    launchApp(decodedURL: metadataObj.stringValue!)
                }
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
