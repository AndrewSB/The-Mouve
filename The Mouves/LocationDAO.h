//
//  LocationDAO.h
//
//  Created by SANDY on 06/02/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MouveDB.h"

@interface LocationDAO : NSObject

@property int location_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property  CLLocationCoordinate2D location;

+ (instancetype)sharedLocDAO;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithAttributesFromDB:(NSDictionary *)attributes;
-(NSArray *) getAllMyLocationsFromDB;
-(BOOL) addLocation:(LocationDAO *) obj;
-(BOOL) deleteLocation:(LocationDAO *) obj;
-(void)updateLocation:(LocationDAO *)object;
@end
