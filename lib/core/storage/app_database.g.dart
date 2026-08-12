// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentUserIdMeta = const VerificationMeta(
    'currentUserId',
  );
  @override
  late final GeneratedColumn<String> currentUserId = GeneratedColumn<String>(
    'current_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, url, name, currentUserId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Server> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('current_user_id')) {
      context.handle(
        _currentUserIdMeta,
        currentUserId.isAcceptableOrUnknown(
          data['current_user_id']!,
          _currentUserIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currentUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_user_id'],
      ),
    );
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(attachedDatabase, alias);
  }
}

class Server extends DataClass implements Insertable<Server> {
  final String id;
  final String url;
  final String name;
  final String? currentUserId;
  const Server({
    required this.id,
    required this.url,
    required this.name,
    this.currentUserId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || currentUserId != null) {
      map['current_user_id'] = Variable<String>(currentUserId);
    }
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      url: Value(url),
      name: Value(name),
      currentUserId: currentUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentUserId),
    );
  }

  factory Server.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
      currentUserId: serializer.fromJson<String?>(json['currentUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
      'currentUserId': serializer.toJson<String?>(currentUserId),
    };
  }

  Server copyWith({
    String? id,
    String? url,
    String? name,
    Value<String?> currentUserId = const Value.absent(),
  }) => Server(
    id: id ?? this.id,
    url: url ?? this.url,
    name: name ?? this.name,
    currentUserId: currentUserId.present
        ? currentUserId.value
        : this.currentUserId,
  );
  Server copyWithCompanion(ServersCompanion data) {
    return Server(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      name: data.name.present ? data.name.value : this.name,
      currentUserId: data.currentUserId.present
          ? data.currentUserId.value
          : this.currentUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('currentUserId: $currentUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, name, currentUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.url == this.url &&
          other.name == this.name &&
          other.currentUserId == this.currentUserId);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<String> id;
  final Value<String> url;
  final Value<String> name;
  final Value<String?> currentUserId;
  final Value<int> rowid;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.name = const Value.absent(),
    this.currentUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServersCompanion.insert({
    required String id,
    required String url,
    required String name,
    this.currentUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       url = Value(url),
       name = Value(name);
  static Insertable<Server> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? name,
    Expression<String>? currentUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
      if (currentUserId != null) 'current_user_id': currentUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServersCompanion copyWith({
    Value<String>? id,
    Value<String>? url,
    Value<String>? name,
    Value<String?>? currentUserId,
    Value<int>? rowid,
  }) {
    return ServersCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      currentUserId: currentUserId ?? this.currentUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currentUserId.present) {
      map['current_user_id'] = Variable<String>(currentUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('currentUserId: $currentUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedUsersTable extends CachedUsers
    with TableInfo<$CachedUsersTable, CachedUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rolesMeta = const VerificationMeta('roles');
  @override
  late final GeneratedColumn<String> roles = GeneratedColumn<String>(
    'roles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system_user'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    username,
    email,
    firstName,
    lastName,
    nickname,
    position,
    roles,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('roles')) {
      context.handle(
        _rolesMeta,
        roles.isAcceptableOrUnknown(data['roles']!, _rolesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  CachedUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedUser(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      roles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roles'],
      )!,
    );
  }

  @override
  $CachedUsersTable createAlias(String alias) {
    return $CachedUsersTable(attachedDatabase, alias);
  }
}

class CachedUser extends DataClass implements Insertable<CachedUser> {
  final String serverId;
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String nickname;
  final String position;
  final String roles;
  const CachedUser({
    required this.serverId,
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.position,
    required this.roles,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['nickname'] = Variable<String>(nickname);
    map['position'] = Variable<String>(position);
    map['roles'] = Variable<String>(roles);
    return map;
  }

  CachedUsersCompanion toCompanion(bool nullToAbsent) {
    return CachedUsersCompanion(
      serverId: Value(serverId),
      id: Value(id),
      username: Value(username),
      email: Value(email),
      firstName: Value(firstName),
      lastName: Value(lastName),
      nickname: Value(nickname),
      position: Value(position),
      roles: Value(roles),
    );
  }

  factory CachedUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedUser(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      nickname: serializer.fromJson<String>(json['nickname']),
      position: serializer.fromJson<String>(json['position']),
      roles: serializer.fromJson<String>(json['roles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'nickname': serializer.toJson<String>(nickname),
      'position': serializer.toJson<String>(position),
      'roles': serializer.toJson<String>(roles),
    };
  }

  CachedUser copyWith({
    String? serverId,
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? roles,
  }) => CachedUser(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    nickname: nickname ?? this.nickname,
    position: position ?? this.position,
    roles: roles ?? this.roles,
  );
  CachedUser copyWithCompanion(CachedUsersCompanion data) {
    return CachedUser(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      position: data.position.present ? data.position.value : this.position,
      roles: data.roles.present ? data.roles.value : this.roles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedUser(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('position: $position, ')
          ..write('roles: $roles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    username,
    email,
    firstName,
    lastName,
    nickname,
    position,
    roles,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedUser &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.nickname == this.nickname &&
          other.position == this.position &&
          other.roles == this.roles);
}

class CachedUsersCompanion extends UpdateCompanion<CachedUser> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> nickname;
  final Value<String> position;
  final Value<String> roles;
  final Value<int> rowid;
  const CachedUsersCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nickname = const Value.absent(),
    this.position = const Value.absent(),
    this.roles = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedUsersCompanion.insert({
    required String serverId,
    required String id,
    required String username,
    required String email,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nickname = const Value.absent(),
    this.position = const Value.absent(),
    this.roles = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       username = Value(username),
       email = Value(email);
  static Insertable<CachedUser> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? nickname,
    Expression<String>? position,
    Expression<String>? roles,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (nickname != null) 'nickname': nickname,
      if (position != null) 'position': position,
      if (roles != null) 'roles': roles,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedUsersCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? username,
    Value<String>? email,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? nickname,
    Value<String>? position,
    Value<String>? roles,
    Value<int>? rowid,
  }) {
    return CachedUsersCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      position: position ?? this.position,
      roles: roles ?? this.roles,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (roles.present) {
      map['roles'] = Variable<String>(roles.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedUsersCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('nickname: $nickname, ')
          ..write('position: $position, ')
          ..write('roles: $roles, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTeamsTable extends CachedTeams
    with TableInfo<$CachedTeamsTable, CachedTeam> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('O'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    name,
    displayName,
    description,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTeam> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  CachedTeam map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTeam(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $CachedTeamsTable createAlias(String alias) {
    return $CachedTeamsTable(attachedDatabase, alias);
  }
}

class CachedTeam extends DataClass implements Insertable<CachedTeam> {
  final String serverId;
  final String id;
  final String name;
  final String displayName;
  final String description;
  final String type;
  const CachedTeam({
    required this.serverId,
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    return map;
  }

  CachedTeamsCompanion toCompanion(bool nullToAbsent) {
    return CachedTeamsCompanion(
      serverId: Value(serverId),
      id: Value(id),
      name: Value(name),
      displayName: Value(displayName),
      description: Value(description),
      type: Value(type),
    );
  }

  factory CachedTeam.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTeam(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
    };
  }

  CachedTeam copyWith({
    String? serverId,
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? type,
  }) => CachedTeam(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    name: name ?? this.name,
    displayName: displayName ?? this.displayName,
    description: description ?? this.description,
    type: type ?? this.type,
  );
  CachedTeam copyWithCompanion(CachedTeamsCompanion data) {
    return CachedTeam(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTeam(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('description: $description, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(serverId, id, name, displayName, description, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTeam &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.description == this.description &&
          other.type == this.type);
}

class CachedTeamsCompanion extends UpdateCompanion<CachedTeam> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> name;
  final Value<String> displayName;
  final Value<String> description;
  final Value<String> type;
  final Value<int> rowid;
  const CachedTeamsCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTeamsCompanion.insert({
    required String serverId,
    required String id,
    required String name,
    required String displayName,
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       name = Value(name),
       displayName = Value(displayName);
  static Insertable<CachedTeam> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? description,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTeamsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? name,
    Value<String>? displayName,
    Value<String>? description,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return CachedTeamsCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTeamsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedChannelsTable extends CachedChannels
    with TableInfo<$CachedChannelsTable, CachedChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headerMeta = const VerificationMeta('header');
  @override
  late final GeneratedColumn<String> header = GeneratedColumn<String>(
    'header',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPostAtMeta = const VerificationMeta(
    'lastPostAt',
  );
  @override
  late final GeneratedColumn<int> lastPostAt = GeneratedColumn<int>(
    'last_post_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMsgCountMeta = const VerificationMeta(
    'totalMsgCount',
  );
  @override
  late final GeneratedColumn<int> totalMsgCount = GeneratedColumn<int>(
    'total_msg_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    teamId,
    name,
    displayName,
    header,
    purpose,
    type,
    lastPostAt,
    totalMsgCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedChannel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('header')) {
      context.handle(
        _headerMeta,
        header.isAcceptableOrUnknown(data['header']!, _headerMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('last_post_at')) {
      context.handle(
        _lastPostAtMeta,
        lastPostAt.isAcceptableOrUnknown(
          data['last_post_at']!,
          _lastPostAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPostAtMeta);
    }
    if (data.containsKey('total_msg_count')) {
      context.handle(
        _totalMsgCountMeta,
        totalMsgCount.isAcceptableOrUnknown(
          data['total_msg_count']!,
          _totalMsgCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  CachedChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedChannel(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      header: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}header'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      lastPostAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_post_at'],
      )!,
      totalMsgCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_msg_count'],
      )!,
    );
  }

  @override
  $CachedChannelsTable createAlias(String alias) {
    return $CachedChannelsTable(attachedDatabase, alias);
  }
}

class CachedChannel extends DataClass implements Insertable<CachedChannel> {
  final String serverId;
  final String id;
  final String teamId;
  final String name;
  final String displayName;
  final String header;
  final String purpose;
  final String type;
  final int lastPostAt;
  final int totalMsgCount;
  const CachedChannel({
    required this.serverId,
    required this.id,
    required this.teamId,
    required this.name,
    required this.displayName,
    required this.header,
    required this.purpose,
    required this.type,
    required this.lastPostAt,
    required this.totalMsgCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['team_id'] = Variable<String>(teamId);
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    map['header'] = Variable<String>(header);
    map['purpose'] = Variable<String>(purpose);
    map['type'] = Variable<String>(type);
    map['last_post_at'] = Variable<int>(lastPostAt);
    map['total_msg_count'] = Variable<int>(totalMsgCount);
    return map;
  }

  CachedChannelsCompanion toCompanion(bool nullToAbsent) {
    return CachedChannelsCompanion(
      serverId: Value(serverId),
      id: Value(id),
      teamId: Value(teamId),
      name: Value(name),
      displayName: Value(displayName),
      header: Value(header),
      purpose: Value(purpose),
      type: Value(type),
      lastPostAt: Value(lastPostAt),
      totalMsgCount: Value(totalMsgCount),
    );
  }

  factory CachedChannel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedChannel(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      teamId: serializer.fromJson<String>(json['teamId']),
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      header: serializer.fromJson<String>(json['header']),
      purpose: serializer.fromJson<String>(json['purpose']),
      type: serializer.fromJson<String>(json['type']),
      lastPostAt: serializer.fromJson<int>(json['lastPostAt']),
      totalMsgCount: serializer.fromJson<int>(json['totalMsgCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'teamId': serializer.toJson<String>(teamId),
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'header': serializer.toJson<String>(header),
      'purpose': serializer.toJson<String>(purpose),
      'type': serializer.toJson<String>(type),
      'lastPostAt': serializer.toJson<int>(lastPostAt),
      'totalMsgCount': serializer.toJson<int>(totalMsgCount),
    };
  }

  CachedChannel copyWith({
    String? serverId,
    String? id,
    String? teamId,
    String? name,
    String? displayName,
    String? header,
    String? purpose,
    String? type,
    int? lastPostAt,
    int? totalMsgCount,
  }) => CachedChannel(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    name: name ?? this.name,
    displayName: displayName ?? this.displayName,
    header: header ?? this.header,
    purpose: purpose ?? this.purpose,
    type: type ?? this.type,
    lastPostAt: lastPostAt ?? this.lastPostAt,
    totalMsgCount: totalMsgCount ?? this.totalMsgCount,
  );
  CachedChannel copyWithCompanion(CachedChannelsCompanion data) {
    return CachedChannel(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      name: data.name.present ? data.name.value : this.name,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      header: data.header.present ? data.header.value : this.header,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      type: data.type.present ? data.type.value : this.type,
      lastPostAt: data.lastPostAt.present
          ? data.lastPostAt.value
          : this.lastPostAt,
      totalMsgCount: data.totalMsgCount.present
          ? data.totalMsgCount.value
          : this.totalMsgCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannel(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('header: $header, ')
          ..write('purpose: $purpose, ')
          ..write('type: $type, ')
          ..write('lastPostAt: $lastPostAt, ')
          ..write('totalMsgCount: $totalMsgCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    teamId,
    name,
    displayName,
    header,
    purpose,
    type,
    lastPostAt,
    totalMsgCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedChannel &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.teamId == this.teamId &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.header == this.header &&
          other.purpose == this.purpose &&
          other.type == this.type &&
          other.lastPostAt == this.lastPostAt &&
          other.totalMsgCount == this.totalMsgCount);
}

class CachedChannelsCompanion extends UpdateCompanion<CachedChannel> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> teamId;
  final Value<String> name;
  final Value<String> displayName;
  final Value<String> header;
  final Value<String> purpose;
  final Value<String> type;
  final Value<int> lastPostAt;
  final Value<int> totalMsgCount;
  final Value<int> rowid;
  const CachedChannelsCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.teamId = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.header = const Value.absent(),
    this.purpose = const Value.absent(),
    this.type = const Value.absent(),
    this.lastPostAt = const Value.absent(),
    this.totalMsgCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedChannelsCompanion.insert({
    required String serverId,
    required String id,
    this.teamId = const Value.absent(),
    required String name,
    required String displayName,
    this.header = const Value.absent(),
    this.purpose = const Value.absent(),
    required String type,
    required int lastPostAt,
    this.totalMsgCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       name = Value(name),
       displayName = Value(displayName),
       type = Value(type),
       lastPostAt = Value(lastPostAt);
  static Insertable<CachedChannel> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? teamId,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? header,
    Expression<String>? purpose,
    Expression<String>? type,
    Expression<int>? lastPostAt,
    Expression<int>? totalMsgCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (teamId != null) 'team_id': teamId,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (header != null) 'header': header,
      if (purpose != null) 'purpose': purpose,
      if (type != null) 'type': type,
      if (lastPostAt != null) 'last_post_at': lastPostAt,
      if (totalMsgCount != null) 'total_msg_count': totalMsgCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedChannelsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? teamId,
    Value<String>? name,
    Value<String>? displayName,
    Value<String>? header,
    Value<String>? purpose,
    Value<String>? type,
    Value<int>? lastPostAt,
    Value<int>? totalMsgCount,
    Value<int>? rowid,
  }) {
    return CachedChannelsCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      header: header ?? this.header,
      purpose: purpose ?? this.purpose,
      type: type ?? this.type,
      lastPostAt: lastPostAt ?? this.lastPostAt,
      totalMsgCount: totalMsgCount ?? this.totalMsgCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (header.present) {
      map['header'] = Variable<String>(header.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (lastPostAt.present) {
      map['last_post_at'] = Variable<int>(lastPostAt.value);
    }
    if (totalMsgCount.present) {
      map['total_msg_count'] = Variable<int>(totalMsgCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannelsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('header: $header, ')
          ..write('purpose: $purpose, ')
          ..write('type: $type, ')
          ..write('lastPostAt: $lastPostAt, ')
          ..write('totalMsgCount: $totalMsgCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPostsTable extends CachedPosts
    with TableInfo<$CachedPostsTable, CachedPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootIdMeta = const VerificationMeta('rootId');
  @override
  late final GeneratedColumn<String> rootId = GeneratedColumn<String>(
    'root_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createAtMeta = const VerificationMeta(
    'createAt',
  );
  @override
  late final GeneratedColumn<int> createAt = GeneratedColumn<int>(
    'create_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updateAtMeta = const VerificationMeta(
    'updateAt',
  );
  @override
  late final GeneratedColumn<int> updateAt = GeneratedColumn<int>(
    'update_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deleteAtMeta = const VerificationMeta(
    'deleteAt',
  );
  @override
  late final GeneratedColumn<int> deleteAt = GeneratedColumn<int>(
    'delete_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingPostIdMeta = const VerificationMeta(
    'pendingPostId',
  );
  @override
  late final GeneratedColumn<String> pendingPostId = GeneratedColumn<String>(
    'pending_post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    channelId,
    userId,
    message,
    rootId,
    createAt,
    updateAt,
    deleteAt,
    pendingPostId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('root_id')) {
      context.handle(
        _rootIdMeta,
        rootId.isAcceptableOrUnknown(data['root_id']!, _rootIdMeta),
      );
    }
    if (data.containsKey('create_at')) {
      context.handle(
        _createAtMeta,
        createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createAtMeta);
    }
    if (data.containsKey('update_at')) {
      context.handle(
        _updateAtMeta,
        updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updateAtMeta);
    }
    if (data.containsKey('delete_at')) {
      context.handle(
        _deleteAtMeta,
        deleteAt.isAcceptableOrUnknown(data['delete_at']!, _deleteAtMeta),
      );
    }
    if (data.containsKey('pending_post_id')) {
      context.handle(
        _pendingPostIdMeta,
        pendingPostId.isAcceptableOrUnknown(
          data['pending_post_id']!,
          _pendingPostIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  CachedPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPost(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      rootId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_id'],
      )!,
      createAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}create_at'],
      )!,
      updateAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}update_at'],
      )!,
      deleteAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delete_at'],
      )!,
      pendingPostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_post_id'],
      )!,
    );
  }

  @override
  $CachedPostsTable createAlias(String alias) {
    return $CachedPostsTable(attachedDatabase, alias);
  }
}

class CachedPost extends DataClass implements Insertable<CachedPost> {
  final String serverId;
  final String id;
  final String channelId;
  final String userId;
  final String message;
  final String rootId;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String pendingPostId;
  const CachedPost({
    required this.serverId,
    required this.id,
    required this.channelId,
    required this.userId,
    required this.message,
    required this.rootId,
    required this.createAt,
    required this.updateAt,
    required this.deleteAt,
    required this.pendingPostId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['user_id'] = Variable<String>(userId);
    map['message'] = Variable<String>(message);
    map['root_id'] = Variable<String>(rootId);
    map['create_at'] = Variable<int>(createAt);
    map['update_at'] = Variable<int>(updateAt);
    map['delete_at'] = Variable<int>(deleteAt);
    map['pending_post_id'] = Variable<String>(pendingPostId);
    return map;
  }

  CachedPostsCompanion toCompanion(bool nullToAbsent) {
    return CachedPostsCompanion(
      serverId: Value(serverId),
      id: Value(id),
      channelId: Value(channelId),
      userId: Value(userId),
      message: Value(message),
      rootId: Value(rootId),
      createAt: Value(createAt),
      updateAt: Value(updateAt),
      deleteAt: Value(deleteAt),
      pendingPostId: Value(pendingPostId),
    );
  }

  factory CachedPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPost(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      userId: serializer.fromJson<String>(json['userId']),
      message: serializer.fromJson<String>(json['message']),
      rootId: serializer.fromJson<String>(json['rootId']),
      createAt: serializer.fromJson<int>(json['createAt']),
      updateAt: serializer.fromJson<int>(json['updateAt']),
      deleteAt: serializer.fromJson<int>(json['deleteAt']),
      pendingPostId: serializer.fromJson<String>(json['pendingPostId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'userId': serializer.toJson<String>(userId),
      'message': serializer.toJson<String>(message),
      'rootId': serializer.toJson<String>(rootId),
      'createAt': serializer.toJson<int>(createAt),
      'updateAt': serializer.toJson<int>(updateAt),
      'deleteAt': serializer.toJson<int>(deleteAt),
      'pendingPostId': serializer.toJson<String>(pendingPostId),
    };
  }

  CachedPost copyWith({
    String? serverId,
    String? id,
    String? channelId,
    String? userId,
    String? message,
    String? rootId,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? pendingPostId,
  }) => CachedPost(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    userId: userId ?? this.userId,
    message: message ?? this.message,
    rootId: rootId ?? this.rootId,
    createAt: createAt ?? this.createAt,
    updateAt: updateAt ?? this.updateAt,
    deleteAt: deleteAt ?? this.deleteAt,
    pendingPostId: pendingPostId ?? this.pendingPostId,
  );
  CachedPost copyWithCompanion(CachedPostsCompanion data) {
    return CachedPost(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      userId: data.userId.present ? data.userId.value : this.userId,
      message: data.message.present ? data.message.value : this.message,
      rootId: data.rootId.present ? data.rootId.value : this.rootId,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      deleteAt: data.deleteAt.present ? data.deleteAt.value : this.deleteAt,
      pendingPostId: data.pendingPostId.present
          ? data.pendingPostId.value
          : this.pendingPostId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPost(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('message: $message, ')
          ..write('rootId: $rootId, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('deleteAt: $deleteAt, ')
          ..write('pendingPostId: $pendingPostId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    channelId,
    userId,
    message,
    rootId,
    createAt,
    updateAt,
    deleteAt,
    pendingPostId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPost &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.userId == this.userId &&
          other.message == this.message &&
          other.rootId == this.rootId &&
          other.createAt == this.createAt &&
          other.updateAt == this.updateAt &&
          other.deleteAt == this.deleteAt &&
          other.pendingPostId == this.pendingPostId);
}

class CachedPostsCompanion extends UpdateCompanion<CachedPost> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> userId;
  final Value<String> message;
  final Value<String> rootId;
  final Value<int> createAt;
  final Value<int> updateAt;
  final Value<int> deleteAt;
  final Value<String> pendingPostId;
  final Value<int> rowid;
  const CachedPostsCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.userId = const Value.absent(),
    this.message = const Value.absent(),
    this.rootId = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.deleteAt = const Value.absent(),
    this.pendingPostId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPostsCompanion.insert({
    required String serverId,
    required String id,
    required String channelId,
    required String userId,
    required String message,
    this.rootId = const Value.absent(),
    required int createAt,
    required int updateAt,
    this.deleteAt = const Value.absent(),
    this.pendingPostId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       channelId = Value(channelId),
       userId = Value(userId),
       message = Value(message),
       createAt = Value(createAt),
       updateAt = Value(updateAt);
  static Insertable<CachedPost> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? userId,
    Expression<String>? message,
    Expression<String>? rootId,
    Expression<int>? createAt,
    Expression<int>? updateAt,
    Expression<int>? deleteAt,
    Expression<String>? pendingPostId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (userId != null) 'user_id': userId,
      if (message != null) 'message': message,
      if (rootId != null) 'root_id': rootId,
      if (createAt != null) 'create_at': createAt,
      if (updateAt != null) 'update_at': updateAt,
      if (deleteAt != null) 'delete_at': deleteAt,
      if (pendingPostId != null) 'pending_post_id': pendingPostId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPostsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? channelId,
    Value<String>? userId,
    Value<String>? message,
    Value<String>? rootId,
    Value<int>? createAt,
    Value<int>? updateAt,
    Value<int>? deleteAt,
    Value<String>? pendingPostId,
    Value<int>? rowid,
  }) {
    return CachedPostsCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      rootId: rootId ?? this.rootId,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      pendingPostId: pendingPostId ?? this.pendingPostId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (rootId.present) {
      map['root_id'] = Variable<String>(rootId.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<int>(createAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<int>(updateAt.value);
    }
    if (deleteAt.present) {
      map['delete_at'] = Variable<int>(deleteAt.value);
    }
    if (pendingPostId.present) {
      map['pending_post_id'] = Variable<String>(pendingPostId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPostsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('message: $message, ')
          ..write('rootId: $rootId, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('deleteAt: $deleteAt, ')
          ..write('pendingPostId: $pendingPostId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedReactionsTable extends CachedReactions
    with TableInfo<$CachedReactionsTable, CachedReaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiNameMeta = const VerificationMeta(
    'emojiName',
  );
  @override
  late final GeneratedColumn<String> emojiName = GeneratedColumn<String>(
    'emoji_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createAtMeta = const VerificationMeta(
    'createAt',
  );
  @override
  late final GeneratedColumn<int> createAt = GeneratedColumn<int>(
    'create_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    userId,
    postId,
    emojiName,
    createAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_reactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedReaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('emoji_name')) {
      context.handle(
        _emojiNameMeta,
        emojiName.isAcceptableOrUnknown(data['emoji_name']!, _emojiNameMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiNameMeta);
    }
    if (data.containsKey('create_at')) {
      context.handle(
        _createAtMeta,
        createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, userId, postId, emojiName};
  @override
  CachedReaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReaction(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      emojiName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_name'],
      )!,
      createAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}create_at'],
      )!,
    );
  }

  @override
  $CachedReactionsTable createAlias(String alias) {
    return $CachedReactionsTable(attachedDatabase, alias);
  }
}

class CachedReaction extends DataClass implements Insertable<CachedReaction> {
  final String serverId;
  final String userId;
  final String postId;
  final String emojiName;
  final int createAt;
  const CachedReaction({
    required this.serverId,
    required this.userId,
    required this.postId,
    required this.emojiName,
    required this.createAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['user_id'] = Variable<String>(userId);
    map['post_id'] = Variable<String>(postId);
    map['emoji_name'] = Variable<String>(emojiName);
    map['create_at'] = Variable<int>(createAt);
    return map;
  }

  CachedReactionsCompanion toCompanion(bool nullToAbsent) {
    return CachedReactionsCompanion(
      serverId: Value(serverId),
      userId: Value(userId),
      postId: Value(postId),
      emojiName: Value(emojiName),
      createAt: Value(createAt),
    );
  }

  factory CachedReaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReaction(
      serverId: serializer.fromJson<String>(json['serverId']),
      userId: serializer.fromJson<String>(json['userId']),
      postId: serializer.fromJson<String>(json['postId']),
      emojiName: serializer.fromJson<String>(json['emojiName']),
      createAt: serializer.fromJson<int>(json['createAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'userId': serializer.toJson<String>(userId),
      'postId': serializer.toJson<String>(postId),
      'emojiName': serializer.toJson<String>(emojiName),
      'createAt': serializer.toJson<int>(createAt),
    };
  }

  CachedReaction copyWith({
    String? serverId,
    String? userId,
    String? postId,
    String? emojiName,
    int? createAt,
  }) => CachedReaction(
    serverId: serverId ?? this.serverId,
    userId: userId ?? this.userId,
    postId: postId ?? this.postId,
    emojiName: emojiName ?? this.emojiName,
    createAt: createAt ?? this.createAt,
  );
  CachedReaction copyWithCompanion(CachedReactionsCompanion data) {
    return CachedReaction(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      userId: data.userId.present ? data.userId.value : this.userId,
      postId: data.postId.present ? data.postId.value : this.postId,
      emojiName: data.emojiName.present ? data.emojiName.value : this.emojiName,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReaction(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('postId: $postId, ')
          ..write('emojiName: $emojiName, ')
          ..write('createAt: $createAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(serverId, userId, postId, emojiName, createAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReaction &&
          other.serverId == this.serverId &&
          other.userId == this.userId &&
          other.postId == this.postId &&
          other.emojiName == this.emojiName &&
          other.createAt == this.createAt);
}

class CachedReactionsCompanion extends UpdateCompanion<CachedReaction> {
  final Value<String> serverId;
  final Value<String> userId;
  final Value<String> postId;
  final Value<String> emojiName;
  final Value<int> createAt;
  final Value<int> rowid;
  const CachedReactionsCompanion({
    this.serverId = const Value.absent(),
    this.userId = const Value.absent(),
    this.postId = const Value.absent(),
    this.emojiName = const Value.absent(),
    this.createAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedReactionsCompanion.insert({
    required String serverId,
    required String userId,
    required String postId,
    required String emojiName,
    required int createAt,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       userId = Value(userId),
       postId = Value(postId),
       emojiName = Value(emojiName),
       createAt = Value(createAt);
  static Insertable<CachedReaction> custom({
    Expression<String>? serverId,
    Expression<String>? userId,
    Expression<String>? postId,
    Expression<String>? emojiName,
    Expression<int>? createAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (userId != null) 'user_id': userId,
      if (postId != null) 'post_id': postId,
      if (emojiName != null) 'emoji_name': emojiName,
      if (createAt != null) 'create_at': createAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedReactionsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? userId,
    Value<String>? postId,
    Value<String>? emojiName,
    Value<int>? createAt,
    Value<int>? rowid,
  }) {
    return CachedReactionsCompanion(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      emojiName: emojiName ?? this.emojiName,
      createAt: createAt ?? this.createAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (emojiName.present) {
      map['emoji_name'] = Variable<String>(emojiName.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<int>(createAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedReactionsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('postId: $postId, ')
          ..write('emojiName: $emojiName, ')
          ..write('createAt: $createAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedFileInfoTable extends CachedFileInfo
    with TableInfo<$CachedFileInfoTable, CachedFileInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFileInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extension_Meta = const VerificationMeta(
    'extension_',
  );
  @override
  late final GeneratedColumn<String> extension_ = GeneratedColumn<String>(
    'extension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    postId,
    creatorId,
    name,
    extension_,
    size,
    mimeType,
    width,
    height,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_file_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFileInfoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extension')) {
      context.handle(
        _extension_Meta,
        extension_.isAcceptableOrUnknown(data['extension']!, _extension_Meta),
      );
    } else if (isInserting) {
      context.missing(_extension_Meta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  CachedFileInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFileInfoData(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extension_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extension'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
    );
  }

  @override
  $CachedFileInfoTable createAlias(String alias) {
    return $CachedFileInfoTable(attachedDatabase, alias);
  }
}

class CachedFileInfoData extends DataClass
    implements Insertable<CachedFileInfoData> {
  final String serverId;
  final String id;
  final String postId;
  final String creatorId;
  final String name;
  final String extension_;
  final int size;
  final String mimeType;
  final int width;
  final int height;
  const CachedFileInfoData({
    required this.serverId,
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.name,
    required this.extension_,
    required this.size,
    required this.mimeType,
    required this.width,
    required this.height,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['post_id'] = Variable<String>(postId);
    map['creator_id'] = Variable<String>(creatorId);
    map['name'] = Variable<String>(name);
    map['extension'] = Variable<String>(extension_);
    map['size'] = Variable<int>(size);
    map['mime_type'] = Variable<String>(mimeType);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    return map;
  }

  CachedFileInfoCompanion toCompanion(bool nullToAbsent) {
    return CachedFileInfoCompanion(
      serverId: Value(serverId),
      id: Value(id),
      postId: Value(postId),
      creatorId: Value(creatorId),
      name: Value(name),
      extension_: Value(extension_),
      size: Value(size),
      mimeType: Value(mimeType),
      width: Value(width),
      height: Value(height),
    );
  }

  factory CachedFileInfoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFileInfoData(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      name: serializer.fromJson<String>(json['name']),
      extension_: serializer.fromJson<String>(json['extension_']),
      size: serializer.fromJson<int>(json['size']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'postId': serializer.toJson<String>(postId),
      'creatorId': serializer.toJson<String>(creatorId),
      'name': serializer.toJson<String>(name),
      'extension_': serializer.toJson<String>(extension_),
      'size': serializer.toJson<int>(size),
      'mimeType': serializer.toJson<String>(mimeType),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
    };
  }

  CachedFileInfoData copyWith({
    String? serverId,
    String? id,
    String? postId,
    String? creatorId,
    String? name,
    String? extension_,
    int? size,
    String? mimeType,
    int? width,
    int? height,
  }) => CachedFileInfoData(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    postId: postId ?? this.postId,
    creatorId: creatorId ?? this.creatorId,
    name: name ?? this.name,
    extension_: extension_ ?? this.extension_,
    size: size ?? this.size,
    mimeType: mimeType ?? this.mimeType,
    width: width ?? this.width,
    height: height ?? this.height,
  );
  CachedFileInfoData copyWithCompanion(CachedFileInfoCompanion data) {
    return CachedFileInfoData(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      name: data.name.present ? data.name.value : this.name,
      extension_: data.extension_.present
          ? data.extension_.value
          : this.extension_,
      size: data.size.present ? data.size.value : this.size,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFileInfoData(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('creatorId: $creatorId, ')
          ..write('name: $name, ')
          ..write('extension_: $extension_, ')
          ..write('size: $size, ')
          ..write('mimeType: $mimeType, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    postId,
    creatorId,
    name,
    extension_,
    size,
    mimeType,
    width,
    height,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFileInfoData &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.creatorId == this.creatorId &&
          other.name == this.name &&
          other.extension_ == this.extension_ &&
          other.size == this.size &&
          other.mimeType == this.mimeType &&
          other.width == this.width &&
          other.height == this.height);
}

class CachedFileInfoCompanion extends UpdateCompanion<CachedFileInfoData> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> postId;
  final Value<String> creatorId;
  final Value<String> name;
  final Value<String> extension_;
  final Value<int> size;
  final Value<String> mimeType;
  final Value<int> width;
  final Value<int> height;
  final Value<int> rowid;
  const CachedFileInfoCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.name = const Value.absent(),
    this.extension_ = const Value.absent(),
    this.size = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedFileInfoCompanion.insert({
    required String serverId,
    required String id,
    required String postId,
    required String creatorId,
    required String name,
    required String extension_,
    required int size,
    this.mimeType = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       postId = Value(postId),
       creatorId = Value(creatorId),
       name = Value(name),
       extension_ = Value(extension_),
       size = Value(size);
  static Insertable<CachedFileInfoData> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? postId,
    Expression<String>? creatorId,
    Expression<String>? name,
    Expression<String>? extension_,
    Expression<int>? size,
    Expression<String>? mimeType,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (creatorId != null) 'creator_id': creatorId,
      if (name != null) 'name': name,
      if (extension_ != null) 'extension': extension_,
      if (size != null) 'size': size,
      if (mimeType != null) 'mime_type': mimeType,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedFileInfoCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? postId,
    Value<String>? creatorId,
    Value<String>? name,
    Value<String>? extension_,
    Value<int>? size,
    Value<String>? mimeType,
    Value<int>? width,
    Value<int>? height,
    Value<int>? rowid,
  }) {
    return CachedFileInfoCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      creatorId: creatorId ?? this.creatorId,
      name: name ?? this.name,
      extension_: extension_ ?? this.extension_,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extension_.present) {
      map['extension'] = Variable<String>(extension_.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFileInfoCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('creatorId: $creatorId, ')
          ..write('name: $name, ')
          ..write('extension_: $extension_, ')
          ..write('size: $size, ')
          ..write('mimeType: $mimeType, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedChannelMembersTable extends CachedChannelMembers
    with TableInfo<$CachedChannelMembersTable, CachedChannelMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedChannelMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolesMeta = const VerificationMeta('roles');
  @override
  late final GeneratedColumn<String> roles = GeneratedColumn<String>(
    'roles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastViewedAtMeta = const VerificationMeta(
    'lastViewedAt',
  );
  @override
  late final GeneratedColumn<int> lastViewedAt = GeneratedColumn<int>(
    'last_viewed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _msgCountMeta = const VerificationMeta(
    'msgCount',
  );
  @override
  late final GeneratedColumn<int> msgCount = GeneratedColumn<int>(
    'msg_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _mentionCountMeta = const VerificationMeta(
    'mentionCount',
  );
  @override
  late final GeneratedColumn<int> mentionCount = GeneratedColumn<int>(
    'mention_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    channelId,
    userId,
    roles,
    lastViewedAt,
    msgCount,
    mentionCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_channel_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedChannelMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('roles')) {
      context.handle(
        _rolesMeta,
        roles.isAcceptableOrUnknown(data['roles']!, _rolesMeta),
      );
    }
    if (data.containsKey('last_viewed_at')) {
      context.handle(
        _lastViewedAtMeta,
        lastViewedAt.isAcceptableOrUnknown(
          data['last_viewed_at']!,
          _lastViewedAtMeta,
        ),
      );
    }
    if (data.containsKey('msg_count')) {
      context.handle(
        _msgCountMeta,
        msgCount.isAcceptableOrUnknown(data['msg_count']!, _msgCountMeta),
      );
    }
    if (data.containsKey('mention_count')) {
      context.handle(
        _mentionCountMeta,
        mentionCount.isAcceptableOrUnknown(
          data['mention_count']!,
          _mentionCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, channelId, userId};
  @override
  CachedChannelMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedChannelMember(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      roles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roles'],
      )!,
      lastViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_viewed_at'],
      )!,
      msgCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}msg_count'],
      )!,
      mentionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mention_count'],
      )!,
    );
  }

  @override
  $CachedChannelMembersTable createAlias(String alias) {
    return $CachedChannelMembersTable(attachedDatabase, alias);
  }
}

class CachedChannelMember extends DataClass
    implements Insertable<CachedChannelMember> {
  final String serverId;
  final String channelId;
  final String userId;
  final String roles;
  final int lastViewedAt;
  final int msgCount;
  final int mentionCount;
  const CachedChannelMember({
    required this.serverId,
    required this.channelId,
    required this.userId,
    required this.roles,
    required this.lastViewedAt,
    required this.msgCount,
    required this.mentionCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['channel_id'] = Variable<String>(channelId);
    map['user_id'] = Variable<String>(userId);
    map['roles'] = Variable<String>(roles);
    map['last_viewed_at'] = Variable<int>(lastViewedAt);
    map['msg_count'] = Variable<int>(msgCount);
    map['mention_count'] = Variable<int>(mentionCount);
    return map;
  }

  CachedChannelMembersCompanion toCompanion(bool nullToAbsent) {
    return CachedChannelMembersCompanion(
      serverId: Value(serverId),
      channelId: Value(channelId),
      userId: Value(userId),
      roles: Value(roles),
      lastViewedAt: Value(lastViewedAt),
      msgCount: Value(msgCount),
      mentionCount: Value(mentionCount),
    );
  }

  factory CachedChannelMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedChannelMember(
      serverId: serializer.fromJson<String>(json['serverId']),
      channelId: serializer.fromJson<String>(json['channelId']),
      userId: serializer.fromJson<String>(json['userId']),
      roles: serializer.fromJson<String>(json['roles']),
      lastViewedAt: serializer.fromJson<int>(json['lastViewedAt']),
      msgCount: serializer.fromJson<int>(json['msgCount']),
      mentionCount: serializer.fromJson<int>(json['mentionCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'channelId': serializer.toJson<String>(channelId),
      'userId': serializer.toJson<String>(userId),
      'roles': serializer.toJson<String>(roles),
      'lastViewedAt': serializer.toJson<int>(lastViewedAt),
      'msgCount': serializer.toJson<int>(msgCount),
      'mentionCount': serializer.toJson<int>(mentionCount),
    };
  }

  CachedChannelMember copyWith({
    String? serverId,
    String? channelId,
    String? userId,
    String? roles,
    int? lastViewedAt,
    int? msgCount,
    int? mentionCount,
  }) => CachedChannelMember(
    serverId: serverId ?? this.serverId,
    channelId: channelId ?? this.channelId,
    userId: userId ?? this.userId,
    roles: roles ?? this.roles,
    lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    msgCount: msgCount ?? this.msgCount,
    mentionCount: mentionCount ?? this.mentionCount,
  );
  CachedChannelMember copyWithCompanion(CachedChannelMembersCompanion data) {
    return CachedChannelMember(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      userId: data.userId.present ? data.userId.value : this.userId,
      roles: data.roles.present ? data.roles.value : this.roles,
      lastViewedAt: data.lastViewedAt.present
          ? data.lastViewedAt.value
          : this.lastViewedAt,
      msgCount: data.msgCount.present ? data.msgCount.value : this.msgCount,
      mentionCount: data.mentionCount.present
          ? data.mentionCount.value
          : this.mentionCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannelMember(')
          ..write('serverId: $serverId, ')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('roles: $roles, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('msgCount: $msgCount, ')
          ..write('mentionCount: $mentionCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    channelId,
    userId,
    roles,
    lastViewedAt,
    msgCount,
    mentionCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedChannelMember &&
          other.serverId == this.serverId &&
          other.channelId == this.channelId &&
          other.userId == this.userId &&
          other.roles == this.roles &&
          other.lastViewedAt == this.lastViewedAt &&
          other.msgCount == this.msgCount &&
          other.mentionCount == this.mentionCount);
}

class CachedChannelMembersCompanion
    extends UpdateCompanion<CachedChannelMember> {
  final Value<String> serverId;
  final Value<String> channelId;
  final Value<String> userId;
  final Value<String> roles;
  final Value<int> lastViewedAt;
  final Value<int> msgCount;
  final Value<int> mentionCount;
  final Value<int> rowid;
  const CachedChannelMembersCompanion({
    this.serverId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.userId = const Value.absent(),
    this.roles = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.msgCount = const Value.absent(),
    this.mentionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedChannelMembersCompanion.insert({
    required String serverId,
    required String channelId,
    required String userId,
    this.roles = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.msgCount = const Value.absent(),
    this.mentionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       channelId = Value(channelId),
       userId = Value(userId);
  static Insertable<CachedChannelMember> custom({
    Expression<String>? serverId,
    Expression<String>? channelId,
    Expression<String>? userId,
    Expression<String>? roles,
    Expression<int>? lastViewedAt,
    Expression<int>? msgCount,
    Expression<int>? mentionCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (channelId != null) 'channel_id': channelId,
      if (userId != null) 'user_id': userId,
      if (roles != null) 'roles': roles,
      if (lastViewedAt != null) 'last_viewed_at': lastViewedAt,
      if (msgCount != null) 'msg_count': msgCount,
      if (mentionCount != null) 'mention_count': mentionCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedChannelMembersCompanion copyWith({
    Value<String>? serverId,
    Value<String>? channelId,
    Value<String>? userId,
    Value<String>? roles,
    Value<int>? lastViewedAt,
    Value<int>? msgCount,
    Value<int>? mentionCount,
    Value<int>? rowid,
  }) {
    return CachedChannelMembersCompanion(
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      msgCount: msgCount ?? this.msgCount,
      mentionCount: mentionCount ?? this.mentionCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (roles.present) {
      map['roles'] = Variable<String>(roles.value);
    }
    if (lastViewedAt.present) {
      map['last_viewed_at'] = Variable<int>(lastViewedAt.value);
    }
    if (msgCount.present) {
      map['msg_count'] = Variable<int>(msgCount.value);
    }
    if (mentionCount.present) {
      map['mention_count'] = Variable<int>(mentionCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedChannelMembersCompanion(')
          ..write('serverId: $serverId, ')
          ..write('channelId: $channelId, ')
          ..write('userId: $userId, ')
          ..write('roles: $roles, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('msgCount: $msgCount, ')
          ..write('mentionCount: $mentionCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedUserStatusesTable extends CachedUserStatuses
    with TableInfo<$CachedUserStatusesTable, CachedUserStatuse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedUserStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastActivityAtMeta = const VerificationMeta(
    'lastActivityAt',
  );
  @override
  late final GeneratedColumn<int> lastActivityAt = GeneratedColumn<int>(
    'last_activity_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    userId,
    status,
    lastActivityAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_user_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedUserStatuse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
        _lastActivityAtMeta,
        lastActivityAt.isAcceptableOrUnknown(
          data['last_activity_at']!,
          _lastActivityAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, userId};
  @override
  CachedUserStatuse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedUserStatuse(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastActivityAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_activity_at'],
      )!,
    );
  }

  @override
  $CachedUserStatusesTable createAlias(String alias) {
    return $CachedUserStatusesTable(attachedDatabase, alias);
  }
}

class CachedUserStatuse extends DataClass
    implements Insertable<CachedUserStatuse> {
  final String serverId;
  final String userId;
  final String status;
  final int lastActivityAt;
  const CachedUserStatuse({
    required this.serverId,
    required this.userId,
    required this.status,
    required this.lastActivityAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['user_id'] = Variable<String>(userId);
    map['status'] = Variable<String>(status);
    map['last_activity_at'] = Variable<int>(lastActivityAt);
    return map;
  }

  CachedUserStatusesCompanion toCompanion(bool nullToAbsent) {
    return CachedUserStatusesCompanion(
      serverId: Value(serverId),
      userId: Value(userId),
      status: Value(status),
      lastActivityAt: Value(lastActivityAt),
    );
  }

  factory CachedUserStatuse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedUserStatuse(
      serverId: serializer.fromJson<String>(json['serverId']),
      userId: serializer.fromJson<String>(json['userId']),
      status: serializer.fromJson<String>(json['status']),
      lastActivityAt: serializer.fromJson<int>(json['lastActivityAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'userId': serializer.toJson<String>(userId),
      'status': serializer.toJson<String>(status),
      'lastActivityAt': serializer.toJson<int>(lastActivityAt),
    };
  }

  CachedUserStatuse copyWith({
    String? serverId,
    String? userId,
    String? status,
    int? lastActivityAt,
  }) => CachedUserStatuse(
    serverId: serverId ?? this.serverId,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    lastActivityAt: lastActivityAt ?? this.lastActivityAt,
  );
  CachedUserStatuse copyWithCompanion(CachedUserStatusesCompanion data) {
    return CachedUserStatuse(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      userId: data.userId.present ? data.userId.value : this.userId,
      status: data.status.present ? data.status.value : this.status,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedUserStatuse(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('lastActivityAt: $lastActivityAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serverId, userId, status, lastActivityAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedUserStatuse &&
          other.serverId == this.serverId &&
          other.userId == this.userId &&
          other.status == this.status &&
          other.lastActivityAt == this.lastActivityAt);
}

class CachedUserStatusesCompanion extends UpdateCompanion<CachedUserStatuse> {
  final Value<String> serverId;
  final Value<String> userId;
  final Value<String> status;
  final Value<int> lastActivityAt;
  final Value<int> rowid;
  const CachedUserStatusesCompanion({
    this.serverId = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedUserStatusesCompanion.insert({
    required String serverId,
    required String userId,
    required String status,
    this.lastActivityAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       userId = Value(userId),
       status = Value(status);
  static Insertable<CachedUserStatuse> custom({
    Expression<String>? serverId,
    Expression<String>? userId,
    Expression<String>? status,
    Expression<int>? lastActivityAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (userId != null) 'user_id': userId,
      if (status != null) 'status': status,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedUserStatusesCompanion copyWith({
    Value<String>? serverId,
    Value<String>? userId,
    Value<String>? status,
    Value<int>? lastActivityAt,
    Value<int>? rowid,
  }) {
    return CachedUserStatusesCompanion(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<int>(lastActivityAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedUserStatusesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPreferencesTable extends CachedPreferences
    with TableInfo<$CachedPreferencesTable, CachedPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    userId,
    category,
    name,
    value,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, userId, category, name};
  @override
  CachedPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPreference(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $CachedPreferencesTable createAlias(String alias) {
    return $CachedPreferencesTable(attachedDatabase, alias);
  }
}

class CachedPreference extends DataClass
    implements Insertable<CachedPreference> {
  final String serverId;
  final String userId;
  final String category;
  final String name;
  final String value;
  const CachedPreference({
    required this.serverId,
    required this.userId,
    required this.category,
    required this.name,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['user_id'] = Variable<String>(userId);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    return map;
  }

  CachedPreferencesCompanion toCompanion(bool nullToAbsent) {
    return CachedPreferencesCompanion(
      serverId: Value(serverId),
      userId: Value(userId),
      category: Value(category),
      name: Value(name),
      value: Value(value),
    );
  }

  factory CachedPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPreference(
      serverId: serializer.fromJson<String>(json['serverId']),
      userId: serializer.fromJson<String>(json['userId']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'userId': serializer.toJson<String>(userId),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
    };
  }

  CachedPreference copyWith({
    String? serverId,
    String? userId,
    String? category,
    String? name,
    String? value,
  }) => CachedPreference(
    serverId: serverId ?? this.serverId,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    name: name ?? this.name,
    value: value ?? this.value,
  );
  CachedPreference copyWithCompanion(CachedPreferencesCompanion data) {
    return CachedPreference(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPreference(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serverId, userId, category, name, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPreference &&
          other.serverId == this.serverId &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.name == this.name &&
          other.value == this.value);
}

class CachedPreferencesCompanion extends UpdateCompanion<CachedPreference> {
  final Value<String> serverId;
  final Value<String> userId;
  final Value<String> category;
  final Value<String> name;
  final Value<String> value;
  final Value<int> rowid;
  const CachedPreferencesCompanion({
    this.serverId = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPreferencesCompanion.insert({
    required String serverId,
    required String userId,
    required String category,
    required String name,
    required String value,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       userId = Value(userId),
       category = Value(category),
       name = Value(name),
       value = Value(value);
  static Insertable<CachedPreference> custom({
    Expression<String>? serverId,
    Expression<String>? userId,
    Expression<String>? category,
    Expression<String>? name,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPreferencesCompanion copyWith({
    Value<String>? serverId,
    Value<String>? userId,
    Value<String>? category,
    Value<String>? name,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return CachedPreferencesCompanion(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      name: name ?? this.name,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPreferencesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncAt = GeneratedColumn<int>(
    'last_sync_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [serverId, key, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String serverId;
  final String key;
  final int lastSyncAt;
  const SyncMetadataData({
    required this.serverId,
    required this.key,
    required this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['key'] = Variable<String>(key);
    map['last_sync_at'] = Variable<int>(lastSyncAt);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      serverId: Value(serverId),
      key: Value(key),
      lastSyncAt: Value(lastSyncAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      serverId: serializer.fromJson<String>(json['serverId']),
      key: serializer.fromJson<String>(json['key']),
      lastSyncAt: serializer.fromJson<int>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'key': serializer.toJson<String>(key),
      'lastSyncAt': serializer.toJson<int>(lastSyncAt),
    };
  }

  SyncMetadataData copyWith({String? serverId, String? key, int? lastSyncAt}) =>
      SyncMetadataData(
        serverId: serverId ?? this.serverId,
        key: key ?? this.key,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      key: data.key.present ? data.key.value : this.key,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('serverId: $serverId, ')
          ..write('key: $key, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serverId, key, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.serverId == this.serverId &&
          other.key == this.key &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> serverId;
  final Value<String> key;
  final Value<int> lastSyncAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.serverId = const Value.absent(),
    this.key = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String serverId,
    required String key,
    required int lastSyncAt,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       key = Value(key),
       lastSyncAt = Value(lastSyncAt);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? serverId,
    Expression<String>? key,
    Expression<int>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (key != null) 'key': key,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? serverId,
    Value<String>? key,
    Value<int>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      serverId: serverId ?? this.serverId,
      key: key ?? this.key,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<int>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('serverId: $serverId, ')
          ..write('key: $key, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingActionsTable extends PendingActions
    with TableInfo<$PendingActionsTable, PendingAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    actionType,
    payloadJson,
    createdAt,
    retryCount,
    status,
    tempId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      )!,
    );
  }

  @override
  $PendingActionsTable createAlias(String alias) {
    return $PendingActionsTable(attachedDatabase, alias);
  }
}

class PendingAction extends DataClass implements Insertable<PendingAction> {
  final int id;
  final String serverId;
  final String actionType;
  final String payloadJson;
  final int createdAt;
  final int retryCount;
  final String status;
  final String tempId;
  const PendingAction({
    required this.id,
    required this.serverId,
    required this.actionType,
    required this.payloadJson,
    required this.createdAt,
    required this.retryCount,
    required this.status,
    required this.tempId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    map['action_type'] = Variable<String>(actionType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<int>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    map['temp_id'] = Variable<String>(tempId);
    return map;
  }

  PendingActionsCompanion toCompanion(bool nullToAbsent) {
    return PendingActionsCompanion(
      id: Value(id),
      serverId: Value(serverId),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      status: Value(status),
      tempId: Value(tempId),
    );
  }

  factory PendingAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingAction(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      tempId: serializer.fromJson<String>(json['tempId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'actionType': serializer.toJson<String>(actionType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'tempId': serializer.toJson<String>(tempId),
    };
  }

  PendingAction copyWith({
    int? id,
    String? serverId,
    String? actionType,
    String? payloadJson,
    int? createdAt,
    int? retryCount,
    String? status,
    String? tempId,
  }) => PendingAction(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    actionType: actionType ?? this.actionType,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    status: status ?? this.status,
    tempId: tempId ?? this.tempId,
  );
  PendingAction copyWithCompanion(PendingActionsCompanion data) {
    return PendingAction(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingAction(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('tempId: $tempId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    actionType,
    payloadJson,
    createdAt,
    retryCount,
    status,
    tempId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingAction &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.actionType == this.actionType &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.tempId == this.tempId);
}

class PendingActionsCompanion extends UpdateCompanion<PendingAction> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<String> actionType;
  final Value<String> payloadJson;
  final Value<int> createdAt;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String> tempId;
  const PendingActionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.tempId = const Value.absent(),
  });
  PendingActionsCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    required String actionType,
    required String payloadJson,
    required int createdAt,
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.tempId = const Value.absent(),
  }) : serverId = Value(serverId),
       actionType = Value(actionType),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<PendingAction> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? actionType,
    Expression<String>? payloadJson,
    Expression<int>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? tempId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (actionType != null) 'action_type': actionType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (tempId != null) 'temp_id': tempId,
    });
  }

  PendingActionsCompanion copyWith({
    Value<int>? id,
    Value<String>? serverId,
    Value<String>? actionType,
    Value<String>? payloadJson,
    Value<int>? createdAt,
    Value<int>? retryCount,
    Value<String>? status,
    Value<String>? tempId,
  }) {
    return PendingActionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      actionType: actionType ?? this.actionType,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      tempId: tempId ?? this.tempId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingActionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('tempId: $tempId')
          ..write(')'))
        .toString();
  }
}

class $CachedRolesTable extends CachedRoles
    with TableInfo<$CachedRolesTable, CachedRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemeManagedMeta = const VerificationMeta(
    'schemeManaged',
  );
  @override
  late final GeneratedColumn<bool> schemeManaged = GeneratedColumn<bool>(
    'scheme_managed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("scheme_managed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    name,
    id,
    displayName,
    permissions,
    schemeManaged,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permissionsMeta);
    }
    if (data.containsKey('scheme_managed')) {
      context.handle(
        _schemeManagedMeta,
        schemeManaged.isAcceptableOrUnknown(
          data['scheme_managed']!,
          _schemeManagedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, name};
  @override
  CachedRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedRole(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      )!,
      schemeManaged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}scheme_managed'],
      )!,
    );
  }

  @override
  $CachedRolesTable createAlias(String alias) {
    return $CachedRolesTable(attachedDatabase, alias);
  }
}

class CachedRole extends DataClass implements Insertable<CachedRole> {
  final String serverId;
  final String name;
  final String id;
  final String displayName;
  final String permissions;
  final bool schemeManaged;
  const CachedRole({
    required this.serverId,
    required this.name,
    required this.id,
    required this.displayName,
    required this.permissions,
    required this.schemeManaged,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['name'] = Variable<String>(name);
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['permissions'] = Variable<String>(permissions);
    map['scheme_managed'] = Variable<bool>(schemeManaged);
    return map;
  }

  CachedRolesCompanion toCompanion(bool nullToAbsent) {
    return CachedRolesCompanion(
      serverId: Value(serverId),
      name: Value(name),
      id: Value(id),
      displayName: Value(displayName),
      permissions: Value(permissions),
      schemeManaged: Value(schemeManaged),
    );
  }

  factory CachedRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedRole(
      serverId: serializer.fromJson<String>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      permissions: serializer.fromJson<String>(json['permissions']),
      schemeManaged: serializer.fromJson<bool>(json['schemeManaged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'name': serializer.toJson<String>(name),
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'permissions': serializer.toJson<String>(permissions),
      'schemeManaged': serializer.toJson<bool>(schemeManaged),
    };
  }

  CachedRole copyWith({
    String? serverId,
    String? name,
    String? id,
    String? displayName,
    String? permissions,
    bool? schemeManaged,
  }) => CachedRole(
    serverId: serverId ?? this.serverId,
    name: name ?? this.name,
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    permissions: permissions ?? this.permissions,
    schemeManaged: schemeManaged ?? this.schemeManaged,
  );
  CachedRole copyWithCompanion(CachedRolesCompanion data) {
    return CachedRole(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      schemeManaged: data.schemeManaged.present
          ? data.schemeManaged.value
          : this.schemeManaged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedRole(')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('permissions: $permissions, ')
          ..write('schemeManaged: $schemeManaged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(serverId, name, id, displayName, permissions, schemeManaged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedRole &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.permissions == this.permissions &&
          other.schemeManaged == this.schemeManaged);
}

class CachedRolesCompanion extends UpdateCompanion<CachedRole> {
  final Value<String> serverId;
  final Value<String> name;
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> permissions;
  final Value<bool> schemeManaged;
  final Value<int> rowid;
  const CachedRolesCompanion({
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.permissions = const Value.absent(),
    this.schemeManaged = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedRolesCompanion.insert({
    required String serverId,
    required String name,
    required String id,
    this.displayName = const Value.absent(),
    required String permissions,
    this.schemeManaged = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       name = Value(name),
       id = Value(id),
       permissions = Value(permissions);
  static Insertable<CachedRole> custom({
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? permissions,
    Expression<bool>? schemeManaged,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (permissions != null) 'permissions': permissions,
      if (schemeManaged != null) 'scheme_managed': schemeManaged,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedRolesCompanion copyWith({
    Value<String>? serverId,
    Value<String>? name,
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? permissions,
    Value<bool>? schemeManaged,
    Value<int>? rowid,
  }) {
    return CachedRolesCompanion(
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      permissions: permissions ?? this.permissions,
      schemeManaged: schemeManaged ?? this.schemeManaged,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (schemeManaged.present) {
      map['scheme_managed'] = Variable<bool>(schemeManaged.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedRolesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('permissions: $permissions, ')
          ..write('schemeManaged: $schemeManaged, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServersTable servers = $ServersTable(this);
  late final $CachedUsersTable cachedUsers = $CachedUsersTable(this);
  late final $CachedTeamsTable cachedTeams = $CachedTeamsTable(this);
  late final $CachedChannelsTable cachedChannels = $CachedChannelsTable(this);
  late final $CachedPostsTable cachedPosts = $CachedPostsTable(this);
  late final $CachedReactionsTable cachedReactions = $CachedReactionsTable(
    this,
  );
  late final $CachedFileInfoTable cachedFileInfo = $CachedFileInfoTable(this);
  late final $CachedChannelMembersTable cachedChannelMembers =
      $CachedChannelMembersTable(this);
  late final $CachedUserStatusesTable cachedUserStatuses =
      $CachedUserStatusesTable(this);
  late final $CachedPreferencesTable cachedPreferences =
      $CachedPreferencesTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $PendingActionsTable pendingActions = $PendingActionsTable(this);
  late final $CachedRolesTable cachedRoles = $CachedRolesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    servers,
    cachedUsers,
    cachedTeams,
    cachedChannels,
    cachedPosts,
    cachedReactions,
    cachedFileInfo,
    cachedChannelMembers,
    cachedUserStatuses,
    cachedPreferences,
    syncMetadata,
    pendingActions,
    cachedRoles,
  ];
}

typedef $$ServersTableCreateCompanionBuilder =
    ServersCompanion Function({
      required String id,
      required String url,
      required String name,
      Value<String?> currentUserId,
      Value<int> rowid,
    });
typedef $$ServersTableUpdateCompanionBuilder =
    ServersCompanion Function({
      Value<String> id,
      Value<String> url,
      Value<String> name,
      Value<String?> currentUserId,
      Value<int> rowid,
    });

class $$ServersTableFilterComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentUserId => $composableBuilder(
    column: $table.currentUserId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServersTableOrderingComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentUserId => $composableBuilder(
    column: $table.currentUserId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get currentUserId => $composableBuilder(
    column: $table.currentUserId,
    builder: (column) => column,
  );
}

class $$ServersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServersTable,
          Server,
          $$ServersTableFilterComposer,
          $$ServersTableOrderingComposer,
          $$ServersTableAnnotationComposer,
          $$ServersTableCreateCompanionBuilder,
          $$ServersTableUpdateCompanionBuilder,
          (Server, BaseReferences<_$AppDatabase, $ServersTable, Server>),
          Server,
          PrefetchHooks Function()
        > {
  $$ServersTableTableManager(_$AppDatabase db, $ServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> currentUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServersCompanion(
                id: id,
                url: url,
                name: name,
                currentUserId: currentUserId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String url,
                required String name,
                Value<String?> currentUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServersCompanion.insert(
                id: id,
                url: url,
                name: name,
                currentUserId: currentUserId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServersTable,
      Server,
      $$ServersTableFilterComposer,
      $$ServersTableOrderingComposer,
      $$ServersTableAnnotationComposer,
      $$ServersTableCreateCompanionBuilder,
      $$ServersTableUpdateCompanionBuilder,
      (Server, BaseReferences<_$AppDatabase, $ServersTable, Server>),
      Server,
      PrefetchHooks Function()
    >;
typedef $$CachedUsersTableCreateCompanionBuilder =
    CachedUsersCompanion Function({
      required String serverId,
      required String id,
      required String username,
      required String email,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> nickname,
      Value<String> position,
      Value<String> roles,
      Value<int> rowid,
    });
typedef $$CachedUsersTableUpdateCompanionBuilder =
    CachedUsersCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> username,
      Value<String> email,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> nickname,
      Value<String> position,
      Value<String> roles,
      Value<int> rowid,
    });

class $$CachedUsersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roles => $composableBuilder(
    column: $table.roles,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roles => $composableBuilder(
    column: $table.roles,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get roles =>
      $composableBuilder(column: $table.roles, builder: (column) => column);
}

class $$CachedUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedUsersTable,
          CachedUser,
          $$CachedUsersTableFilterComposer,
          $$CachedUsersTableOrderingComposer,
          $$CachedUsersTableAnnotationComposer,
          $$CachedUsersTableCreateCompanionBuilder,
          $$CachedUsersTableUpdateCompanionBuilder,
          (
            CachedUser,
            BaseReferences<_$AppDatabase, $CachedUsersTable, CachedUser>,
          ),
          CachedUser,
          PrefetchHooks Function()
        > {
  $$CachedUsersTableTableManager(_$AppDatabase db, $CachedUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String> roles = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersCompanion(
                serverId: serverId,
                id: id,
                username: username,
                email: email,
                firstName: firstName,
                lastName: lastName,
                nickname: nickname,
                position: position,
                roles: roles,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String username,
                required String email,
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String> roles = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersCompanion.insert(
                serverId: serverId,
                id: id,
                username: username,
                email: email,
                firstName: firstName,
                lastName: lastName,
                nickname: nickname,
                position: position,
                roles: roles,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedUsersTable,
      CachedUser,
      $$CachedUsersTableFilterComposer,
      $$CachedUsersTableOrderingComposer,
      $$CachedUsersTableAnnotationComposer,
      $$CachedUsersTableCreateCompanionBuilder,
      $$CachedUsersTableUpdateCompanionBuilder,
      (
        CachedUser,
        BaseReferences<_$AppDatabase, $CachedUsersTable, CachedUser>,
      ),
      CachedUser,
      PrefetchHooks Function()
    >;
typedef $$CachedTeamsTableCreateCompanionBuilder =
    CachedTeamsCompanion Function({
      required String serverId,
      required String id,
      required String name,
      required String displayName,
      Value<String> description,
      Value<String> type,
      Value<int> rowid,
    });
typedef $$CachedTeamsTableUpdateCompanionBuilder =
    CachedTeamsCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> name,
      Value<String> displayName,
      Value<String> description,
      Value<String> type,
      Value<int> rowid,
    });

class $$CachedTeamsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTeamsTable> {
  $$CachedTeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTeamsTable> {
  $$CachedTeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTeamsTable> {
  $$CachedTeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$CachedTeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTeamsTable,
          CachedTeam,
          $$CachedTeamsTableFilterComposer,
          $$CachedTeamsTableOrderingComposer,
          $$CachedTeamsTableAnnotationComposer,
          $$CachedTeamsTableCreateCompanionBuilder,
          $$CachedTeamsTableUpdateCompanionBuilder,
          (
            CachedTeam,
            BaseReferences<_$AppDatabase, $CachedTeamsTable, CachedTeam>,
          ),
          CachedTeam,
          PrefetchHooks Function()
        > {
  $$CachedTeamsTableTableManager(_$AppDatabase db, $CachedTeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedTeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTeamsCompanion(
                serverId: serverId,
                id: id,
                name: name,
                displayName: displayName,
                description: description,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String name,
                required String displayName,
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTeamsCompanion.insert(
                serverId: serverId,
                id: id,
                name: name,
                displayName: displayName,
                description: description,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTeamsTable,
      CachedTeam,
      $$CachedTeamsTableFilterComposer,
      $$CachedTeamsTableOrderingComposer,
      $$CachedTeamsTableAnnotationComposer,
      $$CachedTeamsTableCreateCompanionBuilder,
      $$CachedTeamsTableUpdateCompanionBuilder,
      (
        CachedTeam,
        BaseReferences<_$AppDatabase, $CachedTeamsTable, CachedTeam>,
      ),
      CachedTeam,
      PrefetchHooks Function()
    >;
typedef $$CachedChannelsTableCreateCompanionBuilder =
    CachedChannelsCompanion Function({
      required String serverId,
      required String id,
      Value<String> teamId,
      required String name,
      required String displayName,
      Value<String> header,
      Value<String> purpose,
      required String type,
      required int lastPostAt,
      Value<int> totalMsgCount,
      Value<int> rowid,
    });
typedef $$CachedChannelsTableUpdateCompanionBuilder =
    CachedChannelsCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> teamId,
      Value<String> name,
      Value<String> displayName,
      Value<String> header,
      Value<String> purpose,
      Value<String> type,
      Value<int> lastPostAt,
      Value<int> totalMsgCount,
      Value<int> rowid,
    });

class $$CachedChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamId => $composableBuilder(
    column: $table.teamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get header => $composableBuilder(
    column: $table.header,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPostAt => $composableBuilder(
    column: $table.lastPostAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMsgCount => $composableBuilder(
    column: $table.totalMsgCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamId => $composableBuilder(
    column: $table.teamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get header => $composableBuilder(
    column: $table.header,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPostAt => $composableBuilder(
    column: $table.lastPostAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMsgCount => $composableBuilder(
    column: $table.totalMsgCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedChannelsTable> {
  $$CachedChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get teamId =>
      $composableBuilder(column: $table.teamId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get header =>
      $composableBuilder(column: $table.header, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get lastPostAt => $composableBuilder(
    column: $table.lastPostAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMsgCount => $composableBuilder(
    column: $table.totalMsgCount,
    builder: (column) => column,
  );
}

class $$CachedChannelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedChannelsTable,
          CachedChannel,
          $$CachedChannelsTableFilterComposer,
          $$CachedChannelsTableOrderingComposer,
          $$CachedChannelsTableAnnotationComposer,
          $$CachedChannelsTableCreateCompanionBuilder,
          $$CachedChannelsTableUpdateCompanionBuilder,
          (
            CachedChannel,
            BaseReferences<_$AppDatabase, $CachedChannelsTable, CachedChannel>,
          ),
          CachedChannel,
          PrefetchHooks Function()
        > {
  $$CachedChannelsTableTableManager(
    _$AppDatabase db,
    $CachedChannelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> teamId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> header = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> lastPostAt = const Value.absent(),
                Value<int> totalMsgCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelsCompanion(
                serverId: serverId,
                id: id,
                teamId: teamId,
                name: name,
                displayName: displayName,
                header: header,
                purpose: purpose,
                type: type,
                lastPostAt: lastPostAt,
                totalMsgCount: totalMsgCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                Value<String> teamId = const Value.absent(),
                required String name,
                required String displayName,
                Value<String> header = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                required String type,
                required int lastPostAt,
                Value<int> totalMsgCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelsCompanion.insert(
                serverId: serverId,
                id: id,
                teamId: teamId,
                name: name,
                displayName: displayName,
                header: header,
                purpose: purpose,
                type: type,
                lastPostAt: lastPostAt,
                totalMsgCount: totalMsgCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedChannelsTable,
      CachedChannel,
      $$CachedChannelsTableFilterComposer,
      $$CachedChannelsTableOrderingComposer,
      $$CachedChannelsTableAnnotationComposer,
      $$CachedChannelsTableCreateCompanionBuilder,
      $$CachedChannelsTableUpdateCompanionBuilder,
      (
        CachedChannel,
        BaseReferences<_$AppDatabase, $CachedChannelsTable, CachedChannel>,
      ),
      CachedChannel,
      PrefetchHooks Function()
    >;
typedef $$CachedPostsTableCreateCompanionBuilder =
    CachedPostsCompanion Function({
      required String serverId,
      required String id,
      required String channelId,
      required String userId,
      required String message,
      Value<String> rootId,
      required int createAt,
      required int updateAt,
      Value<int> deleteAt,
      Value<String> pendingPostId,
      Value<int> rowid,
    });
typedef $$CachedPostsTableUpdateCompanionBuilder =
    CachedPostsCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> channelId,
      Value<String> userId,
      Value<String> message,
      Value<String> rootId,
      Value<int> createAt,
      Value<int> updateAt,
      Value<int> deleteAt,
      Value<String> pendingPostId,
      Value<int> rowid,
    });

class $$CachedPostsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPostsTable> {
  $$CachedPostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootId => $composableBuilder(
    column: $table.rootId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updateAt => $composableBuilder(
    column: $table.updateAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deleteAt => $composableBuilder(
    column: $table.deleteAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingPostId => $composableBuilder(
    column: $table.pendingPostId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPostsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPostsTable> {
  $$CachedPostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootId => $composableBuilder(
    column: $table.rootId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updateAt => $composableBuilder(
    column: $table.updateAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deleteAt => $composableBuilder(
    column: $table.deleteAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingPostId => $composableBuilder(
    column: $table.pendingPostId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPostsTable> {
  $$CachedPostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get rootId =>
      $composableBuilder(column: $table.rootId, builder: (column) => column);

  GeneratedColumn<int> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<int> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<int> get deleteAt =>
      $composableBuilder(column: $table.deleteAt, builder: (column) => column);

  GeneratedColumn<String> get pendingPostId => $composableBuilder(
    column: $table.pendingPostId,
    builder: (column) => column,
  );
}

class $$CachedPostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPostsTable,
          CachedPost,
          $$CachedPostsTableFilterComposer,
          $$CachedPostsTableOrderingComposer,
          $$CachedPostsTableAnnotationComposer,
          $$CachedPostsTableCreateCompanionBuilder,
          $$CachedPostsTableUpdateCompanionBuilder,
          (
            CachedPost,
            BaseReferences<_$AppDatabase, $CachedPostsTable, CachedPost>,
          ),
          CachedPost,
          PrefetchHooks Function()
        > {
  $$CachedPostsTableTableManager(_$AppDatabase db, $CachedPostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> rootId = const Value.absent(),
                Value<int> createAt = const Value.absent(),
                Value<int> updateAt = const Value.absent(),
                Value<int> deleteAt = const Value.absent(),
                Value<String> pendingPostId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPostsCompanion(
                serverId: serverId,
                id: id,
                channelId: channelId,
                userId: userId,
                message: message,
                rootId: rootId,
                createAt: createAt,
                updateAt: updateAt,
                deleteAt: deleteAt,
                pendingPostId: pendingPostId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String channelId,
                required String userId,
                required String message,
                Value<String> rootId = const Value.absent(),
                required int createAt,
                required int updateAt,
                Value<int> deleteAt = const Value.absent(),
                Value<String> pendingPostId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPostsCompanion.insert(
                serverId: serverId,
                id: id,
                channelId: channelId,
                userId: userId,
                message: message,
                rootId: rootId,
                createAt: createAt,
                updateAt: updateAt,
                deleteAt: deleteAt,
                pendingPostId: pendingPostId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPostsTable,
      CachedPost,
      $$CachedPostsTableFilterComposer,
      $$CachedPostsTableOrderingComposer,
      $$CachedPostsTableAnnotationComposer,
      $$CachedPostsTableCreateCompanionBuilder,
      $$CachedPostsTableUpdateCompanionBuilder,
      (
        CachedPost,
        BaseReferences<_$AppDatabase, $CachedPostsTable, CachedPost>,
      ),
      CachedPost,
      PrefetchHooks Function()
    >;
typedef $$CachedReactionsTableCreateCompanionBuilder =
    CachedReactionsCompanion Function({
      required String serverId,
      required String userId,
      required String postId,
      required String emojiName,
      required int createAt,
      Value<int> rowid,
    });
typedef $$CachedReactionsTableUpdateCompanionBuilder =
    CachedReactionsCompanion Function({
      Value<String> serverId,
      Value<String> userId,
      Value<String> postId,
      Value<String> emojiName,
      Value<int> createAt,
      Value<int> rowid,
    });

class $$CachedReactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedReactionsTable> {
  $$CachedReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emojiName => $composableBuilder(
    column: $table.emojiName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedReactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedReactionsTable> {
  $$CachedReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emojiName => $composableBuilder(
    column: $table.emojiName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedReactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedReactionsTable> {
  $$CachedReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get emojiName =>
      $composableBuilder(column: $table.emojiName, builder: (column) => column);

  GeneratedColumn<int> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);
}

class $$CachedReactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedReactionsTable,
          CachedReaction,
          $$CachedReactionsTableFilterComposer,
          $$CachedReactionsTableOrderingComposer,
          $$CachedReactionsTableAnnotationComposer,
          $$CachedReactionsTableCreateCompanionBuilder,
          $$CachedReactionsTableUpdateCompanionBuilder,
          (
            CachedReaction,
            BaseReferences<
              _$AppDatabase,
              $CachedReactionsTable,
              CachedReaction
            >,
          ),
          CachedReaction,
          PrefetchHooks Function()
        > {
  $$CachedReactionsTableTableManager(
    _$AppDatabase db,
    $CachedReactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> emojiName = const Value.absent(),
                Value<int> createAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedReactionsCompanion(
                serverId: serverId,
                userId: userId,
                postId: postId,
                emojiName: emojiName,
                createAt: createAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String userId,
                required String postId,
                required String emojiName,
                required int createAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedReactionsCompanion.insert(
                serverId: serverId,
                userId: userId,
                postId: postId,
                emojiName: emojiName,
                createAt: createAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedReactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedReactionsTable,
      CachedReaction,
      $$CachedReactionsTableFilterComposer,
      $$CachedReactionsTableOrderingComposer,
      $$CachedReactionsTableAnnotationComposer,
      $$CachedReactionsTableCreateCompanionBuilder,
      $$CachedReactionsTableUpdateCompanionBuilder,
      (
        CachedReaction,
        BaseReferences<_$AppDatabase, $CachedReactionsTable, CachedReaction>,
      ),
      CachedReaction,
      PrefetchHooks Function()
    >;
typedef $$CachedFileInfoTableCreateCompanionBuilder =
    CachedFileInfoCompanion Function({
      required String serverId,
      required String id,
      required String postId,
      required String creatorId,
      required String name,
      required String extension_,
      required int size,
      Value<String> mimeType,
      Value<int> width,
      Value<int> height,
      Value<int> rowid,
    });
typedef $$CachedFileInfoTableUpdateCompanionBuilder =
    CachedFileInfoCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> postId,
      Value<String> creatorId,
      Value<String> name,
      Value<String> extension_,
      Value<int> size,
      Value<String> mimeType,
      Value<int> width,
      Value<int> height,
      Value<int> rowid,
    });

class $$CachedFileInfoTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFileInfoTable> {
  $$CachedFileInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extension_ => $composableBuilder(
    column: $table.extension_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedFileInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFileInfoTable> {
  $$CachedFileInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extension_ => $composableBuilder(
    column: $table.extension_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFileInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFileInfoTable> {
  $$CachedFileInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extension_ => $composableBuilder(
    column: $table.extension_,
    builder: (column) => column,
  );

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);
}

class $$CachedFileInfoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFileInfoTable,
          CachedFileInfoData,
          $$CachedFileInfoTableFilterComposer,
          $$CachedFileInfoTableOrderingComposer,
          $$CachedFileInfoTableAnnotationComposer,
          $$CachedFileInfoTableCreateCompanionBuilder,
          $$CachedFileInfoTableUpdateCompanionBuilder,
          (
            CachedFileInfoData,
            BaseReferences<
              _$AppDatabase,
              $CachedFileInfoTable,
              CachedFileInfoData
            >,
          ),
          CachedFileInfoData,
          PrefetchHooks Function()
        > {
  $$CachedFileInfoTableTableManager(
    _$AppDatabase db,
    $CachedFileInfoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFileInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFileInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFileInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> creatorId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> extension_ = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFileInfoCompanion(
                serverId: serverId,
                id: id,
                postId: postId,
                creatorId: creatorId,
                name: name,
                extension_: extension_,
                size: size,
                mimeType: mimeType,
                width: width,
                height: height,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String postId,
                required String creatorId,
                required String name,
                required String extension_,
                required int size,
                Value<String> mimeType = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFileInfoCompanion.insert(
                serverId: serverId,
                id: id,
                postId: postId,
                creatorId: creatorId,
                name: name,
                extension_: extension_,
                size: size,
                mimeType: mimeType,
                width: width,
                height: height,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedFileInfoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFileInfoTable,
      CachedFileInfoData,
      $$CachedFileInfoTableFilterComposer,
      $$CachedFileInfoTableOrderingComposer,
      $$CachedFileInfoTableAnnotationComposer,
      $$CachedFileInfoTableCreateCompanionBuilder,
      $$CachedFileInfoTableUpdateCompanionBuilder,
      (
        CachedFileInfoData,
        BaseReferences<_$AppDatabase, $CachedFileInfoTable, CachedFileInfoData>,
      ),
      CachedFileInfoData,
      PrefetchHooks Function()
    >;
typedef $$CachedChannelMembersTableCreateCompanionBuilder =
    CachedChannelMembersCompanion Function({
      required String serverId,
      required String channelId,
      required String userId,
      Value<String> roles,
      Value<int> lastViewedAt,
      Value<int> msgCount,
      Value<int> mentionCount,
      Value<int> rowid,
    });
typedef $$CachedChannelMembersTableUpdateCompanionBuilder =
    CachedChannelMembersCompanion Function({
      Value<String> serverId,
      Value<String> channelId,
      Value<String> userId,
      Value<String> roles,
      Value<int> lastViewedAt,
      Value<int> msgCount,
      Value<int> mentionCount,
      Value<int> rowid,
    });

class $$CachedChannelMembersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedChannelMembersTable> {
  $$CachedChannelMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roles => $composableBuilder(
    column: $table.roles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get msgCount => $composableBuilder(
    column: $table.msgCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mentionCount => $composableBuilder(
    column: $table.mentionCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedChannelMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedChannelMembersTable> {
  $$CachedChannelMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roles => $composableBuilder(
    column: $table.roles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get msgCount => $composableBuilder(
    column: $table.msgCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mentionCount => $composableBuilder(
    column: $table.mentionCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedChannelMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedChannelMembersTable> {
  $$CachedChannelMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get roles =>
      $composableBuilder(column: $table.roles, builder: (column) => column);

  GeneratedColumn<int> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get msgCount =>
      $composableBuilder(column: $table.msgCount, builder: (column) => column);

  GeneratedColumn<int> get mentionCount => $composableBuilder(
    column: $table.mentionCount,
    builder: (column) => column,
  );
}

class $$CachedChannelMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedChannelMembersTable,
          CachedChannelMember,
          $$CachedChannelMembersTableFilterComposer,
          $$CachedChannelMembersTableOrderingComposer,
          $$CachedChannelMembersTableAnnotationComposer,
          $$CachedChannelMembersTableCreateCompanionBuilder,
          $$CachedChannelMembersTableUpdateCompanionBuilder,
          (
            CachedChannelMember,
            BaseReferences<
              _$AppDatabase,
              $CachedChannelMembersTable,
              CachedChannelMember
            >,
          ),
          CachedChannelMember,
          PrefetchHooks Function()
        > {
  $$CachedChannelMembersTableTableManager(
    _$AppDatabase db,
    $CachedChannelMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedChannelMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedChannelMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedChannelMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> roles = const Value.absent(),
                Value<int> lastViewedAt = const Value.absent(),
                Value<int> msgCount = const Value.absent(),
                Value<int> mentionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelMembersCompanion(
                serverId: serverId,
                channelId: channelId,
                userId: userId,
                roles: roles,
                lastViewedAt: lastViewedAt,
                msgCount: msgCount,
                mentionCount: mentionCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String channelId,
                required String userId,
                Value<String> roles = const Value.absent(),
                Value<int> lastViewedAt = const Value.absent(),
                Value<int> msgCount = const Value.absent(),
                Value<int> mentionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedChannelMembersCompanion.insert(
                serverId: serverId,
                channelId: channelId,
                userId: userId,
                roles: roles,
                lastViewedAt: lastViewedAt,
                msgCount: msgCount,
                mentionCount: mentionCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedChannelMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedChannelMembersTable,
      CachedChannelMember,
      $$CachedChannelMembersTableFilterComposer,
      $$CachedChannelMembersTableOrderingComposer,
      $$CachedChannelMembersTableAnnotationComposer,
      $$CachedChannelMembersTableCreateCompanionBuilder,
      $$CachedChannelMembersTableUpdateCompanionBuilder,
      (
        CachedChannelMember,
        BaseReferences<
          _$AppDatabase,
          $CachedChannelMembersTable,
          CachedChannelMember
        >,
      ),
      CachedChannelMember,
      PrefetchHooks Function()
    >;
typedef $$CachedUserStatusesTableCreateCompanionBuilder =
    CachedUserStatusesCompanion Function({
      required String serverId,
      required String userId,
      required String status,
      Value<int> lastActivityAt,
      Value<int> rowid,
    });
typedef $$CachedUserStatusesTableUpdateCompanionBuilder =
    CachedUserStatusesCompanion Function({
      Value<String> serverId,
      Value<String> userId,
      Value<String> status,
      Value<int> lastActivityAt,
      Value<int> rowid,
    });

class $$CachedUserStatusesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedUserStatusesTable> {
  $$CachedUserStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedUserStatusesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedUserStatusesTable> {
  $$CachedUserStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedUserStatusesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedUserStatusesTable> {
  $$CachedUserStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get lastActivityAt => $composableBuilder(
    column: $table.lastActivityAt,
    builder: (column) => column,
  );
}

class $$CachedUserStatusesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedUserStatusesTable,
          CachedUserStatuse,
          $$CachedUserStatusesTableFilterComposer,
          $$CachedUserStatusesTableOrderingComposer,
          $$CachedUserStatusesTableAnnotationComposer,
          $$CachedUserStatusesTableCreateCompanionBuilder,
          $$CachedUserStatusesTableUpdateCompanionBuilder,
          (
            CachedUserStatuse,
            BaseReferences<
              _$AppDatabase,
              $CachedUserStatusesTable,
              CachedUserStatuse
            >,
          ),
          CachedUserStatuse,
          PrefetchHooks Function()
        > {
  $$CachedUserStatusesTableTableManager(
    _$AppDatabase db,
    $CachedUserStatusesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedUserStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedUserStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedUserStatusesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> lastActivityAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUserStatusesCompanion(
                serverId: serverId,
                userId: userId,
                status: status,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String userId,
                required String status,
                Value<int> lastActivityAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUserStatusesCompanion.insert(
                serverId: serverId,
                userId: userId,
                status: status,
                lastActivityAt: lastActivityAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedUserStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedUserStatusesTable,
      CachedUserStatuse,
      $$CachedUserStatusesTableFilterComposer,
      $$CachedUserStatusesTableOrderingComposer,
      $$CachedUserStatusesTableAnnotationComposer,
      $$CachedUserStatusesTableCreateCompanionBuilder,
      $$CachedUserStatusesTableUpdateCompanionBuilder,
      (
        CachedUserStatuse,
        BaseReferences<
          _$AppDatabase,
          $CachedUserStatusesTable,
          CachedUserStatuse
        >,
      ),
      CachedUserStatuse,
      PrefetchHooks Function()
    >;
typedef $$CachedPreferencesTableCreateCompanionBuilder =
    CachedPreferencesCompanion Function({
      required String serverId,
      required String userId,
      required String category,
      required String name,
      required String value,
      Value<int> rowid,
    });
typedef $$CachedPreferencesTableUpdateCompanionBuilder =
    CachedPreferencesCompanion Function({
      Value<String> serverId,
      Value<String> userId,
      Value<String> category,
      Value<String> name,
      Value<String> value,
      Value<int> rowid,
    });

class $$CachedPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPreferencesTable> {
  $$CachedPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPreferencesTable> {
  $$CachedPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPreferencesTable> {
  $$CachedPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$CachedPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPreferencesTable,
          CachedPreference,
          $$CachedPreferencesTableFilterComposer,
          $$CachedPreferencesTableOrderingComposer,
          $$CachedPreferencesTableAnnotationComposer,
          $$CachedPreferencesTableCreateCompanionBuilder,
          $$CachedPreferencesTableUpdateCompanionBuilder,
          (
            CachedPreference,
            BaseReferences<
              _$AppDatabase,
              $CachedPreferencesTable,
              CachedPreference
            >,
          ),
          CachedPreference,
          PrefetchHooks Function()
        > {
  $$CachedPreferencesTableTableManager(
    _$AppDatabase db,
    $CachedPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPreferencesCompanion(
                serverId: serverId,
                userId: userId,
                category: category,
                name: name,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String userId,
                required String category,
                required String name,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => CachedPreferencesCompanion.insert(
                serverId: serverId,
                userId: userId,
                category: category,
                name: name,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPreferencesTable,
      CachedPreference,
      $$CachedPreferencesTableFilterComposer,
      $$CachedPreferencesTableOrderingComposer,
      $$CachedPreferencesTableAnnotationComposer,
      $$CachedPreferencesTableCreateCompanionBuilder,
      $$CachedPreferencesTableUpdateCompanionBuilder,
      (
        CachedPreference,
        BaseReferences<
          _$AppDatabase,
          $CachedPreferencesTable,
          CachedPreference
        >,
      ),
      CachedPreference,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String serverId,
      required String key,
      required int lastSyncAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> serverId,
      Value<String> key,
      Value<int> lastSyncAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<int> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                serverId: serverId,
                key: key,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String key,
                required int lastSyncAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                serverId: serverId,
                key: key,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;
typedef $$PendingActionsTableCreateCompanionBuilder =
    PendingActionsCompanion Function({
      Value<int> id,
      required String serverId,
      required String actionType,
      required String payloadJson,
      required int createdAt,
      Value<int> retryCount,
      Value<String> status,
      Value<String> tempId,
    });
typedef $$PendingActionsTableUpdateCompanionBuilder =
    PendingActionsCompanion Function({
      Value<int> id,
      Value<String> serverId,
      Value<String> actionType,
      Value<String> payloadJson,
      Value<int> createdAt,
      Value<int> retryCount,
      Value<String> status,
      Value<String> tempId,
    });

class $$PendingActionsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingActionsTable> {
  $$PendingActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);
}

class $$PendingActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingActionsTable,
          PendingAction,
          $$PendingActionsTableFilterComposer,
          $$PendingActionsTableOrderingComposer,
          $$PendingActionsTableAnnotationComposer,
          $$PendingActionsTableCreateCompanionBuilder,
          $$PendingActionsTableUpdateCompanionBuilder,
          (
            PendingAction,
            BaseReferences<_$AppDatabase, $PendingActionsTable, PendingAction>,
          ),
          PendingAction,
          PrefetchHooks Function()
        > {
  $$PendingActionsTableTableManager(
    _$AppDatabase db,
    $PendingActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> tempId = const Value.absent(),
              }) => PendingActionsCompanion(
                id: id,
                serverId: serverId,
                actionType: actionType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                retryCount: retryCount,
                status: status,
                tempId: tempId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String serverId,
                required String actionType,
                required String payloadJson,
                required int createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> tempId = const Value.absent(),
              }) => PendingActionsCompanion.insert(
                id: id,
                serverId: serverId,
                actionType: actionType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                retryCount: retryCount,
                status: status,
                tempId: tempId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingActionsTable,
      PendingAction,
      $$PendingActionsTableFilterComposer,
      $$PendingActionsTableOrderingComposer,
      $$PendingActionsTableAnnotationComposer,
      $$PendingActionsTableCreateCompanionBuilder,
      $$PendingActionsTableUpdateCompanionBuilder,
      (
        PendingAction,
        BaseReferences<_$AppDatabase, $PendingActionsTable, PendingAction>,
      ),
      PendingAction,
      PrefetchHooks Function()
    >;
typedef $$CachedRolesTableCreateCompanionBuilder =
    CachedRolesCompanion Function({
      required String serverId,
      required String name,
      required String id,
      Value<String> displayName,
      required String permissions,
      Value<bool> schemeManaged,
      Value<int> rowid,
    });
typedef $$CachedRolesTableUpdateCompanionBuilder =
    CachedRolesCompanion Function({
      Value<String> serverId,
      Value<String> name,
      Value<String> id,
      Value<String> displayName,
      Value<String> permissions,
      Value<bool> schemeManaged,
      Value<int> rowid,
    });

class $$CachedRolesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedRolesTable> {
  $$CachedRolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get schemeManaged => $composableBuilder(
    column: $table.schemeManaged,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedRolesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedRolesTable> {
  $$CachedRolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get schemeManaged => $composableBuilder(
    column: $table.schemeManaged,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedRolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedRolesTable> {
  $$CachedRolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get schemeManaged => $composableBuilder(
    column: $table.schemeManaged,
    builder: (column) => column,
  );
}

class $$CachedRolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedRolesTable,
          CachedRole,
          $$CachedRolesTableFilterComposer,
          $$CachedRolesTableOrderingComposer,
          $$CachedRolesTableAnnotationComposer,
          $$CachedRolesTableCreateCompanionBuilder,
          $$CachedRolesTableUpdateCompanionBuilder,
          (
            CachedRole,
            BaseReferences<_$AppDatabase, $CachedRolesTable, CachedRole>,
          ),
          CachedRole,
          PrefetchHooks Function()
        > {
  $$CachedRolesTableTableManager(_$AppDatabase db, $CachedRolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> permissions = const Value.absent(),
                Value<bool> schemeManaged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedRolesCompanion(
                serverId: serverId,
                name: name,
                id: id,
                displayName: displayName,
                permissions: permissions,
                schemeManaged: schemeManaged,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String name,
                required String id,
                Value<String> displayName = const Value.absent(),
                required String permissions,
                Value<bool> schemeManaged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedRolesCompanion.insert(
                serverId: serverId,
                name: name,
                id: id,
                displayName: displayName,
                permissions: permissions,
                schemeManaged: schemeManaged,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedRolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedRolesTable,
      CachedRole,
      $$CachedRolesTableFilterComposer,
      $$CachedRolesTableOrderingComposer,
      $$CachedRolesTableAnnotationComposer,
      $$CachedRolesTableCreateCompanionBuilder,
      $$CachedRolesTableUpdateCompanionBuilder,
      (
        CachedRole,
        BaseReferences<_$AppDatabase, $CachedRolesTable, CachedRole>,
      ),
      CachedRole,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db, _db.servers);
  $$CachedUsersTableTableManager get cachedUsers =>
      $$CachedUsersTableTableManager(_db, _db.cachedUsers);
  $$CachedTeamsTableTableManager get cachedTeams =>
      $$CachedTeamsTableTableManager(_db, _db.cachedTeams);
  $$CachedChannelsTableTableManager get cachedChannels =>
      $$CachedChannelsTableTableManager(_db, _db.cachedChannels);
  $$CachedPostsTableTableManager get cachedPosts =>
      $$CachedPostsTableTableManager(_db, _db.cachedPosts);
  $$CachedReactionsTableTableManager get cachedReactions =>
      $$CachedReactionsTableTableManager(_db, _db.cachedReactions);
  $$CachedFileInfoTableTableManager get cachedFileInfo =>
      $$CachedFileInfoTableTableManager(_db, _db.cachedFileInfo);
  $$CachedChannelMembersTableTableManager get cachedChannelMembers =>
      $$CachedChannelMembersTableTableManager(_db, _db.cachedChannelMembers);
  $$CachedUserStatusesTableTableManager get cachedUserStatuses =>
      $$CachedUserStatusesTableTableManager(_db, _db.cachedUserStatuses);
  $$CachedPreferencesTableTableManager get cachedPreferences =>
      $$CachedPreferencesTableTableManager(_db, _db.cachedPreferences);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$PendingActionsTableTableManager get pendingActions =>
      $$PendingActionsTableTableManager(_db, _db.pendingActions);
  $$CachedRolesTableTableManager get cachedRoles =>
      $$CachedRolesTableTableManager(_db, _db.cachedRoles);
}
