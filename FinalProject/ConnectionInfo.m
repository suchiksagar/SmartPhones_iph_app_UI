//
//  ConnectionInfo.m
//  FinalProject
//
//  Created by KshirasagarS on 11/25/13.
//  Copyright (c) 2013 Sucharith Kshirasagar. All rights reserved.
//

#import "ConnectionInfo.h"

@implementation ConnectionInfo

-(id)initWithFinalPiece:(NSString *)theFinalPiece
{
    if( self=[super init])
    {
        finalPiece=theFinalPiece;
        ht=@"http://";
        ip=@"BOS-CD2Z3R1";
        serverhome=@":8080/smartphones/";
        NSString *urlString= [NSString stringWithFormat:@"%@%@%@%@",ht,ip,serverhome,finalPiece];
        NSLog(@"%@",urlString);
        url= [NSURL URLWithString:urlString];
        request= [NSMutableURLRequest requestWithURL:url];
        NSLog(@"URL REQUEST CREATED");
        return self;
    }
}

-(NSMutableURLRequest *) getMeTheRequestObject
{
    return request;
}  

@end
