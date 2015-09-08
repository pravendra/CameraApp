//
//  CroppedImageViewController.swift
//  Camera_App
//
//  Created by Singh, Pravendra on 9/3/15.
//  Copyright © 2015 Praven. All rights reserved.
//

import UIKit

class CroppedImageViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView?
    var image : UIImage?
    var isFromCameraGallery : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView?.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender:UIButton) {
        if isFromCameraGallery {
          [self .performSegueWithIdentifier("navigateHome", sender: nil)]
        }else {
          [self .performSegueWithIdentifier("navigateBack", sender: nil)]
        }
    }
    
    @IBAction func chooseCroppedImage(sender:UIButton) {
        // Use cropped image and navigate to destination controller
        DPrint("Use cropped image and navigate to destination controller")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
