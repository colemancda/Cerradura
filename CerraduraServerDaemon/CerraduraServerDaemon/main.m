//
//  main.m
//  CerraduraServerDaemon
//
//  Created by Alsey Coleman Miller on 4/11/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreCerraduraServer;

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {

        NSLog(@"Starting Cerradura Server Daemon...");
        
        [CerraduraServer startServer];
    }
    
    [[NSRunLoop currentRunLoop] run];
    
    return 0;
}
