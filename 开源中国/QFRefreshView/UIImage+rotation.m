//
//  UIImage+rotation.m
//  EGODemo
//
//  Created by LZXuan on 15/4/5.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "UIImage+rotation.h"

@implementation UIImage (rotation)

- (UIImage *)rotation:(CGFloat)degree {
    CGSize rotatedSize = self.size;
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, rotatedSize.width / 2, rotatedSize.height / 2);
    CGContextRotateCTM(ctx, degree*M_PI/180);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
