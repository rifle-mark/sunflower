//
//  EYImagePickerViewController.m
//  IPSShelf
//
//  Created by zhoujinqiang on 15/3/26.
//  Copyright (c) 2015年 zhoujinqiang. All rights reserved.
//

#import "EYImagePickerViewController.h"
#import "GCExtension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface EYImagePickerViewController ()

@end

@implementation EYImagePickerViewController

+ (BOOL)isCameraPhotoAvailable {
    NSArray* types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    return [types containsObject:(__bridge NSString *)kUTTypeImage];
}
+ (BOOL)isCameraVideoAvailable {
    NSArray* types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    return [types containsObject:(__bridge NSString *)kUTTypeMovie];
}
+ (BOOL)isLibraryPhotoAvailable {
    NSArray* types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return [types containsObject:(__bridge NSString *)kUTTypeImage];
}
+ (BOOL)isLibraryVideoAvailable {
    NSArray* types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return [types containsObject:(__bridge NSString *)kUTTypeMovie];
}

+ (instancetype)imagePickerForCameraPhotoEditable:(BOOL)editable {
    EYImagePickerViewController* picker = [[EYImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    picker.allowsEditing = editable;
    return picker;
}
+ (instancetype)imagePickerForCameraVideo {
    EYImagePickerViewController* picker = [[EYImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(__bridge NSString *)kUTTypeMovie];
    picker.videoMaximumDuration = 10;
    return picker;
}
+ (instancetype)imagePickerForLibraryPhotoEditable:(BOOL)editable {
    EYImagePickerViewController* picker = [[EYImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    picker.allowsEditing = editable;
    return picker;
}
+ (instancetype)imagePickerForLibraryVideo {
    EYImagePickerViewController* picker = [[EYImagePickerViewController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(__bridge NSString *)kUTTypeMovie];
    picker.videoMaximumDuration = 10;
    return picker;
}

- (instancetype)withBlockForDidFinishPickingMediaUsingFilePath:(EYImagePickerCompleteBlock)block {
    [self withBlockForDidFinishPickingMedia:^(UIImagePickerController *picker, NSDictionary *info) {
        NSString* type = info[UIImagePickerControllerMediaType];
        if ([type isEqual:(__bridge NSString *)kUTTypeMovie]) {
            
            NSURL* path = info[UIImagePickerControllerMediaURL];
            block((EYImagePickerViewController *)picker, nil, [path isFileURL]?[path path]:[path absoluteString]);
        }
        else if ([type isEqual:(__bridge NSString *)kUTTypeImage]) {
            UIImage *img = nil;
            if (picker.allowsEditing) {
                img = info[UIImagePickerControllerEditedImage];
            }
            else {
                img = info[UIImagePickerControllerOriginalImage];
            }
            NSData* tmp = UIImageJPEGRepresentation(img, 1.f);
            NSDate* now = [NSDate date];
            NSString* key = [NSString stringWithFormat:@"%lld_%d.jpg", (int64_t)[now timeIntervalSince1970], (int)(arc4random() % 1000)];
            NSString* path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),key];
            [tmp writeToFile:path atomically:NO];
            block((EYImagePickerViewController *)picker, img, path);
        }
        else {
            NSAssert(NO, @"不支持的类型");
        }
    }];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _weak(self);
        [self withBlockForDidCancel:^(UIImagePickerController *picker) {
            _strong(self);
            GCBlockInvoke(self.dismissBlock, nil);
        }];
    }
    return self;
}

@end
