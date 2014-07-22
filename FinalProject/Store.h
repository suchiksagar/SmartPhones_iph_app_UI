//
//  Store.h
//  FinalProject
//
//  Created by KshirasagarS on 12/2/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject
{
    NSString *storeName;
    NSString *street;
    long zipcode;
    int storeId;
}

@property (nonatomic, strong, readwrite) NSString *storeName;
@property (nonatomic, strong, readwrite) NSString *street;
@property (readwrite) long zipcode;
@property (readwrite) int storeId;

@end
