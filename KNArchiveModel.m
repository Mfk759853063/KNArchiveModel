//
//  KNArchiveModel.m
//  KNProjectTemplete
//
//  Created by kwep_vbn on 16/2/26.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "KNArchiveModel.h"
#import "objc/runtime.h"

@implementation KNArchiveModel

+ (NSArray<NSString *> *)kn_ignoredCodingPropertyNames {
    return @[];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    NSArray *ignoreArray = [[self class] kn_ignoredCodingPropertyNames];
    KNArchiveModel *model = [[self class] new];
    unsigned int count;
    Ivar *varList = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = varList[i];
        const char *name = ivar_getName(var);
        NSString *utf8Name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([[utf8Name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            utf8Name = [utf8Name substringFromIndex:1];
        }
        if ([ignoreArray containsObject:utf8Name]) {
            continue;
        }
        id value = [self valueForKey:utf8Name];
        if ([value isKindOfClass:[KNArchiveModel class]]) {
              value = [value mutableCopyWithZone:zone];
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = @[].mutableCopy;
            [value enumerateObjectsUsingBlock:^(KNArchiveModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[obj mutableCopyWithZone:zone]];
            }];
            value = array;
        }
        [model setValue:(id)value forKey:utf8Name];
    }
    
    free(varList);
    return model;
}


- (id)mutableCopy {
    return [self mutableCopyWithZone:NULL];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        Class superCls = class_getSuperclass([self class]);
        while (superCls != [NSObject class]) {
            [self decoderPropertyFromClass:superCls coder:aDecoder];
            superCls = class_getSuperclass(superCls);
        }
        [self decoderPropertyFromClass:[self class] coder:aDecoder];
    }
    return self;
}

- (void)decoderPropertyFromClass:(Class)cls coder:(NSCoder *)aDecoder {
    
    unsigned int count;
    Ivar *varList = class_copyIvarList(cls, &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = varList[i];
        const char *name = ivar_getName(var);
        NSString *utf8Name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([[utf8Name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            utf8Name = [utf8Name substringFromIndex:1];
        }
        id value = [aDecoder decodeObjectForKey:utf8Name];
        if (value) {
            [self setValue:value forKey:utf8Name];
        }
        
    }
    free(varList);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    Class superCls = class_getSuperclass([self class]);
    while (superCls != [NSObject class]) {
        NSArray *ignorePropertys = [superCls kn_ignoredCodingPropertyNames];
        [self encoderPropertyFromClass:superCls coder:aCoder ignorePropertys:ignorePropertys];
        superCls = class_getSuperclass(superCls);
    }
    NSArray *ignorePropertys = [[self class] kn_ignoredCodingPropertyNames];
    [self encoderPropertyFromClass:[self class] coder:aCoder ignorePropertys:ignorePropertys];
    
}

- (void)encoderPropertyFromClass:(Class)cls coder:(NSCoder *)aCoder ignorePropertys:(NSArray *)ignorePropertys{
    
    unsigned int count;
    Ivar *varList = class_copyIvarList(cls, &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = varList[i];
        const char *name = ivar_getName(var);
        NSString *utf8Name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([[utf8Name substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
            utf8Name = [utf8Name substringFromIndex:1];
        }
        if ([ignorePropertys containsObject:utf8Name]) {
            return;
        }
        id value = [self valueForKey:utf8Name];
        if (value) {
            [aCoder encodeObject:value forKey:utf8Name];
        }
    }
    free(varList);
}

- (NSString *)description {
    NSString *des = @"";
    unsigned int count;
    Ivar *varList = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = varList[i];
        const char *name = ivar_getName(var);
        NSString *utf8Name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:utf8Name];
        des = [des stringByAppendingString:[NSString stringWithFormat:@"%@:%@\t\n",utf8Name,value]];
    }
    free(varList);
    return des;
}

@end
