//
//  LocationDAO.m
//
//  Created by SANDY on 06/02/14.
//
//

#import "LocationDAO.h"

@implementation LocationDAO

@synthesize location_id,name,address,location;



+ (instancetype)sharedLocDAO{
    static LocationDAO *_sharedLocDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocDAO = [[LocationDAO alloc] init];
    });
    return _sharedLocDAO;
}

- (id)initWithAttributes:(NSDictionary *)attributes{

    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.location_id = [[attributes valueForKeyPath:@"location_id"] intValue];
    
    self.name=[attributes valueForKeyPath:@"name"];
    
    self.address=[attributes valueForKeyPath:@"address"];
    
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.location_id = [[coder decodeObjectForKey:@"location_id"] intValue];;
		self.name  = [coder decodeObjectForKey:@"name"];
        self.address  = [coder decodeObjectForKey:@"address"];        
    }
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:location_id forKey:@"location_id"];
    [coder encodeObject:name forKey:@"name"];
	[coder encodeObject:address forKey:@"address"];
}

- (id)initWithAttributesFromDB:(NSDictionary *)attributes{
    
    self = [super init];
    if (!self) {
        return nil;
    }
        
    self.location_id = [[attributes valueForKeyPath:@"_id"] intValue];
    
    self.name=[attributes valueForKeyPath:@"name"];
    
    self.address=[attributes valueForKeyPath:@"address"];
    
    CLLocationCoordinate2D loc;
    
    loc.latitude=[[attributes valueForKeyPath:@"latitude"] doubleValue];
    loc.longitude=[[attributes valueForKeyPath:@"longitude"] doubleValue];
    self.location=loc;
    
    return self;
}

-(NSArray *) getAllMyLocationsFromDB{
    @try {
        
        NSMutableArray *locationsArray=[[NSMutableArray alloc] init];
        
        NSString *sql=[NSString stringWithFormat:@"select * from MyLocations"];
        FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:sql];
        while ([rs next]) {
            LocationDAO *obj=[[LocationDAO alloc] initWithAttributesFromDB:[rs resultDictionary]];
            [locationsArray addObject:obj];
        }
        [rs close];
        
        return locationsArray;
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@ ",exception);
    }
}
-(void)deletePlaceFromDatabase:(int)theID{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM MyLocations where _id=%d ",theID];
    
    FMResultSet *rs=[[MouveDB sharedDB].db executeQuery:sql];
    
}

-(BOOL) addLocation:(LocationDAO *) obj{
    //CREATE TABLE "MyLocations" ("_id" TEXT, "name" TEXT, "address" TEXT, "latitude" TEXT, "longitude" TEXT )
    NSString *sql=[NSString stringWithFormat:@"insert into MyLocations (_id,name,address,latitude,longitude) values (%d, '%@', '%@', '%f','%f')",[self getLatestID],obj.name,obj.address,obj.location.latitude,obj.location.longitude];
    return [[MouveDB sharedDB].db executeUpdate:sql];
}


-(int) getLatestID{
    @try {
       
        NSString *sql=[NSString stringWithFormat:@"select max(_id) as maxCount from MyLocations"];
        FMResultSet *rs = [[MouveDB sharedDB].db executeQuery:sql];
        while ([rs next]) {
            return [rs intForColumn:@"maxCount"]+1;
        }
        [rs close];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@ ",exception);
    }
}

-(void)updateLocation:(LocationDAO *)object{
    @try {
        
        NSString *sql=[NSString stringWithFormat:@"UPDATE MyLocations SET name='%@', address='%@'  where _id='%d'",object.name,object.address,object.location_id];
        [[MouveDB sharedDB].db executeUpdate:sql];
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@ ",exception);
    }

}

-(BOOL) deleteLocation:(LocationDAO *) obj{
    @try {
        
        NSString *sql=[NSString stringWithFormat:@"delete from MyLocations where _id='%d'",obj.location_id];        
        [[MouveDB sharedDB].db executeUpdate:sql];
       
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@ ",exception);
         return FALSE;
    }
    return TRUE;
}




@end
