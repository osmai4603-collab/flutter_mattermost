import 'package:injectable/injectable.dart';
import 'package:osm_network/osm_network.dart' as osm;

@lazySingleton
class ConnectivityMonitor extends osm.ConnectivityMonitor {}
