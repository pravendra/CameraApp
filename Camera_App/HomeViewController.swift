//
//  HomeViewController.swift
//  Camera_App
//
//  Created by Singh, Pravendra on 9/4/15.
//  Copyright © 2015 Praven. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonPressed (sender: UIButton) {
        
            let optionMenu = UIAlertController()
 
            let cameraAction = UIAlertAction(title: "Open Camera", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                DPrint("Launch camera")
                [self .performSegueWithIdentifier("cameraController", sender: nil)]
            })
            let cameraGalleryAction = UIAlertAction(title: "Open Camera Gallery", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                DPrint("Open gallery")
                self.presentViewController(self.imagePicker, animated: true) { () -> Void in
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .PhotoLibrary
                }            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                DPrint("Cancelled")
            })
            optionMenu.addAction(cameraAction)
            optionMenu.addAction(cameraGalleryAction)
            optionMenu.addAction(cancelAction)

            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.selectedImage = pickedImage
            }
            [self .performSegueWithIdentifier("cameraGallery", sender: nil)]
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cameraGallery" {
            let captureImageController : ImageCropController = segue.destinationViewController as! ImageCropController
            captureImageController.initWithImage(self.selectedImage)
            captureImageController.blurredBackground = true
            captureImageController.isFromCameraCallery = true
        }
    }
}
