//
//  NSObject+APServiceBox.h
//  ManPad
//
//  Created by Antoine d'Otreppe on 31/08/12.
//  Copyright (c) 2012 Aspyct.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (APServiceBox)

- (void)injectDependencies;

- (void)fillWithDependencies __deprecated_msg("Use -[NSObject injectDependencies] instead.");

@end
