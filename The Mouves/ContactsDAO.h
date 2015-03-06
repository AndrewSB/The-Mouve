//
//  ContactsDAO.h
//
//  Created by  on 28/03/14.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "PhoneDAO.h"
#import "EmailDAO.h"
#import "AppDelegate.h"
#import "Constant.h"


@interface ContactsDAO : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *DOB;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic,strong) NSArray *phones;
@property (nonatomic,strong) NSArray *emails;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) UIImage *userImage;
@property BOOL isSelected;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)syncPersonOutOfAddressBook;
+ (instancetype)sharedContactsDAO;
-(BOOL)getAccessPermission;

@end
