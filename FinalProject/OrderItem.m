//
//  OrderItem.m
//  FinalProject
//
//  Created by KshirasagarS on 12/4/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem
- (void) encodeWithCoder : (NSCoder *)coder //serialization
{
	
	[coder encodeInt32:self.productId forKey:@"productId"];
	[coder encodeInt32:self.quantity   forKey:@"quantity" ];
	[coder encodeDouble:self.orderItemPrice   forKey:@"orderItemPrice"];
	[coder encodeDouble:self.storeZip   forKey:@"storeZip" ];
    [coder encodeObject:self.productName forKey:@"productName"];
    [coder encodeObject:self.storeName forKey:@"storeName"];
    [coder encodeBool:self.scannedFlag forKey:@"scannedFlag"];
	
	// if It is int it is not object
	// Suppose u r writing priceess object, even priceess shud implement encoder and decoders
	
	
}
-	(id) initWithCoder: (NSCoder *) coder  // deserialization
{
	
	self.productId = [coder decodeInt32ForKey:@"productId"];
	self.quantity = [coder decodeInt32ForKey:@"quantity"];
	self.orderItemPrice = [coder decodeDoubleForKey:@"orderItemPrice"];
	self.storeZip = [coder decodeDoubleForKey:@"storeZip"];
    self.productName=[coder decodeObjectForKey:@"productName"];
    self.storeName=[coder decodeObjectForKey:@"storeName"];
    self.scannedFlag=[coder decodeBoolForKey:@"scannedFlag"];
    
    return self.init;
	//return [self initWithId:productId andQuantity:quantity  andOrderItemPrice:orderItemPrice andStoreZip:storeZip];
	
}

@end
