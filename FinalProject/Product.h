//
//  Product.h
//  FinalProject
//
//  Created by KshirasagarS on 12/3/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
    int availability;
    NSString *productName;
    double productPrice;
    long storeZip;
    int productId;
    NSString *storeName;
}
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *storeName;
@property(readwrite) int availability;
@property(readwrite) double productPrice;
@property(readwrite) long storeZip;
@property(readwrite) int productId;
@end
