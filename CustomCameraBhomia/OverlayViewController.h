//
//  OverlayViewController.h
//  OverlayViewTester
//
//  Created by Jason Job on 09-12-10.
//  Copyright 2009 Jason Job. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIButton *cameraSelectionButton,*recrdBtn;
    IBOutlet UIButton *flashModeButton;
    IBOutlet UIButton *videoQualitySelectionButton;
    IBOutlet UIImageView *recordIndicatorView;
    NSURL *VideoUrl;
    IBOutlet UIView *cameraOverlayView;
    
    UITapGestureRecognizer  *recordGestureRecognizer;
    UIImagePickerController *imagePicker;
    BOOL                     recording;
    BOOL                     showCameraSelection;
    BOOL                     showFlashMode;
}
- (IBAction)changeVideoQuality:(id)sender;
- (IBAction)changeFlashMode:(id)sender;
- (IBAction)changeCamera:(id)sender;
- (IBAction)recButtonTapped:(id)sender;
- (void)createImagePicker;
- (void)startRecording;
- (void)stopRecording;

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;


@end
