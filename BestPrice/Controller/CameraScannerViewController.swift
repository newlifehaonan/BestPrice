//
//  CameraScannerViewController.swift
//  BestPrice


import UIKit
import AVFoundation

class CameraScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var returnButton: UIButton!
    var capSession: AVCaptureSession!
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var upcFrameView: UIView?
    var scannedCode: String?
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized: // The user has previously granted access to the camera.
            print("Camera access granted")
            self.setupCaptureSession()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            print("Camera access requested")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                
                if granted {
                    
                    self.setupCaptureSession()
                }
            }
            
        case .denied: // The user has previously denied access.
            print("Camera access denied")
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            print("Camera access restricted")
            return
        }
        
        // "Spoof" passing of data while loading to device is unavailable
        // Comment out line below to test
        //scannedCode = "747930039853"
    }
    
    // MARK: Prepare and display the camera
    func setupCaptureSession() {
        
        // Set up the camera for video capture
        guard let captureDevice = self.discoverCamera() else {
            
            print("Could not access the camera device specified")
            return
        }
        
        do {
            
            capSession = AVCaptureSession()
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input source for this capture session
            capSession.addInput(input)
            
            // Set up the output device for this capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            capSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
            
            // Set up the camera layer
            cameraLayer = AVCaptureVideoPreviewLayer(session: capSession)
            cameraLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraLayer?.frame = view.layer.bounds
            view.layer.addSublayer(cameraLayer!)
            
            capSession.startRunning()
            
            // Bring return button to the front
            view.bringSubviewToFront(returnButton)
            
            // Initialize frame which will track scanned barcode
            upcFrameView = UIView()
            
            if let upcFrame = upcFrameView {
                
                upcFrame.layer.borderColor = UIColor.green.cgColor
                upcFrame.layer.borderWidth = 2
                view.addSubview(upcFrame)
                view.bringSubviewToFront(upcFrame)
            }
            
        } catch {
            
            print(error)
            return
        }
    }
    
    // MARK: Capture input from scanner
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Set up default value while barcode is not found
        if metadataObjects.count == 0 {
            
            upcFrameView?.frame = CGRect.zero
            scannedCode = ""
            return
        }
        
        // Retrieve the metadata
        let metadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Ensure metadata is of UPC-e type and set appropriate object values
        if output.metadataObjectTypes.contains(metadata.type) {
            
            let barCodeScanned = cameraLayer?.transformedMetadataObject(for: metadata)
            upcFrameView?.frame = barCodeScanned!.bounds
            
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
                
                capSession.stopRunning()
            }
        }
    }
    
    // MARK: Find bets camera supported by device
    func discoverCamera() -> AVCaptureDevice? {
        
        let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let cameraDevice = deviceDiscovery.devices.first else {
            
            print("Failed to get the camera device")
            return nil
        }
        
        return cameraDevice
    }
    
    // MARK: Navigation - return to UPCInput
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if scannedCode == nil {
            
            scannedCode = ""
        }
    }
    
}

