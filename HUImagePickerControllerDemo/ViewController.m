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

- (void)viewImages:(NSArray *)assets
{
    // remove thumbs
    for (UIView *v in self.selectedImageShowView.subviews)
    {
        [v removeFromSuperview];
    }
    // add images
    int     c = 4;
    CGFloat w = self.view.frame.size.width / c;
    for (int i=0; i<[assets count]; i++)
    {
        ALAsset *asset = [assets objectAtIndex:i];
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]]];
        //[v setContentMode:UIViewContentModeScaleAspectFit];
        [v setFrame:CGRectMake(w * (i % c), floor(i / c) * w, w, w)];
        [self.selectedImageShowView addSubview:v];
    }
}

- (IBAction)viewButtonPushed:(id)sender
{
    // HUImagePickerController initialize
    HUImagePickerController *ipc = [[HUImagePickerController alloc] init];
    
    // set complete button title
    [ipc setCompleteButtonTitle:@"ok"];
    
    // set title and create Cancel Button
    [ipc setCancelButtonTitle:@"cancel"];
    
    // set select max count
    [ipc setMaxSelectCount:5];
    
    // complete callback
    [ipc setCompleteCallback:^(HUImagePickerController *navController, NSArray *assets) {
        // set images to background
        [self viewImages:assets];
        // dismiss HUImagePickerController
        [navController dismissViewControllerAnimated:YES completion:^{ }];
    }];
    
    // thumb tap callback
    [ipc setThumbTapCallback:^(HUImagePickerController *navController, HUPhotoThumb *thumb, ALAsset *selectedAssets) {
        // select
        if ([thumb isSelected])
        {
            // set selected view
            [thumb deselectThumb];
        }
        else
        {
            // set deselected view
            [thumb selectThumb];
        }
    }];
    
    // max select error callback
    [ipc setCntErrorCallback:^() {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"max count error"
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    // view HUImagePickerController
    [self presentViewController:ipc animated:YES completion:^{ }];
}

@end
