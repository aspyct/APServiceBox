/*
 * Copyright (c) 2012 Antoine d'Otreppe <a.dotreppe@aspyct.org>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <objc/runtime.h>

#import "APServiceBox.h"

static char *get_prop_type(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    const char *start;
    int len = strlen(attributes);
    
    // Ok, let's get over it
    if (len >= 3 && attributes[0] == 'T' && attributes[1] == '@' && attributes[2] == '"') {
        // Find the ','
        start = attributes + 3;
        char *end = strchr(start, '"');
        
        if (end) {
            char *type = malloc((end - start) * sizeof(char) + 1);
            strncpy(type, start, end - start);
            type[end - start] = '\0';
            
            return type;
        }
        else {
            return "";
        }
    }
    else {
        return "";
    }
}

@implementation APServiceBox {
    NSMutableDictionary *_dependencies;
    BOOL _initialized;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _dependencies = [[NSMutableDictionary alloc] initWithCapacity:5];
        [_dependencies setObject:self forKey:@"serviceBox"];
        _initialized = NO;
    }
    
    return self;
}

- (void)registerDependency:(NSObject *)dependency as:(NSString *)name
{
    [_dependencies setObject:dependency forKey:name];
}

- (BOOL)propertyType:(NSString *)propType matchesWithDependency:(NSObject *)dependency
{
    if ([propType characterAtIndex:0] == '<') {
        // Matching against a protocol
        
        NSString *protocolName = [propType substringWithRange:NSMakeRange(1, propType.length - 2)];
        Protocol *protocol = NSProtocolFromString(protocolName);
        return [dependency.class conformsToProtocol:protocol];
    }
    else {
        // Matching against a class
        Class propertyClass = NSClassFromString(propType);
        return [dependency isKindOfClass:propertyClass];
    }
}

- (void)injectInto:(NSObject *)target property:(char const *)property dependency:(NSObject *)dependency
{
    // Capitalize the first letter of the propName
    char uppercaseProp[strlen(property) + 1];
    strcpy(uppercaseProp, property);
    uppercaseProp[0] += 'A' - 'a';
    
    NSString *selName = [NSString stringWithFormat:@"set%s:", uppercaseProp];
    SEL setter = NSSelectorFromString(selName);
    if ([target respondsToSelector:setter]) {
        // The warning that comes here can be safely ignored, as nothing should be returned from a setter
        [target performSelector:setter withObject:dependency];
    }
}

- (void)injectInto:(NSObject *)target forClass:(Class)class
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        
        if(propName) {
            // Lookup the dependency
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSObject *dependency = [_dependencies objectForKey:propertyName];
            
            if (dependency != nil) {
                char *propType = get_prop_type(property);
                NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
                if ([self propertyType:propertyType matchesWithDependency:dependency]) {
                    [self injectInto:target property:propName dependency:dependency];
                }
            }
        }
    }
    free(properties);
}

- (int)fill:(NSObject *)target
{
    [self initialize];
    
    Class class = target.class;
    do {
        [self injectInto:target forClass:class];
        class = class_getSuperclass(class);
    } while (class != nil);
    
    return 0;
}

- (void)initialize
{
    @synchronized(self) {
        if (_initialized) {
            return;
        }
        else {
            _initialized = YES;
        }
    }
    
    NSEnumerator *enumerator = [_dependencies objectEnumerator];
    // Inject the dependencies into the other ones
    for (NSObject *dependency in enumerator) {
        [self fill:dependency];
    }
}

@end