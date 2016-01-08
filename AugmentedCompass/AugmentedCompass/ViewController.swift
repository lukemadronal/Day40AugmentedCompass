//
//  ViewController.swift
//  AugmentedCompass
//
//  Created by Luke Madronal on 11/16/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreMotion

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var previewView: UIView!
    var captureSession :AVCaptureSession?
    var previewLayer :AVCaptureVideoPreviewLayer?
    @IBOutlet weak var capturedImage :UIImageView!
    var stillImageOutput :AVCaptureStillImageOutput?
    
    //MARK: - Camera Methods
    
    func startCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input :AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
            
            
        }catch let error1 as NSError {
            error = error1
            input = nil
            print("Error\(error)")
        }
        if error == nil && captureSession!.canAddInput(input){
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer!.connection?.videoOrientation = .Portrait
            previewView.layer.addSublayer(previewLayer!)
            
            captureSession?.startRunning()
            
        }
    }
    
    //MARK: - Rotation Angles
    private var motionManager = CMMotionManager()
    private var timer: NSTimer?
    @IBOutlet var angleLabel :UILabel!
    
    
    @IBAction private func startAngleFinder(sender: UIButton) {
        timer = NSTimer(timeInterval: 0.0001, target: self, selector: "getAngleInfo", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        
    }
    
    @IBAction private func stopAngleFinder(sender: UIButton) {
        if let uTimer = timer {
            uTimer.invalidate()
        }
        
    }
    
    func getAngleInfo() {
        if let uDeviceMotion = motionManager.deviceMotion {
            let currentGravity = uDeviceMotion.gravity
            let angleInRadians = atan2(currentGravity.y, currentGravity.x)
            var angleInDegrees = (angleInRadians * 180.0 / M_PI)
            if angleInDegrees <= -90 {
                angleInDegrees += 450.0
            } else {
                angleInDegrees += 90.0
            }
            angleLabel.text = "Angle: \(angleInDegrees) degrees"
        }
    }
    
    //MARK: - Compass Methods
    
    var locationManager = CLLocationManager()
    @IBOutlet var NLabel :UILabel!
    @IBOutlet var Nconstraint: NSLayoutConstraint!
    
    @IBOutlet var NELabel :UILabel!
    @IBOutlet var NEconstraint: NSLayoutConstraint!
    
    @IBOutlet var ELabel :UILabel!
    @IBOutlet var Econstraint: NSLayoutConstraint!
    
    @IBOutlet var SELabel :UILabel!
    @IBOutlet var SEconstraint: NSLayoutConstraint!
    
    @IBOutlet var SLabel :UILabel!
    @IBOutlet var Sconstraint: NSLayoutConstraint!
    
    @IBOutlet var SWLabel :UILabel!
    @IBOutlet var SWconstraint: NSLayoutConstraint!
    
    @IBOutlet var WLabel :UILabel!
    @IBOutlet var Wconstraint: NSLayoutConstraint!
    
    @IBOutlet var NWLabel :UILabel!
    @IBOutlet var NWconstraint: NSLayoutConstraint!
    
    @IBAction func startGettingHeading(sender: UIButton) {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    @IBAction func stopGettingHeading(sender: UIButton) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var headingString = ""
        let constant = (newHeading.magneticHeading)
        var constraintConstant = CGFloat(0)
        
        switch newHeading.magneticHeading{
        case 0...22.5:
            headingString = "N"
            constraintConstant = CGFloat(constant)
        case 22.5...67.5:
            headingString = "NE"
            constraintConstant = CGFloat(constant)
        case 67.5...112.5:
            headingString = "E"
            constraintConstant = CGFloat(constant)
        case 112.5...157.5:
            headingString = "SE"
            constraintConstant = CGFloat(constant)
        case 157.5...202.5:
            headingString = "S"
            constraintConstant = CGFloat(constant)
        case 202.5...247.5:
            headingString = "SW"
            constraintConstant = CGFloat(constant)
        case 247.5...292.5:
            headingString = "W"
            constraintConstant = CGFloat(constant)
        case 292.5...337.5:
            headingString = "NW"
            constraintConstant = CGFloat(constant)
        case 337.5...360.0:
            headingString = "N"
            constraintConstant = CGFloat(constant)
        default:
            headingString = "?"
        }
        
        let width = UIScreen.mainScreen().bounds.width
        
        Nconstraint.constant = ((width / 2) - (NLabel.frame.width / 2)) - ((constraintConstant * width) / 360)
        
        NEconstraint.constant = ((width / 2) - (NELabel.frame.width / 2)) - ((constraintConstant * width) / 360) + NELabel.frame.width
        
        Econstraint.constant = ((width / 2) - (ELabel.frame.width / 2)) - ((constraintConstant * width) / 360) + ELabel.frame.width * 2
        
        SEconstraint.constant = ((width / 2) - (SELabel.frame.width / 2)) - ((constraintConstant * width) / 360) + SELabel.frame.width * 3
        
        Sconstraint.constant = ((width / 2) - (SLabel.frame.width / 2)) - ((constraintConstant * width) / 360) + SLabel.frame.width * 4
        
        SWconstraint.constant = ((width / 2) - (SWLabel.frame.width / 2)) - ((constraintConstant * width) / 360) + SWLabel.frame.width * 5
        
        Wconstraint.constant = ((width / 2) - (WLabel.frame.width / 2)) - ((constraintConstant * width) / 360) + WLabel.frame.width * 6
        
        NWconstraint.constant = ((width / 2) - (NWLabel.frame.width / 2)) - ((constraintConstant * width) / 360) + NWLabel.frame.width * 7
        
        if (NLabel.frame.origin.x > width) {
            Nconstraint.constant = Nconstraint.constant - width
        }
        
        if (NELabel.frame.origin.x > width) {
            NEconstraint.constant = NEconstraint.constant - width
        }
        
        if (ELabel.frame.origin.x > width) {
            Econstraint.constant = Econstraint.constant - width
        }
        
        if (SELabel.frame.origin.x > width) {
            SEconstraint.constant = SEconstraint.constant - width
        }
        
        if (SLabel.frame.origin.x > width) {
            Sconstraint.constant = Sconstraint.constant - width
        }
        
        if (SWLabel.frame.origin.x > width) {
            SWconstraint.constant = SWconstraint.constant - width
        }
        
        if (WLabel.frame.origin.x > width) {
            Wconstraint.constant = Wconstraint.constant - width
        }
        
        if (NWLabel.frame.origin.x > width) {
            NWconstraint.constant = NWconstraint.constant - width
        }
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.startDeviceMotionUpdates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

