//
//  VideoPlayViewController.m
//  CustomCameraBhomia
//
//  Created by NOTOITSOLUTIONS on 07/01/15.
//  Copyright (c) 2015 NOTO SOLUTIONS. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>
@interface VideoPlayViewController ()
@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) NSString *originalVideoPath;
@property (strong, nonatomic) NSString *tmpVideoPath;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat stopTime;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *trimBtn,*trimSave,*originalShow,*originalPlay;
@end

@implementation VideoPlayViewController
@synthesize nextUrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)Play:(id)sender
{
    MPMoviePlayerViewController *videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:nextUrl];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerView];
    [videoPlayerView.moviePlayer play];
}
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];}
- (void)viewDidLoad
{
    NSLog(@"nextUrl%@",nextUrl);
    [self createVideoThumbnail:[nextUrl absoluteString]];
    self.myActivityIndicator.hidden = YES;
    
    NSString *tempDir = NSTemporaryDirectory();
    self.tmpVideoPath = [tempDir stringByAppendingPathComponent:@"tmpMov.mov"];
   // NSBundle *mainBundle = [NSBundle mainBundle];
     self.originalVideoPath = [nextUrl path];
     AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.originalVideoPath]];
    self.generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    //    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    self.generator.requestedTimeToleranceBefore = kCMTimeZero;
    self.generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    _generator.appliesPreferredTrackTransform = YES;
    self.composition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:asset];
    
    NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
    NSTimeInterval frameDuration = CMTimeGetSeconds(_composition.frameDuration);
  //  CGFloat totalFrames = round(duration/frameDuration);
    
    
    [totalVideoLength setText:[NSString stringWithFormat:@"Video Duration : %.1fs",duration]];
    
    
        self.mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) videoUrl:nextUrl ];
        self.mySAVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
        [self.mySAVideoRangeSlider setPopoverBubbleSize:120 height:60];
        // self.mySAVideoRangeSlider.maxGap=30;
        
    
    
    // Yellow
    self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.996 green: 0.951 blue: 0.502 alpha: 1];
    self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
    
    // Purple
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha: 1];
    
    // Gray
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.945 green: 0.945 blue: 0.945 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.806 green: 0.806 blue: 0.806 alpha: 1];
    
    // Green
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.725 green: 0.879 blue: 0.745 alpha: 1];
    //self.mySAVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.449 green: 0.758 blue: 0.489 alpha: 1];
    
    // Star
    //self.mySAVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 1 green: 0.114 blue: 0.114 alpha: 1];
    
    self.mySAVideoRangeSlider.delegate = self;
    
    
    [self.view addSubview:self.mySAVideoRangeSlider];
    self.mySAVideoRangeSlider.delegate = self;
    totalVideoLength.hidden=FALSE;
    self.timeLabel.hidden=FALSE;
    self.trimBtn.hidden=FALSE;
    self.trimSave.hidden=FALSE;
    self.originalPlay.hidden=FALSE;
    self.originalShow.hidden=FALSE;
    
    [self.view addSubview:self.mySAVideoRangeSlider];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)createVideoThumbnail:(NSString *)contentURL
{
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:contentURL] options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    imgVideoThumbnail.image = theImage;
    
    CGImageRelease(imgRef);
//    [asset release];
//    [generator release];
    
    //return theImage;
}
- (IBAction)saveOriginalVideo:(id)sender {
    UISaveVideoAtPathToSavedPhotosAlbum (self.originalVideoPath, nil, nil, nil);
    
    
}
- (IBAction)showTrimmedVideo:(UIButton *)sender {
    
    [self deleteTmpFile];
    
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];
    
    AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tmpVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, anAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime-self.startTime, anAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        
        self.myActivityIndicator.hidden = NO;
        [self.myActivityIndicator startAnimating];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myActivityIndicator stopAnimating];
                        self.myActivityIndicator.hidden = YES;
                        [self playMovie:self.tmpVideoPath];
                        
                    });
                    
                    break;
            }
        }];
        
    }
    
}
- (IBAction)saveTrimmedVideo:(UIButton *)sender {
    
    [self deleteTmpFile];
    
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.originalVideoPath];
    
    AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tmpVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, anAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime-self.startTime, anAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        
        self.myActivityIndicator.hidden = NO;
        [self.myActivityIndicator startAnimating];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myActivityIndicator stopAnimating];
                        self.myActivityIndicator.hidden = YES;
                        
                        UISaveVideoAtPathToSavedPhotosAlbum (self.tmpVideoPath, nil, nil, nil);
                    });
                    
                    break;
            }
        }];
        
    }
    
}


#pragma mark - Other
-(void)deleteTmpFile{
    
    NSURL *url = [NSURL fileURLWithPath:self.tmpVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}

- (IBAction)showOriginalVideo:(id)sender {
    
    [self playMovie:self.originalVideoPath];
    
}
- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    self.stopTime = rightPosition;
    startTime.text = [NSString stringWithFormat:@"Start time- %.1fs", leftPosition];
    endTime.text = [NSString stringWithFormat:@"End time- %.1fs",rightPosition];
    self.timeLabel.text = [NSString stringWithFormat:@"Trimmed Video  %.1fs - %.1fs", leftPosition, rightPosition];
    
}






- (void)viewDidUnload {
    [self setMyActivityIndicator:nil];
    [self setTrimBtn:nil];
    [super viewDidUnload];
}
-(void)playMovie: (NSString *) path{
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:theMovie];
    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [theMovie.moviePlayer play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
