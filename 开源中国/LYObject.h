//
//  LYObject.h
//  开源中国
//
//  Created by qianfeng01 on 15-4-25.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYObject : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
