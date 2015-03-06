//
//  EmailDAO.h
//
//
//  Created by  on 31/01/14.
//
//

#import <Foundation/Foundation.h>

@interface EmailDAO : NSObject

@property int ID;
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *email;
@property BOOL isSelected;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
