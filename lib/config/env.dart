import 'constants.dart';

final dev = <String, dynamic>{
  'domain': apiDevServerDomain,
  'backend': apiDevFrontendURL,
  'frontend': apiDevFrontendURL,
  'isProduction': false
};

final sit = <String, dynamic>{
  'domain': apiSitServerDomain,
  'backend': apiSitFrontendURL,
  'frontend': 'apiSitFrontendURL',
  'isProduction': false
};

final uat = <String, dynamic>{
  'domain': apiUatServerDomain,
  'backend': apiUatFrontendURL,
  'frontend': apiUatFrontendURL,
  'isProduction': false
};

final stg = <String, dynamic>{
  'domain': apiStgServerDomain,
  'backend': apiStgFrontendURL,
  'frontend': apiStgFrontendURL,
  'isProduction': false
};

final prd = <String, dynamic>{
  'domain': apiPrdServerDomain,
  'backend': apiPrdFrontendURL,
  'frontend': apiPrdFrontendURL,
  'isProduction': true
};
