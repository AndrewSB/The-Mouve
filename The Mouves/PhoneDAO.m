//
//  PhoneDAO.m
//
//
//  Created by  on 31/01/14.
//
//

#import "PhoneDAO.h"

@implementation PhoneDAO
@synthesize ID,address_id,type,number,isSelected,photoUrl,country_code;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.ID = [[attributes valueForKeyPath:@"id"] integerValue];
    
    self.address_id=[attributes valueForKeyPath:@"address_id"];
    
    self.type=[attributes valueForKeyPath:@"type"];
    
    self.number=[attributes valueForKeyPath:@"phone_num"];    
    
    self.photoUrl=[attributes valueForKeyPath:@"photoUrl"] ;
    
    self.country_code=[attributes valueForKeyPath:@"country_code"] ;
    
   
       
    return self;
}


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.ID = [coder decodeIntForKey:@"ID"];
		self.address_id  = [coder decodeObjectForKey:@"address_id"];
        self.type  = [coder decodeObjectForKey:@"type"];
		self.number  = [coder decodeObjectForKey:@"number"];
		self.photoUrl  = [coder decodeObjectForKey:@"photoUrl"];
		self.isSelected  = [coder decodeBoolForKey:@"isSelected"];
       self.country_code= [coder decodeObjectForKey:@"country_code"];
        
    }
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:ID forKey:@"ID"];
    [coder encodeObject:address_id forKey:@"address_id"];
	[coder encodeObject:type forKey:@"type"];
    [coder encodeObject:number forKey:@"number"];
	[coder encodeObject:photoUrl forKey:@"photoUrl"];
    [coder encodeBool:isSelected forKey:@"isSelected"];
    [coder encodeObject:country_code forKey:@"country_code"];   
}

@end
