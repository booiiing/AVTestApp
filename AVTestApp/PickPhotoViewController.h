//
//  SecondViewController.h
//  AVTestApp
//
//  Created by Christoph Wendt on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickPhotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property BOOL newMedia;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;
@end
