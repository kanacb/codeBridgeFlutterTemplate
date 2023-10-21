import 'package:intl/intl.dart';

// server urls
const String apiDevServerDomain = 'http://localhost';
const String apiSitServerDomain = 'http://localhost';
const String apiUatServerDomain = 'http://localhost';
const String apiStgServerDomain = 'http://localhost';
const String apiPrdServerDomain = 'http://localhost';

const String apiDevServerURL = 'http://localhost:3030';
const String apiSitServerURL = 'http://localhost:3030';
const String apiUatServerURL = 'http://localhost:3030';
const String apiStgServerURL = 'http://localhost:3030';
const String apiPrdServerURL = 'http://localhost:3030';

const String apiDevFrontendURL = 'http://localhost:3000';
const String apiSitFrontendURL = 'http://localhost:3000';
const String apiUatFrontendURL = 'http://localhost:3000';
const String apiStgFrontendURL = 'http://localhost:3000';
const String apiPrdFrontendURL = 'http://localhost:3000';

// formats
DateFormat dateFormat = DateFormat('dd/MM/yyyy');
DateFormat timeFormat = DateFormat('dd/MM/yyyy');

//colors
const int colorPrimary = 0xfffdb834;
const int colorSecondary = 0xfffdb834;
const int colorWarning = 0xff1ba7df;
const int colorDanger = 0xffe70612;
const int colorError = 0xff47bfae;
const int colorHelp = 0xff823293;

// delays
const int delayAllowed = -30; // 30 minutes before the end of class
const int earlyAllowed = -40; // 15 minutes before the start of class

// websockets
const int wsPort = 6001;
const String ws = '3.0.78.168';
const String appKEY = 'app-key';
const String apiCLUSTER = 'mt1';
const String channelName = 'user-'; // private-user-{userId}
const String eventName = 'logout.user';
