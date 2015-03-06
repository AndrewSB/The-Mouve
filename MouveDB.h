//
//  FMDB_MouveDB.h
//  fmdb
//
//  Created by Graham Dennis on 24/11/2013.
//
//

#import "FMDatabase.h"

@interface MouveDB : NSObject{

}

+ (instancetype)sharedDB;

@property FMDatabase *db;
@property FMDatabasePool *pool;
@property (readonly) NSString *databasePath;
- (BOOL)checkTableExists:(NSString *)tableName Type:(NSString *)chat;
@end
