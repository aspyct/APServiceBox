//
// Created by admin_aob on 14/08/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "APServiceBox.h"

@protocol InjectableProtocol <NSObject>

@required
- (void)doNothing;

@end

@interface Injectable : NSObject <InjectableProtocol>

@property (strong, nonatomic) Injectable *synthesized;
@property (strong, nonatomic) Injectable *manual;
@property (strong, nonatomic) APServiceBox *serviceBox;
@property (strong, nonatomic) id<InjectableProtocol> proto;

@end