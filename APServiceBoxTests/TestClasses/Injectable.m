//
// Created by admin_aob on 14/08/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Injectable.h"


@implementation Injectable {
    Injectable *_manual;
}

- (Injectable *)manual
{
    return _manual;
}

- (void)setManual:(Injectable *)aManual
{
    _manual = aManual;
}

- (void)doNothing
{
}

@end