//
//  Utilities.m
//  FinalProject
//
//  Created by KshirasagarS on 12/12/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (UIColor *)colorWithRGBA:(NSUInteger)color
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}
@end
