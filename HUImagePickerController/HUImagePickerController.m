//
//  HUImagePickerController.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "HUImagePickerController.h"

@interface HUImagePickerController ()

@end

@implementation HUImagePickerController
{
    HUImagePicker *rootViewController;
}


#pragma mark - initialize

- (id)init
{
    // create HUImagePicker
    rootViewController = [[HUImagePicker alloc] initWithNibName:@"HUImagePicker" bundle:nil];
    // init
    self = [super init];
    if (self)
    {
        [self setViewControllers:@[rootViewController]];
    }
    
    return self;
}


#pragma mark - memory management

- (void)dealloc
{
    [self setCompleteCallback:nil];
    [self setThumbTapCallback:nil];
    [self setCntErrorCallback:nil];
}

@end
