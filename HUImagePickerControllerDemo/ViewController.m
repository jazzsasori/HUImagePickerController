//
//  ViewController.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "ViewController.h"
#import "HUImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewImages:(NSArray *)images
{
    // remove thumbs
    for (UIView *v in self.selectedImageShowView.subviews)
    {
        [v removeFromSuperview];
    }
    // add images
    int     c = 4;
    CGFloat w = self.view.frame.size.width / c;
    for (int i=0; i<[images count]; i++)
    {
        UIImageView *v = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        //[v setContentMode:UIViewContentModeScaleAspectFit];
        [v setFrame:CGRectMake(w * (i % c), floor(i / c) * w, w, w)];
        [self.selectedImageShowView addSubview:v];
    }
}

- (IBAction)viewButtonPushed:(id)sender
{
    // HUImagePickerController initialize
    HUImagePickerController *ipc = [[HUImagePickerController alloc] init];
    
    // complete callback
    [ipc setCompleteCallback:^(HUImagePickerController *navController, NSArray *images) {
        // set images to background
        [self viewImages:images];
        // dismiss HUImagePickerController
        [navController dismissViewControllerAnimated:YES completion:^{ }];
    }];
    
    // thumb tap callback
    [ipc setThumbTapCallback:^(HUImagePickerController *navController, HUPhotoThumb *thumb, UIImage *selectedImage) {
        // select
        if ([thumb isSelected])
        {
            [thumb deselectThumb];
        }
        else
        {
            [thumb selectThumb];
        }
    }];
    
    // view HUImagePickerController
    [self presentViewController:ipc animated:YES completion:^{ }];
}

@end
