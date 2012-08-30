//
//  NSObject+APServiceBox.m
//  ManPad
//
//  Created by Antoine d'Otreppe on 31/08/12.
//  Copyright (c) 2012 Aspyct.org. All rights reserved.
//

#import "NSObject+APServiceBox.h"
#import "APServiceBox.h"

@implementation NSObject (APServiceBox)

- (void)fillWithDependencies {
    [[APServiceBox defaultBox] fill:self];
}

@end
