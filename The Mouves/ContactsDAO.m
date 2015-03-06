//
//  ContactsDAO.m
//
//
//  Created by  on 28/03/14.
//
//

#import "ContactsDAO.h"

@implementation ContactsDAO
@synthesize _id,UserName,name,gender,DOB,imageURL,phones,emails,type,userImage,isSelected;

+ (instancetype)sharedContactsDAO{
    static ContactsDAO *_sharedContactsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContactsDAO = [[ContactsDAO alloc] init];
    });
    return _sharedContactsDAO;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self._id = [attributes valueForKeyPath:@"_id"];
    
    if([attributes objectForKey:@"name"] != [NSNull null]){
        self.name=[attributes valueForKeyPath:@"name"];
        self.UserName=[attributes valueForKeyPath:@"name"];
    }else{
        self.name=@"";
        self.UserName=@"";
    }
    self.type=[attributes valueForKeyPath:@"type"];
    
    self.gender=[attributes valueForKeyPath:@"gender"];
    
    self.DOB=[attributes valueForKeyPath:@"DOB"];
    
    self.imageURL=[attributes valueForKeyPath:@"imageURL"];
    
    if([attributes valueForKeyPath:@"Phone"] != [NSNull null]){
        self.phones=[attributes valueForKeyPath:@"Phone"];
    }else{
        self.phones=nil;
    }
    
    if([attributes valueForKeyPath:@"email"] != [NSNull null]){
        self.emails=[attributes valueForKeyPath:@"email"];
    }else{
        self.emails=nil;
    }
    
    return self;
}


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self._id = [coder decodeObjectForKey:@"_id"];
		self.name  = [coder decodeObjectForKey:@"name"];
        self.gender  = [coder decodeObjectForKey:@"gender"];
		self.DOB  = [coder decodeObjectForKey:@"DOB"];
		self.imageURL  = [coder decodeObjectForKey:@"imageURL"];
		self.phones  = [coder decodeObjectForKey:@"phones"];
		self.emails  = [coder decodeObjectForKey:@"emails"];
		self.type  = [coder decodeObjectForKey:@"type"];
        self.userImage= [coder decodeObjectForKey:@"userImage"];
        self.UserName= [coder decodeObjectForKey:@"UserName"];
    }
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:@"_id"];
    [coder encodeObject:name forKey:@"name"];
     [coder encodeObject:UserName forKey:@"UserName"];
	[coder encodeObject:gender forKey:@"gender"];
    [coder encodeObject:DOB forKey:@"DOB"];
	[coder encodeObject:imageURL forKey:@"imageURL"];
    [coder encodeObject:phones forKey:@"phones"];
	[coder encodeObject:emails forKey:@"emails"];
    [coder encodeObject:type forKey:@"type"];
    [coder encodeObject:userImage forKey:@"userImage"];
    
}

-(BOOL)getAccessPermission{
    __block BOOL result=FALSE;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                ABAddressBookRef addressBook;
                CFErrorRef error = nil;
                addressBook = ABAddressBookCreateWithOptions(NULL,&error);
                [self AddressBookUpdated:addressBook];
                result =FALSE;
            } else {
                result =FALSE;
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        result =TRUE;
    }
    else {
        result =FALSE;
    }
    return result;
}


- (void)syncPersonOutOfAddressBook
{
   // [NSThread detachNewThreadSelector:@selector(syncContactsThread) toTarget:self withObject:nil];
    [self syncContactsThread];
}

-(void)syncContactsThread{
    if([self getAccessPermission]){
        ABAddressBookRef addressBook;
        CFErrorRef error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        [self AddressBookUpdated:addressBook];
    }
    
}

-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}

-(NSString *)getProperString:(NSString *)str{
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"_$!<>!$"];
    return [str stringByTrimmingCharactersInSet:chs];
}

