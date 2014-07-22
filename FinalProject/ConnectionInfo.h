//
//  ConnectionInfo.h
//  FinalProject
//
//  Created by KshirasagarS on 11/25/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionInfo : NSObject
{
    NSString *finalPiece;
    NSString *ip;
    NSString *ht;
    NSString *serverhome;
    NSURL *url;
    NSMutableURLRequest *request;
    
}
-(id) initWithFinalPiece: (NSString *)theFinalPiece;
-(NSMutableURLRequest *) getMeTheRequestObject;
@end
