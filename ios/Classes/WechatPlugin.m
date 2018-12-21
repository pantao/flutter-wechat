#import "WechatPlugin.h"

@implementation WechatPlugin {
  FlutterResult result;
}

- (instancetype)init {
  self = [super init];
  [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(handleOpenURL:)
    name:@"WeChat"
    object:nil
  ];
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"wechat"
            binaryMessenger:[registrar messenger]];
  WechatPlugin* instance = [[WechatPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary *arguments = [call arguments];
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  // Register app to Wechat with appid
  else if ([@"register" isEqualToString:call.method]) {
    [WXApi registerApp:arguments[@"appid"]];
    result(nil);
  }

  else if ([@"isWechatInstalled" isEqualToString:call.method]) {
    BOOL installed = [WXApi isWXAppInstalled];
    result([NSString stringWithFormat:@"%@", installed ? @"true" : @"false"]);
  }

  else if ([@"getApiVersion" isEqualToString:call.method]) {
    NSString *apiVersion = [WXApi getApiVersion];
    result([NSString stringWithFormat:@"%@", apiVersion]);
  }

  else if ([@"openWechat" isEqualToString:call.method]) {
    result(nil);
  }

  // Share something to Wechat
  else if ([@"share" isEqualToString:call.method]) {
    
    // What kind of things want to share
    NSString* kind = arguments[@"kind"];
    NSString* to = arguments[@"to"];
    
    // Wechat Message Request.
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    // Defaults request is not bText.
    request.bText = NO;
    // Share to wechat timeline.
    if ([@"timeline" isEqualToString:to]) {
      request.scene = WXSceneTimeline;
    }
    // Add to wechat favorites list.
    else if ([@"favorite" isEqualToString:to]) {
      request.scene = WXSceneFavorite;
    }
    // Defaults share to wechat session.
    else {
      request.scene = WXSceneSession;
    }

    // Sharing some text content
    if ([@"text" isEqualToString:kind]) {
      // Text content
      NSString *text = arguments[@"text"];
      request.text = text;
      request.bText = YES;
    }
    // Sharing an image
    else if ([@"image" isEqualToString:kind]) {
      // Image imageUrl
      NSString *resourceUrl = arguments[@"resourceUrl"];

      WXMediaMessage *mediaMessage = [WXMediaMessage message];
      WXImageObject *imageObject = [WXImageObject object];
      imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resourceUrl]];
      mediaMessage.mediaObject = imageObject;
  
      request.message = mediaMessage;
    }
    // Sharing music
    else if ([@"music" isEqualToString:kind]) {
      // music resource Url
      NSString *resourceUrl = arguments[@"resourceUrl"];
      // title of this music
      NSString *title = arguments[@"title"];
      // description of this music
      NSString *description = arguments[@"description"];
      // webpage url of this music
      NSString *url = arguments[@"url"];
      // cover Url of this music
      NSString *coverUrl = arguments[@"coverUrl"];
      NSData* coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];

      WXMusicObject *musicObject = [WXMusicObject object];
      musicObject.musicUrl = url;
      musicObject.musicDataUrl = resourceUrl;

      WXMediaMessage *mediaMessage = [WXMediaMessage message];
      mediaMessage.title = title;
      mediaMessage.description = description;
      [mediaMessage setThumbImage:[UIImage imageWithData:coverImageData]];
      mediaMessage.mediaObject = musicObject;

      request.message = mediaMessage;
    }
    // Sharing video
    else if ([@"video" isEqualToString:kind]) {
      NSString *resourceUrl = arguments[@"resourceUrl"];
      NSString *coverUrl = arguments[@"coverUrl"];
      // NSString *url = arguments[@"url"];
      NSString *title = arguments[@"title"];
      NSString *description = arguments[@"description"];

      NSData* coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];

      WXVideoObject *mediaObject = [WXVideoObject object];
      mediaObject.videoUrl = resourceUrl;

      WXMediaMessage *mediaMessage = [WXMediaMessage message];
      mediaMessage.title = title;
      mediaMessage.description = description;
      mediaMessage.mediaObject = mediaObject;
      [mediaMessage setThumbImage:[UIImage imageWithData:coverImageData]];

      request.message = mediaMessage;
    }
    // Sharing webpage
    else if ([@"webpage" isEqualToString:kind]) {
      NSString *coverUrl = arguments[@"coverUrl"];
      NSString *url = arguments[@"url"];
      NSString *title = arguments[@"title"];
      NSString *description = arguments[@"description"];

      NSData* coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];

      WXWebpageObject *mediaObject = [WXWebpageObject object];
      mediaObject.webpageUrl = url;

      WXMediaMessage *mediaMessage = [WXMediaMessage message];
      mediaMessage.title = title;
      mediaMessage.description = description;
      mediaMessage.mediaObject = mediaObject;
      [mediaMessage setThumbImage:[UIImage imageWithData:coverImageData]];

      request.message = mediaMessage;
    }
    [WXApi sendReq:request];
  }

  // Login via wechat
  else if ([@"login" isEqualToString:call.method]) {
    NSString* scope= arguments[@"scope"];
    NSString* state= arguments[@"state"];
    SendAuthReq *request = [[SendAuthReq alloc] init];
    request.scope = scope;
    request.state = state;

    [WXApi sendReq:request];
  }

  // Pay via wechat
  else if ([@"pay" isEqualToString:call.method]) {
    NSString *partnerId = arguments[@"partnerId"];
    NSString *prepayId = arguments[@"prepayId"];
    NSString *package = arguments[@"package"];
    NSString *nonceStr = arguments[@"nonceStr"];
    NSString *timestamp= arguments[@"timestamp"];
    NSString *sign= arguments[@"sign"];

    PayReq *request = [[PayReq alloc] init];
    request.partnerId = partnerId;
    request.prepayId = prepayId;
    request.package = package;
    request.nonceStr = nonceStr;
    request.timeStamp = [timestamp intValue];
    request.sign = sign;

    [WXApi sendReq:request];
  }

  else {
    result(FlutterMethodNotImplemented);
  }
}

-(BOOL)handleOpenURL:(NSNotification *)notification {
  NSString * urlString =  [notification userInfo][@"url"];
  NSURL * url = [NSURL URLWithString:urlString];
  if ([WXApi handleOpenURL:url delegate:self]) {
    return YES;
  }
  else {
    return NO;
  }
}

-(void) onResp:(BaseResp*)resp {
  if([resp isKindOfClass:[SendMessageToWXResp class]]) {
    result([NSString stringWithFormat:@"%d",resp.errCode]);
  }
  else if ([resp isKindOfClass:[SendAuthResp class]]) {
    SendAuthResp *r = (SendAuthResp *)resp;
    if (r.errCode == WXSuccess) {
      result(r.code);
    }
    else {
      result([NSString stringWithFormat:@"%d",r.errCode]);
    }
  }
  else if ([resp isKindOfClass:[PayResp class]]) {
    result([NSString stringWithFormat:@"%d",resp.errCode]);
  }
}

@end
