//
//  ViewController.swift
//  Camera_App
//
//  Created by Praven on 8/26/15.
//  Copyright © 2015 Praven. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCropViewControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    var sessionQueue : dispatch_queue_t?
    var captureController = ImageCropController()
    var tempImageData = NSData()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var previewView: UIView!
    
    var imageCropView = ImageCropView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        DPrint("Camera Device Found")
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession() {
        configureDevice()
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        }catch {
            DPrint("throws error")
        }
        
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewView.layer.addSublayer(previewLayer!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = self.previewView.layer.bounds
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                device.focusMode = .ContinuousAutoFocus
                device.unlockForConfiguration()
            }
            catch {
                DPrint("Throws Error")
            }
        }
    }
    
    func deviceWithMediaTypeAndPosition(mediaType: NSString, position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices : NSArray = AVCaptureDevice.devicesWithMediaType(mediaType as String)
        var captureDevice : AVCaptureDevice = devices.firstObject as! AVCaptureDevice
        
        for device in devices {
            let device = device as! AVCaptureDevice
            if device.position == position {
                captureDevice = device
                break
            }
        }
        return captureDevice
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func frontAndBackCameraButton (sender:UIButton) {
        
        if self.captureSession.running{
            let animation : CATransition = CATransition()
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = "oglFlip"
            self.captureSession.beginConfiguration()
            let currentCameraInput : AVCaptureInput = self.captureSession.inputs[0] as! AVCaptureInput
            self.captureSession.removeInput(currentCameraInput)
            
            var newCamera : AVCaptureDevice? = nil
            
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == AVCaptureDevicePosition.Back {
                newCamera = self.deviceWithMediaTypeAndPosition(AVMediaTypeVideo, position: AVCaptureDevicePosition.Front)
                animation.subtype = kCATransitionFromLeft
            }else {
                newCamera = self.deviceWithMediaTypeAndPosition(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back)
                animation.subtype = kCATransitionFromLeft
            }
            
            let error : NSError? = nil
            var newVideoInput : AVCaptureDeviceInput?
            do {
                newVideoInput =  try AVCaptureDeviceInput(device: newCamera)
            }catch {
                DPrint("throws error")
            }
            
            if ((newVideoInput == nil) || error != nil) {
                
            }else {
                self.captureSession.addInput(newVideoInput)
            }
            self.captureSession.commitConfiguration()
            previewLayer?.addAnimation(animation, forKey: nil)
        }
        
    }
    
    @IBAction func captureButton (sender:UIButton) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                //UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
                if UIImage(data: imageData) != nil {
                    self.tempImageData = imageData
                    [self .performSegueWithIdentifier("ImageCrop", sender: nil)]
                }
            }
        }
    }
    
    @IBAction func openGallery (sender:UIButton) {
        self.presentViewController(self.imagePicker, animated: true) { () -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .PhotoLibrary
        }
      }
    
    @IBAction func cancel (sender:UIButton) {
        [self .performSegueWithIdentifier("navigateHome", sender: nil)]
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.tempImageData = NSData(data: UIImageJPEGRepresentation(pickedImage, 1.0)!)
            }
            [self .performSegueWithIdentifier("ImageCrop", sender: nil)]
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ImageCrop" {
            let captureImageController : ImageCropController = segue.destinationViewController as! ImageCropController
            captureImageController.initWithImage(UIImage(data: self.tempImageData)!)
            captureImageController.delegate = self
            captureImageController.blurredBackground = true
        }
    }
    
    @IBAction func unwindToCameraController(unwindSegue: UIStoryboardSegue) {
        captureSession.startRunning()
    }
    
    func ImageCropViewController(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        // Save cropped Image in Camera Gallery
        //UIImageWriteToSavedPhotosAlbum(croppedImage!, nil, nil, nil)
    }
    
    func ImageCropViewControllerDidCancel(controller: UIViewController!) {
        
    }
    
}