-(void) AddressBookUpdated:(ABAddressBookRef) addressBook {
    
    // Get user all Contacts.
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    [userDefault  setObject:@"yes" forKey:@"synch"];
    
    [userDefault  synchronize];
   
    NSMutableArray *address_Array=[[NSMutableArray alloc] init];
    
    if (addressBook != nil) {
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for (int k = 0; k < [allContacts count]; k++)
        {
            ContactsDAO *obj=[[ContactsDAO alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[k];
            
            int address_index=[[NSNumber numberWithInt:ABRecordGetRecordID(contactPerson)]  intValue];
            
            obj._id=[NSString stringWithFormat:@"%d",address_index];
            
            obj.name=@"";
            
            NSString *fName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,                                                                     kABPersonFirstNameProperty);
            
            NSString *lName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            if(lName==NULL){
                lName=@"";
            }
            
            if(fName==NULL){
                fName=@"";
            }
            
            obj.name=[NSString stringWithFormat:@"%@ %@",fName,lName];
            
            if(fName.length==0 && lName.length==0){
                NSString *company = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonOrganizationProperty);
                NSLog(@"Company Name  - %@ ",company);
                if(company.length==0){
                    obj.name=@"Unknown";
                }else{
                    obj.name=company;
                }
            }
            
            
            NSRange range = [obj.name rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
            obj.name = [obj.name stringByReplacingCharactersInRange:range withString:@""];
            
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            NSMutableArray *phones_array=[[NSMutableArray alloc] init];
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                PhoneDAO *phone_obj=[[PhoneDAO alloc] init];
                phone_obj.ID=i+1;
                phone_obj.address_id=obj._id;
                NSString *phoneLabel = (__bridge_transfer NSString *) ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
                phone_obj.type=[self getProperString:phoneLabel];
                phone_obj.number = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                
                NSString *phoneNumber=phone_obj.number;
                
                BOOL isphoneContainsPlus=FALSE;
                if ([phoneNumber rangeOfString:@"+"].location != NSNotFound) {
                    isphoneContainsPlus=TRUE;
                }
                
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
                
                if(isphoneContainsPlus){
                    phone_obj.number =[NSString stringWithFormat:@"+%@",phoneNumber];
                }else{
                    phone_obj.number =phoneNumber;
                }
                
                phone_obj.photoUrl=@"";
                
                [phones_array addObject:phone_obj];
            }
            obj.phones=[phones_array copy];
            
            ABMultiValueRef emails_ref = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            NSMutableArray *email_array=[[NSMutableArray alloc] init];
            for (CFIndex j = 0; j < ABMultiValueGetCount(emails_ref); j++) {
                EmailDAO *email_obj=[[EmailDAO alloc] init];
                email_obj.ID=j+1;
                email_obj.address_id=obj._id;
                NSString *emailLabel = (__bridge_transfer NSString *) ABMultiValueCopyLabelAtIndex(emails_ref, j);
                email_obj.type=[self getProperString:emailLabel];
                email_obj.email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails_ref, j);
                [email_array addObject:email_obj];
            }
            obj.emails=[email_array copy];
            
            obj.type=@"device";
            
            obj.gender=@"Male";
            
            CFTypeRef bDayProperty = ABRecordCopyValue((ABRecordRef)contactPerson, kABPersonBirthdayProperty);
            
            if (ABRecordCopyValue((ABRecordRef)contactPerson, kABPersonBirthdayProperty))
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                [formatter setTimeStyle:NSDateFormatterNoStyle];
                NSDate *date=(__bridge NSDate *)bDayProperty;
                NSString *result = [formatter stringFromDate:date];
                obj.DOB=result;
            }else{
                obj.DOB=@"10/10/1990";
            }
            
            obj.imageURL=@"";
            
            UIImage *img ;
            
            if (contactPerson != nil && ABPersonHasImageData(contactPerson)) {
                img= [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail)];
            } else {
                img= [UIImage imageNamed:@"user_big.png"];
            }
            
            obj.userImage=img;
            
            
            if([obj.phones count]>0 ){
                [address_Array addObject:obj];
            }
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:ALL_CONTACTS_SYNC
         object:address_Array];       
        
    } else {
        NSLog(@"Error reading Address Book");
    }
};




        
        







@end
