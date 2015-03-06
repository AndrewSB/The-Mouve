//
//  PhoneDAO.h
//  
//
//  Created by  on 31/01/14.
//
//

#import <Foundation/Foundation.h>

@interface PhoneDAO : NSObject

@property int ID;
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *country_code;
@property (nonatomic, strong) NSString *photoUrl;
@property BOOL isSelected;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
