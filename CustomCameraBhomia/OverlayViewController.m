//
//  ViewController.m
//  SlowMotionVideoRecorder
//
//  Created by shuichi on 12/17/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "OverlayViewController.h"
#import "VideoPlayViewController.h"
@interface OverlayViewController ()
{
    NSTimeInterval startTime;
    BOOL isNeededToSave;
}
@property (nonatomic, assign) NSTimer *timer,*StopTimer;
@property (nonatomic, strong) UIImage *recStartImage;
@property (nonatomic, strong) UIImage *recStopImage;
@property (nonatomic, strong) UIImage *outerImage1;
@property (nonatomic, strong) UIImage *outerImage2;
@property (nonatomic, weak) IBOutlet UIImageView *outerImageView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@end


@implementation OverlayViewController
- (void)timerHandlerForStoping:(NSTimer *)timer {
    
    recording = NO;
    [self.timer invalidate];
    [self.StopTimer invalidate];
    self.timer = nil;
    self.statusLabel.text = @"00:00";
    // change UI
    [recrdBtn setImage:self.recStartImage
              forState:UIControlStateNormal];
    [self stopRecording];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
//    recordGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleVideoRecording)];
//    recordGestureRecognizer.numberOfTapsRequired = 2;
//    
//    [cameraOverlayView addGestureRecognizer:recordGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    UIImage *image;
    image = [UIImage imageNamed:@"45_rpm_record.png"];
    self.recStartImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [recrdBtn setImage:self.recStartImage
              forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"45_rpm_record.png"];
    self.recStopImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [recrdBtn setTintColor:[UIColor colorWithRed:245./255.
                                           green:51./255.
                                            blue:51./255.
                                           alpha:1.0]];
    self.outerImage1 = [UIImage imageNamed:@"outer1"];
    self.outerImage2 = [UIImage imageNamed:@"outer2"];
    self.outerImageView.image = self.outerImage1;
    cameraSelectionButton.alpha = 0.0;
    flashModeButton.alpha = 0.0;
    recordIndicatorView.alpha = 0.0;
    //
    [self createImagePicker];

    
   
//
//    
//
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
}
- (IBAction)Next:(id)sender{
    
    NSLog(@"VideoUrl%@",VideoUrl);
  [imagePicker dismissViewControllerAnimated:YES completion:NULL];
    VideoPlayViewController *nextClass=[[VideoPlayViewController alloc]initWithNibName:@"VideoPlayViewController" bundle:nil];
    nextClass.nextUrl=VideoUrl;
    [self.navigationController pushViewController:nextClass animated:YES];
}
- (IBAction)recButtonTapped:(id)sender {
    
    if (!recording) {
        recording = YES;
        [recrdBtn setImage:self.recStopImage
                     forState:UIControlStateNormal];
       // self.fpsControl.enabled = NO;
        
        // timer start
        startTime = [[NSDate date] timeIntervalSince1970];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(timerHandler:)
                                                    userInfo:nil
                                                     repeats:YES];
        self.StopTimer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                                      target:self
                                                    selector:@selector(timerHandlerForStoping:)
                                                    userInfo:nil
                                                     repeats:YES];

        [self startRecording];
    } else {
        recording = NO;
        [self.timer invalidate];
        [self.StopTimer invalidate];
        self.timer = nil;
        self.statusLabel.text = @"00:00";
        // change UI
        [recrdBtn setImage:self.recStartImage
                     forState:UIControlStateNormal];
        [self stopRecording];
    }

    
    
    
    // REC START
    }



- (void)createImagePicker {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    CGRect theRect = [imagePicker.view frame];
      [cameraOverlayView setFrame:theRect];
    imagePicker.cameraOverlayView = cameraOverlayView;
//    imagePicker.videoMaximumDuration=15.0;

    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    imagePicker.cameraViewTransform = CGAffineTransformIdentity;
    
    // not all devices have two cameras or a flash so just check here
    if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear] ) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront] ) {
            cameraSelectionButton.alpha = 1.0;
            showCameraSelection = YES;
        }
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    if ( [UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice] ) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        flashModeButton.alpha = 1.0;
        showFlashMode = YES;
    }
    
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    
    imagePicker.delegate = self;
    imagePicker.wantsFullScreenLayout = NO;
    [self addChildViewController: imagePicker];
    [self.view addSubview:imagePicker.view];
}


- (void)toggleVideoRecording {
    if (!recording) {
        recording = YES;
        [self startRecording];
    } else {
        recording = NO;
        [self stopRecording];
    }
}
- (void)timerHandler:(NSTimer *)timer {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - startTime;
    
    self.statusLabel.text = [NSString stringWithFormat:@"%.2f", recorded];
}
- (void)changeVideoQuality:(id)sender {
    if (imagePicker.videoQuality == UIImagePickerControllerQualityType640x480) {
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        [videoQualitySelectionButton setImage:[UIImage imageNamed:@"hd-selected.png"] forState:UIControlStateNormal];
    } else {
        imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
        [videoQualitySelectionButton setImage:[UIImage imageNamed:@"sd-selected.png"] forState:UIControlStateNormal];
    }
}

- (void)changeFlashMode:(id)sender {
    if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [flashModeButton setImage:[UIImage imageNamed:@"flash-on.png"] forState:UIControlStateNormal];
    } else {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [flashModeButton setImage:[UIImage imageNamed:@"flash-off.png"] forState:UIControlStateNormal];
    }
}

- (void)changeCamera:(id)sender {
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    if ( ![UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice] ) {
        [UIView animateWithDuration:0.3 animations:^(void) {flashModeButton.alpha = 0;}];
        showFlashMode = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {flashModeButton.alpha = 1.0;}];
        showFlashMode = YES;
    }
}

- (void)startRecording {
    
    void (^hideControls)(void);
    hideControls = ^(void) {
        cameraSelectionButton.alpha = 0;
        flashModeButton.alpha = 0;
        videoQualitySelectionButton.alpha = 0;
        recordIndicatorView.alpha = 1.0;
    };
    
    void (^recordMovie)(BOOL finished);
    recordMovie = ^(BOOL finished) {
        [imagePicker startVideoCapture];
    };
    
    // Hide controls
    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:hideControls completion:recordMovie];
}

- (void)stopRecording {
    [imagePicker stopVideoCapture];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    NSString *pathToVideo = [videoURL path];
    VideoUrl= [info valueForKey:UIImagePickerControllerMediaURL];;
     NSLog(@"VideoUrl%@",VideoUrl);
    BOOL okToSaveVideo = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToVideo);
    if (okToSaveVideo) {
        UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        [self video:pathToVideo didFinishSavingWithError:nil contextInfo:NULL];
    }
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    void (^showControls)(void);
    showControls = ^(void) {
        if (showCameraSelection) cameraSelectionButton.alpha = 1.0;
        if (showFlashMode) flashModeButton.alpha = 1.0;
        videoQualitySelectionButton.alpha = 1.0;
        recordIndicatorView.alpha = 0.0;
    };
    
    // Show controls
    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:showControls completion:NULL];
    
}
@end

