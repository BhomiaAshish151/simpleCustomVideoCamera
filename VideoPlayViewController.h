//
//  VideoPlayViewController.h
//  CustomCameraBhomia
//
//  Created by NOTOITSOLUTIONS on 07/01/15.
//  Copyright (c) 2015 NOTO SOLUTIONS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAVideoRangeSlider.h"
@interface VideoPlayViewController : UIViewController{
    //UIImage *theImage;
   IBOutlet UIImageView *imgVideoThumbnail;
    IBOutlet UILabel *totalVideoLength,*startTime,*endTime;
}
- (IBAction)saveTrimmedVideo:(UIButton *)sender;
- (IBAction)saveOriginalVideo:(id)sender ;
@property (nonatomic, retain) AVAssetImageGenerator *generator;
@property (nonatomic, retain) AVVideoComposition *composition;
@property(nonatomic,retain)NSURL *nextUrl;
-(IBAction)Play:(id)sender;
-(IBAction)Back:(id)sender;
@end
