//
//  SelfFilling.m
//  APServiceBox
//
//  Created by Antoine d'Otreppe on 31/08/12.
//  Copyright (c) 2012 Antoine d'Otreppe. All rights reserved.
//

#import "SelfFilling.h"
#import "Injectable.h"
#import "NSObject+APServiceBox.h"

@implementation SelfFilling

@synthesize injectable;

- (id)init
{
    self = [super init];
    
    if (self) {
        [self injectDependencies];
    }
    
    return self;
}

@end
