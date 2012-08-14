//
// Created by admin_aob on 14/08/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface APServiceBox : NSObject

- (void)registerDependency:(NSObject *)dependency as:(NSString *)name;
- (int)fill:(NSObject *)target;

@end