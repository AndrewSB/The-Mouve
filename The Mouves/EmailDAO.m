//
//  EmailDAO.m
//  
//
//  Created by  on 31/01/14.
//
//

#import "EmailDAO.h"

@implementation EmailDAO

@synthesize ID,address_id,type,email,isSelected;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.ID = [[attributes valueForKeyPath:@"id"] integerValue];
    
    self.address_id=[attributes valueForKeyPath:@"address_id"];
    
    self.type=[attributes valueForKeyPath:@"type"];
    
    self.email=[attributes valueForKeyPath:@"email_text"];
    
    return self;
}


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {      
        
        self.ID = [coder decodeIntForKey:@"ID"];
		self.address_id  = [coder decodeObjectForKey:@"address_id"];
        self.type  = [coder decodeObjectForKey:@"type"];
		self.email  = [coder decodeObjectForKey:@"email"];
		self.isSelected  = [coder decodeBoolForKey:@"isSelected"];
    }
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:ID forKey:@"ID"];
    [coder encodeObject:address_id forKey:@"address_id"];
	[coder encodeObject:type forKey:@"type"];
    [coder encodeObject:email forKey:@"email"];
    [coder encodeBool:isSelected forKey:@"isSelected"];
}


@end
