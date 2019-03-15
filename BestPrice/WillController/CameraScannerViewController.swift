//
//  CameraScannerViewController.swift
//  BestPrice
//
//  Created by William Schroeder on 3/14/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import AVFoundation

class CameraScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var capSession: AVCaptureSession!
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var upceFrameView: UIView?
    var scannedCode: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up the camera for video capture
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = discoverySession.devices.first else {
            
            print("Could not access the camera device specified")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input source for this capture session
            capSession.addInput(input)
            
            // Set up the output device for this capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            capSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.upce]
            
            // Set up the camera layer
            cameraLayer = AVCaptureVideoPreviewLayer(session: capSession)
            cameraLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraLayer?.frame = view.layer.bounds
            view.layer.addSublayer(cameraLayer!)
            
            capSession.startRunning()
            
            // Initialize frame which will track scanned barcode
            upceFrameView = UIView()
            
            if let upceFrameView = upceFrameView {
                
                upceFrameView.layer.borderColor = UIColor.green.cgColor
                upceFrameView.layer.borderWidth = 2
                view.addSubview(upceFrameView)
                view.bringSubviewToFront(upceFrameView)
            }
            
        } catch {
            
            print(error)
            return
        }


        // "Spoof" passing of data while loading to device is unavailable
        // Comment out line below to test
        //scannedCode = "747930039853"
    }
    
    // MARK: Capture input from scanner
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Set up default value while barcode is not found
        if metadataObjects.count == 0 {
            
            upceFrameView?.frame = CGRect.zero
            scannedCode = ""
            return
        }
        
        // Retrieve the metadata
        let metadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Ensure metadata is of UPC-e type and set appropriate object values
        if metadata.type == AVMetadataObject.ObjectType.upce {
            
            let barCodeScanned = cameraLayer?.transformedMetadataObject(for: metadata)
            upceFrameView?.frame = barCodeScanned!.bounds
            
            if metadata.stringValue != nil {
                
                scannedCode = metadata.stringValue
                
                // Alert user that barcode was identified and close camera
                let title = "Scan Complete"
                let message = "The barcode was successfully scanned. The camera will now close."
                let scanCompleteAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                    
                    // Code to unwind programatically - put inside alert
                    self.performSegue(withIdentifier: "unwindToUPCInput", sender: self)
                }
                scanCompleteAlert.addAction(okayAction)
                self.present(scanCompleteAlert, animated: true, completion: nil)
            }
        }
    }

    // MARK: Navigation - return to UPCInput
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if scannedCode == nil {
            
            scannedCode = ""
        }
    }

}
