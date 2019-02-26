//
//  WebSocketHander.m
//  WeexBox
//
//  Created by Mario on 2019/2/25.
//  Copyright © 2019 Ayg. All rights reserved.
//

#import "WebSocketHander.h"
#import "SRWebSocket+Weex.h"

@implementation WebSocketHander
{
    NSMutableDictionary<NSString *, SRWebSocket *> *_webSockets;
}

#pragma mark - WXWebSocketHandler
- (void)open:(NSString *)url protocol:(NSString *)protocol identifier:(NSString *)identifier withDelegate:(id<WXWebSocketDelegate>)delegate
{
    if(!_webSockets)
    {
        _webSockets = [NSMutableDictionary new];
    }
    if([_webSockets objectForKey:identifier]){
        SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
        webSocket.delegate = nil;
        [webSocket close];
        
    }
    NSArray *protols;
    if([protocol length]>0){
        protols = [NSArray arrayWithObject:protocol];
    }
    SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url] protocols:protols];
    webSocket.delegate = self;
    [webSocket open];
    webSocket.wx_Identifier = identifier;
    webSocket.wx_WebSocketDelegate = delegate;
    [_webSockets setObject:webSocket forKey:identifier];
}

- (void)send:(id)identifier data:(NSString *)data
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket send:data];
    }
}

- (void)close:(NSString *)identifier
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket close];
    }
}

- (void)close:(NSString *)identifier code:(NSInteger)code reason:(NSString *)reason
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket closeWithCode:code reason:reason];
    }
}

- (void)clear:(NSString *)identifier
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        webSocket.delegate = nil;
        [webSocket close];
        [_webSockets removeObjectForKey:identifier];
    }
}

#pragma mark -SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    if (webSocket.wx_WebSocketDelegate && [webSocket.wx_WebSocketDelegate respondsToSelector:@selector(didOpen)]) {
        [webSocket.wx_WebSocketDelegate didOpen];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    if (webSocket.wx_WebSocketDelegate && [webSocket.wx_WebSocketDelegate respondsToSelector:@selector(didFailWithError:)]) {
        [webSocket.wx_WebSocketDelegate didFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    if (webSocket.wx_WebSocketDelegate && [webSocket.wx_WebSocketDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [webSocket.wx_WebSocketDelegate didReceiveMessage:message];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    if (webSocket.wx_WebSocketDelegate && [webSocket.wx_WebSocketDelegate respondsToSelector:@selector(didCloseWithCode:reason:wasClean:)]) {
        [webSocket.wx_WebSocketDelegate didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}
@end
