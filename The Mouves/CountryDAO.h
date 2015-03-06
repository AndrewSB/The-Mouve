//
//  CountryDAO.h
//  PartyApp
//
//  Created by SANDY on 30/01/14.
//
//

#import <Foundation/Foundation.h>
#import "MouveDB.h"

@interface CountryDAO : NSObject

@property int ID;
@property (nonatomic, strong) NSString *iso;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nicename;
@property (nonatomic, strong) NSString *iso3;
@property (nonatomic, strong) NSString *numcode;
@property (nonatomic, strong) NSString *phonecode;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (NSArray *)getCountryData;
- (CountryDAO *)isCountryCodePresent:(NSString *)code;
- (CountryDAO *)getMyCountry;
- (CountryDAO *)getRandomCountry;

@end
