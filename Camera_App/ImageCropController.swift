//
//  ImageCropController.swift
//  Camera_App
//
//  Created by Singh, Pravendra on 9/2/15.
//  Copyright © 2015 Praven. All rights reserved.
//

import UIKit

protocol ImageCropViewControllerDelegate
{
    func ImageCropViewController(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!)
    func ImageCropViewControllerDidCancel(controller: UIViewController!)
}

class ImageCropController: UIViewController {

    var delegate:ImageCropViewControllerDelegate?
    var cropView : ImageCropView?
    var blurredBackground = false
    var image: UIImage? = UIImage()
    @IBOutlet weak var contentView : UIView?
    @IBOutlet weak var cropButton : UIButton?
    @IBOutlet weak var CancelButton : UIButton?
    var cropped = UIImage()
    var isFromCameraCallery : Bool = false
    
    func initWithImage(image:UIImage) {
        self.image = image.fixOrientation()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.contentView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        let view : CGRect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width+4, self.view.bounds.size.height-80)
        self.cropView = ImageCropView(frame: view, blurOn: self.blurredBackground)
        self.cropView?.backgroundColor = UIColor.blackColor()
        self.contentView!.addSubview(self.cropView!)
        self.cropView?.image = self.image
    }
    
    @IBAction func imageCropping(sender: UIButton) {
        
        if self.image != nil {
            let cropRect : CGRect? = self.cropView?.cropAreaInImage
            let imageRef : CGImageRef? = CGImageCreateWithImageInRect(self.image?.CGImage, cropRect!)
            self.cropped = UIImage(CGImage: imageRef!)
            
        }
        [self .performSegueWithIdentifier("croppedImage", sender: nil)]
        self.delegate?.ImageCropViewController(self, didFinishCroppingImage: self.cropped);
    }
    
    @IBAction func cancel(sender: UIButton) {
        if isFromCameraCallery {
           [self .performSegueWithIdentifier("navigateHome", sender: nil)]
        }else {
           [self .performSegueWithIdentifier("navigateBack", sender: nil)]
        }
        self.delegate?.ImageCropViewControllerDidCancel(self);
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
        if segue.identifier == "croppedImage" {
            let croppedImageController : CroppedImageViewController = segue.destinationViewController as! CroppedImageViewController
            croppedImageController.image = self.cropped
            if isFromCameraCallery {
                croppedImageController.isFromCameraGallery = true
            }
        }
    }
    

}
