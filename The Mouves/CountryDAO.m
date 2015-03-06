//
//  CountryDAO.m
//
//  Created by SANDY on 30/01/14.
//
//

#import "CountryDAO.h"

@implementation CountryDAO
@synthesize ID,iso,name,nicename,iso3,numcode,phonecode;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.ID = [[attributes valueForKeyPath:@"id"] integerValue];
    if(![attributes valueForKeyPath:@"iso"]){
        self.iso=[attributes valueForKeyPath:@"iso"];
    }else{
        self.iso=@"";
    }
    self.name=[attributes valueForKeyPath:@"name"];
    self.nicename=[attributes valueForKeyPath:@"nicename"];
    
    if(![attributes valueForKeyPath:@"iso3"]){
        self.iso3=[attributes valueForKeyPath:@"iso3"];
    }else{
        self.iso3=@"";
    }
    
    self.numcode=[NSString stringWithFormat:@"%@",[attributes valueForKeyPath:@"numcode"]];
    self.phonecode=[NSString stringWithFormat:@"%@",[attributes valueForKeyPath:@"phonecode"]];
    return self;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
   
    return self;
}

- (NSArray *)getCountryData
{
    FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:@"select * from country"];
    NSMutableArray *countrys=[[NSMutableArray alloc] init];
    while ([rs next]) {
       // NSLog(@"Name:%@",rs[2]);
        CountryDAO *obj=[[CountryDAO alloc] initWithAttributes:[rs resultDictionary]];
        [countrys addObject:obj];
    }
    [rs close];
   [[MouveDB sharedDB].db hasOpenResultSets];
   [[MouveDB sharedDB].db hadError];
    return countrys;
}

- (CountryDAO *)isCountryCodePresent:(NSString *)code
{
    FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:[NSString stringWithFormat:@"select * from country where phonecode='%@'",code]];
    while ([rs next]) {
        
        return [self initWithAttributes:[rs resultDictionary]];
    }
    [rs close];
    [[MouveDB sharedDB].db hasOpenResultSets];
    [[MouveDB sharedDB].db hadError];
    return nil;
}

- (CountryDAO *)getRandomCountry
{
    FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:[NSString stringWithFormat:@"SELECT * FROM country                                                              ORDER BY RANDOM() LIMIT 1"]];
    while ([rs next]) {
        
        return [self initWithAttributes:[rs resultDictionary]];
    }
    [rs close];
    [[MouveDB sharedDB].db hasOpenResultSets];
    [[MouveDB sharedDB].db hadError];
    return nil;
}
- (CountryDAO *)getMyCountry
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];  
    
    FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:[NSString stringWithFormat:@"select * from country where iso='%@'",countryCode]];
    while ([rs next]) {
        
        return [self initWithAttributes:[rs resultDictionary]];
    }
    [rs close];
    [[MouveDB sharedDB].db hasOpenResultSets];
    [[MouveDB sharedDB].db hadError];
    return nil;
}

@end
