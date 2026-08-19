import 'package:injectable/injectable.dart';
import 'package:osm_network/osm_network.dart' as osm;
export 'package:osm_network/osm_network.dart' show SessionEvent;

@singleton
class SessionController extends osm.SessionController {}
