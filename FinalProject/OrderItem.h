//
//  OrderItem.h
//  FinalProject
//
//  Created by KshirasagarS on 12/4/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject <NSCoding>
{
    int productId;
    int quantity;
    double orderItemPrice;
    long storeZip;
    NSString *productName;
    NSString *storeName;
    Boolean scannedFlag;
}
@property(readwrite) int productId;
@property(readwrite) int quantity;
@property(readwrite) double orderItemPrice;
@property(readwrite) long storeZip;
@property(retain,nonatomic) NSString *productName;
@property(retain,nonatomic) NSString *storeName;
@property(readwrite) Boolean scannedFlag;

- (void) encodeWithCoder : (NSCoder *)coder;

- (id) initWithCoder: (NSCoder *) coder ;
@end
