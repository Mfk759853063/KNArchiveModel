//
//  KNArchiveModel.h
//  KNProjectTemplete
//
//  Created by kwep_vbn on 16/2/26.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNArchiveModel : NSObject<NSCoding>

/**
 *  此Array包含的属性不加入归档
 *
 */
+ (NSArray<NSString *> *)kn_ignoredCodingPropertyNames;

@end
