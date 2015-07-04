//
//  EYImagePickerViewController.h
//  IPSShelf
//
//  Created by zhoujinqiang on 15/3/26.
//  Copyright (c) 2015年 zhoujinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EYImagePickerViewController;

typedef void (^EYImagePickerCompleteBlock)(EYImagePickerViewController* picker, UIImage* thumbnail, NSString* filePath);

@interface EYImagePickerViewController : UIImagePickerController


@property (nonatomic, copy) void (^dismissBlock)(NSDictionary* userInfo);


+ (BOOL)isCameraPhotoAvailable;
+ (BOOL)isCameraVideoAvailable;
+ (BOOL)isLibraryPhotoAvailable;
+ (BOOL)isLibraryVideoAvailable;

+ (instancetype)imagePickerForCameraPhotoEditable:(BOOL)editable;
+ (instancetype)imagePickerForCameraVideo;
+ (instancetype)imagePickerForLibraryPhotoEditable:(BOOL)editable;
+ (instancetype)imagePickerForLibraryVideo;

/**
 *  替代withBlockForDidFinishPickingMedia:
 */
- (instancetype)withBlockForDidFinishPickingMediaUsingFilePath:(EYImagePickerCompleteBlock)block;

@end
