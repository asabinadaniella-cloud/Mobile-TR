// GENERATED CODE - MANUALLY WRITTEN
// ignore_for_file: type=lint
part of 'app_database.dart';

abstract class _\$AppDatabase extends GeneratedDatabase {
  _\$AppDatabase(QueryExecutor e) : super(e);

  late final UsersTable users = UsersTable(this);
  late final ProfilesTable profiles = ProfilesTable(this);
  late final SurveyVersionsTable surveyVersions = SurveyVersionsTable(this);
  late final SurveySectionsTable surveySections = SurveySectionsTable(this);
  late final QuestionsTable questions = QuestionsTable(this);
  late final QuestionOptionsTable questionOptions = QuestionOptionsTable(this);
  late final ResponsesTable responses = ResponsesTable(this);
  late final ReportsTable reports = ReportsTable(this);
  late final ChatsTable chats = ChatsTable(this);
  late final MessagesTable messages = MessagesTable(this);
  late final FilesTable files = FilesTable(this);
  late final PushTokensTable pushTokens = PushTokensTable(this);
  late final AuditLogTable auditLog = AuditLogTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [
        users,
        profiles,
        surveyVersions,
        surveySections,
        questions,
        questionOptions,
        responses,
        reports,
        chats,
        messages,
        files,
        pushTokens,
        auditLog
      ];

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => allTables.toList();
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const User({required this.id, this.email, this.phoneNumber, this.role, required this.status, required this.createdAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: email == null && nullToAbsent ? const Value.absent() : Value(email),
      phoneNumber: phoneNumber == null && nullToAbsent ? const Value.absent() : Value(phoneNumber),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      role: serializer.fromJson<String?>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String?>(email),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'role': serializer.toJson<String?>(role),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  User copyWith({
    String? id,
    Value<String?>? email = const Value.absent(),
    Value<String?>? phoneNumber = const Value.absent(),
    Value<String?>? role = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return User(
      id: id ?? this.id,
      email: email != null && email!.present ? email!.value : this.email,
      phoneNumber: phoneNumber != null && phoneNumber!.present ? phoneNumber!.value : this.phoneNumber,
      role: role != null && role!.present ? role!.value : this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, email, phoneNumber, role, status, createdAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is User && other.id == id && other.email == email && other.phoneNumber == phoneNumber && other.role == role && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'User(id: ${id}, email: ${email}, phoneNumber: ${phoneNumber}, role: ${role}, status: ${status}, createdAt: ${createdAt}, updatedAt: ${updatedAt})';
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> email;
  final Value<String?> phoneNumber;
  final Value<String?> role;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const UsersCompanion({this.id = const Value.absent(), this.email = const Value.absent(), this.phoneNumber = const Value.absent(), this.role = const Value.absent(), this.status = const Value.absent(), this.createdAt = const Value.absent(), this.updatedAt = const Value.absent()});

  UsersCompanion.insert({
    required String id,
    this.email = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        email = this.email,
        phoneNumber = this.phoneNumber,
        role = this.role,
        status = this.status,
        createdAt = this.createdAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String?>? email,
    Expression<String?>? phoneNumber,
    Expression<String?>? role,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? email,
    Value<String?>? phoneNumber,
    Value<String?>? role,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class UsersTable extends Users with TableInfo<UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UsersTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> email = GeneratedColumn<String>('email', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>('phone_number', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> role = GeneratedColumn<String>('role', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> status = GeneratedColumn<String>('status', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: false, defaultValue: const Constant('active'));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        phoneNumber,
        role,
        status,
        createdAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<User> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('email')) {
      context.handle(const VerificationMeta('email'), email.isAcceptableOrUnknown(data['email']!, const VerificationMeta('email')));
    }
    if (data.containsKey('phone_number')) {
      context.handle(const VerificationMeta('phoneNumber'), phoneNumber.isAcceptableOrUnknown(data['phone_number']!, const VerificationMeta('phoneNumber')));
    }
    if (data.containsKey('role')) {
      context.handle(const VerificationMeta('role'), role.isAcceptableOrUnknown(data['role']!, const VerificationMeta('role')));
    }
    if (data.containsKey('status')) {
      context.handle(const VerificationMeta('status'), status.isAcceptableOrUnknown(data['status']!, const VerificationMeta('status')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}email']),
      phoneNumber: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      role: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}role']),
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  UsersTable createAlias(String alias) => UsersTable(attachedDatabase, alias);
}

mixin _UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  UsersTable get users => attachedDatabase.users;
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime? birthDate;
  final String? gender;
  final String? avatarUrl;
  final String? city;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Profile({required this.id, required this.userId, this.firstName, this.lastName, this.middleName, this.birthDate, this.gender, this.avatarUrl, this.city, required this.createdAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      userId: Value(userId),
      firstName: firstName == null && nullToAbsent ? const Value.absent() : Value(firstName),
      lastName: lastName == null && nullToAbsent ? const Value.absent() : Value(lastName),
      middleName: middleName == null && nullToAbsent ? const Value.absent() : Value(middleName),
      birthDate: birthDate == null && nullToAbsent ? const Value.absent() : Value(birthDate),
      gender: gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      avatarUrl: avatarUrl == null && nullToAbsent ? const Value.absent() : Value(avatarUrl),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      city: serializer.fromJson<String?>(json['city']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'middleName': serializer.toJson<String?>(middleName),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'city': serializer.toJson<String?>(city),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Profile copyWith({
    String? id,
    String? userId,
    Value<String?>? firstName = const Value.absent(),
    Value<String?>? lastName = const Value.absent(),
    Value<String?>? middleName = const Value.absent(),
    Value<DateTime?>? birthDate = const Value.absent(),
    Value<String?>? gender = const Value.absent(),
    Value<String?>? avatarUrl = const Value.absent(),
    Value<String?>? city = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName != null && firstName!.present ? firstName!.value : this.firstName,
      lastName: lastName != null && lastName!.present ? lastName!.value : this.lastName,
      middleName: middleName != null && middleName!.present ? middleName!.value : this.middleName,
      birthDate: birthDate != null && birthDate!.present ? birthDate!.value : this.birthDate,
      gender: gender != null && gender!.present ? gender!.value : this.gender,
      avatarUrl: avatarUrl != null && avatarUrl!.present ? avatarUrl!.value : this.avatarUrl,
      city: city != null && city!.present ? city!.value : this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, userId, firstName, lastName, middleName, birthDate, gender, avatarUrl, city, createdAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Profile && other.id == id && other.userId == userId && other.firstName == firstName && other.lastName == lastName && other.middleName == middleName && other.birthDate == birthDate && other.gender == gender && other.avatarUrl == avatarUrl && other.city == city && other.createdAt == createdAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'Profile(id: ${id}, userId: ${userId}, firstName: ${firstName}, lastName: ${lastName}, middleName: ${middleName}, birthDate: ${birthDate}, gender: ${gender}, avatarUrl: ${avatarUrl}, city: ${city}, createdAt: ${createdAt}, updatedAt: ${updatedAt})';
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> middleName;
  final Value<DateTime?> birthDate;
  final Value<String?> gender;
  final Value<String?> avatarUrl;
  final Value<String?> city;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ProfilesCompanion({this.id = const Value.absent(), this.userId = const Value.absent(), this.firstName = const Value.absent(), this.lastName = const Value.absent(), this.middleName = const Value.absent(), this.birthDate = const Value.absent(), this.gender = const Value.absent(), this.avatarUrl = const Value.absent(), this.city = const Value.absent(), this.createdAt = const Value.absent(), this.updatedAt = const Value.absent()});

  ProfilesCompanion.insert({
    required String id,
    required String userId,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.city = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        userId = Value(userId),
        firstName = this.firstName,
        lastName = this.lastName,
        middleName = this.middleName,
        birthDate = this.birthDate,
        gender = this.gender,
        avatarUrl = this.avatarUrl,
        city = this.city,
        createdAt = this.createdAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String?>? firstName,
    Expression<String?>? lastName,
    Expression<String?>? middleName,
    Expression<DateTime?>? birthDate,
    Expression<String?>? gender,
    Expression<String?>? avatarUrl,
    Expression<String?>? city,
    Expression<DateTime>? createdAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (middleName != null) 'middle_name': middleName,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (city != null) 'city': city,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? firstName,
    Value<String?>? lastName,
    Value<String?>? middleName,
    Value<DateTime?>? birthDate,
    Value<String?>? gender,
    Value<String?>? avatarUrl,
    Value<String?>? city,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class ProfilesTable extends Profiles with TableInfo<ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProfilesTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> userId = GeneratedColumn<String>('user_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>('first_name', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>('last_name', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>('middle_name', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>('birth_date', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  late final GeneratedColumn<String> gender = GeneratedColumn<String>('gender', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>('avatar_url', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> city = GeneratedColumn<String>('city', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        firstName,
        lastName,
        middleName,
        birthDate,
        gender,
        avatarUrl,
        city,
        createdAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'profiles';
  @override
  String get actualTableName => 'profiles';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [{userId}];

  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('user_id')) {
      context.handle(const VerificationMeta('userId'), userId.isAcceptableOrUnknown(data['user_id']!, const VerificationMeta('userId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('userId'));
    }
    if (data.containsKey('first_name')) {
      context.handle(const VerificationMeta('firstName'), firstName.isAcceptableOrUnknown(data['first_name']!, const VerificationMeta('firstName')));
    }
    if (data.containsKey('last_name')) {
      context.handle(const VerificationMeta('lastName'), lastName.isAcceptableOrUnknown(data['last_name']!, const VerificationMeta('lastName')));
    }
    if (data.containsKey('middle_name')) {
      context.handle(const VerificationMeta('middleName'), middleName.isAcceptableOrUnknown(data['middle_name']!, const VerificationMeta('middleName')));
    }
    if (data.containsKey('birth_date')) {
      context.handle(const VerificationMeta('birthDate'), birthDate.isAcceptableOrUnknown(data['birth_date']!, const VerificationMeta('birthDate')));
    }
    if (data.containsKey('gender')) {
      context.handle(const VerificationMeta('gender'), gender.isAcceptableOrUnknown(data['gender']!, const VerificationMeta('gender')));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(const VerificationMeta('avatarUrl'), avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, const VerificationMeta('avatarUrl')));
    }
    if (data.containsKey('city')) {
      context.handle(const VerificationMeta('city'), city.isAcceptableOrUnknown(data['city']!, const VerificationMeta('city')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      firstName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      lastName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      middleName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}middle_name']),
      birthDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date']),
      gender: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}gender']),
      avatarUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      city: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}city']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  ProfilesTable createAlias(String alias) => ProfilesTable(attachedDatabase, alias);
}

mixin _ProfilesDaoMixin on DatabaseAccessor<AppDatabase> {
  ProfilesTable get profiles => attachedDatabase.profiles;
}

class SurveyVersion extends DataClass implements Insertable<SurveyVersion> {
  final String id;
  final int versionNumber;
  final String title;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? publishedAt;
  const SurveyVersion({required this.id, required this.versionNumber, required this.title, this.description, required this.isActive, required this.createdAt, this.publishedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version_number'] = Variable<int>(versionNumber);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    return map;
  }

  SurveyVersionsCompanion toCompanion(bool nullToAbsent) {
    return SurveyVersionsCompanion(
      id: Value(id),
      versionNumber: Value(versionNumber),
      title: Value(title),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      publishedAt: publishedAt == null && nullToAbsent ? const Value.absent() : Value(publishedAt),
    );
  }

  factory SurveyVersion.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurveyVersion(
      id: serializer.fromJson<String>(json['id']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
    };
  }

  SurveyVersion copyWith({
    String? id,
    int? versionNumber,
    String? title,
    Value<String?>? description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    Value<DateTime?>? publishedAt = const Value.absent(),
  }) {
    return SurveyVersion(
      id: id ?? this.id,
      versionNumber: versionNumber ?? this.versionNumber,
      title: title ?? this.title,
      description: description != null && description!.present ? description!.value : this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt != null && publishedAt!.present ? publishedAt!.value : this.publishedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, versionNumber, title, description, isActive, createdAt, publishedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is SurveyVersion && other.id == id && other.versionNumber == versionNumber && other.title == title && other.description == description && other.isActive == isActive && other.createdAt == createdAt && other.publishedAt == publishedAt);
  @override
  String toString() => 'SurveyVersion(id: ${id}, versionNumber: ${versionNumber}, title: ${title}, description: ${description}, isActive: ${isActive}, createdAt: ${createdAt}, publishedAt: ${publishedAt})';
}

class SurveyVersionsCompanion extends UpdateCompanion<SurveyVersion> {
  final Value<String> id;
  final Value<int> versionNumber;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime?> publishedAt;
  const SurveyVersionsCompanion({this.id = const Value.absent(), this.versionNumber = const Value.absent(), this.title = const Value.absent(), this.description = const Value.absent(), this.isActive = const Value.absent(), this.createdAt = const Value.absent(), this.publishedAt = const Value.absent()});

  SurveyVersionsCompanion.insert({
    required String id,
    required int versionNumber,
    required String title,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.publishedAt = const Value.absent(),
  }) :
        id = Value(id),
        versionNumber = Value(versionNumber),
        title = Value(title),
        description = this.description,
        isActive = this.isActive,
        createdAt = this.createdAt,
        publishedAt = this.publishedAt,
        ;

  static Insertable<SurveyVersion> custom({
    Expression<String>? id,
    Expression<int>? versionNumber,
    Expression<String>? title,
    Expression<String?>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime?>? publishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (versionNumber != null) 'version_number': versionNumber,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (publishedAt != null) 'published_at': publishedAt,
    });
  }

  SurveyVersionsCompanion copyWith({
    Value<String>? id,
    Value<int>? versionNumber,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime?>? publishedAt,
  }) {
    return SurveyVersionsCompanion(
      id: id ?? this.id,
      versionNumber: versionNumber ?? this.versionNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    return map;
  }

}

class SurveyVersionsTable extends SurveyVersions with TableInfo<SurveyVersionsTable, SurveyVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SurveyVersionsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>('version_number', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: true);
  late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(false));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>('published_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        versionNumber,
        title,
        description,
        isActive,
        createdAt,
        publishedAt
      ];

  @override
  String get aliasedName => _alias ?? 'survey_versions';
  @override
  String get actualTableName => 'survey_versions';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [{versionNumber}];

  @override
  VerificationContext validateIntegrity(Insertable<SurveyVersion> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('version_number')) {
      context.handle(const VerificationMeta('versionNumber'), versionNumber.isAcceptableOrUnknown(data['version_number']!, const VerificationMeta('versionNumber')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('versionNumber'));
    }
    if (data.containsKey('title')) {
      context.handle(const VerificationMeta('title'), title.isAcceptableOrUnknown(data['title']!, const VerificationMeta('title')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('title'));
    }
    if (data.containsKey('description')) {
      context.handle(const VerificationMeta('description'), description.isAcceptableOrUnknown(data['description']!, const VerificationMeta('description')));
    }
    if (data.containsKey('is_active')) {
      context.handle(const VerificationMeta('isActive'), isActive.isAcceptableOrUnknown(data['is_active']!, const VerificationMeta('isActive')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    if (data.containsKey('published_at')) {
      context.handle(const VerificationMeta('publishedAt'), publishedAt.isAcceptableOrUnknown(data['published_at']!, const VerificationMeta('publishedAt')));
    }
    return context;
  }

  @override
  SurveyVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurveyVersion(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      versionNumber: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}version_number'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      publishedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}published_at'])
    );
  }

  @override
  SurveyVersionsTable createAlias(String alias) => SurveyVersionsTable(attachedDatabase, alias);
}

mixin _SurveyVersionsDaoMixin on DatabaseAccessor<AppDatabase> {
  SurveyVersionsTable get surveyVersions => attachedDatabase.surveyVersions;
}

class SurveySection extends DataClass implements Insertable<SurveySection> {
  final String id;
  final String surveyVersionId;
  final String title;
  final String? description;
  final int position;
  final DateTime createdAt;
  const SurveySection({required this.id, required this.surveyVersionId, required this.title, this.description, required this.position, required this.createdAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['survey_version_id'] = Variable<String>(surveyVersionId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SurveySectionsCompanion toCompanion(bool nullToAbsent) {
    return SurveySectionsCompanion(
      id: Value(id),
      surveyVersionId: Value(surveyVersionId),
      title: Value(title),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory SurveySection.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurveySection(
      id: serializer.fromJson<String>(json['id']),
      surveyVersionId: serializer.fromJson<String>(json['surveyVersionId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveyVersionId': serializer.toJson<String>(surveyVersionId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SurveySection copyWith({
    String? id,
    String? surveyVersionId,
    String? title,
    Value<String?>? description = const Value.absent(),
    int? position,
    DateTime? createdAt,
  }) {
    return SurveySection(
      id: id ?? this.id,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      title: title ?? this.title,
      description: description != null && description!.present ? description!.value : this.description,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, surveyVersionId, title, description, position, createdAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is SurveySection && other.id == id && other.surveyVersionId == surveyVersionId && other.title == title && other.description == description && other.position == position && other.createdAt == createdAt);
  @override
  String toString() => 'SurveySection(id: ${id}, surveyVersionId: ${surveyVersionId}, title: ${title}, description: ${description}, position: ${position}, createdAt: ${createdAt})';
}

class SurveySectionsCompanion extends UpdateCompanion<SurveySection> {
  final Value<String> id;
  final Value<String> surveyVersionId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> position;
  final Value<DateTime> createdAt;
  const SurveySectionsCompanion({this.id = const Value.absent(), this.surveyVersionId = const Value.absent(), this.title = const Value.absent(), this.description = const Value.absent(), this.position = const Value.absent(), this.createdAt = const Value.absent()});

  SurveySectionsCompanion.insert({
    required String id,
    required String surveyVersionId,
    required String title,
    this.description = const Value.absent(),
    required int position,
    this.createdAt = const Value.absent(),
  }) :
        id = Value(id),
        surveyVersionId = Value(surveyVersionId),
        title = Value(title),
        description = this.description,
        position = Value(position),
        createdAt = this.createdAt,
        ;

  static Insertable<SurveySection> custom({
    Expression<String>? id,
    Expression<String>? surveyVersionId,
    Expression<String>? title,
    Expression<String?>? description,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyVersionId != null) 'survey_version_id': surveyVersionId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SurveySectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? surveyVersionId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? position,
    Value<DateTime>? createdAt,
  }) {
    return SurveySectionsCompanion(
      id: id ?? this.id,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveyVersionId.present) {
      map['survey_version_id'] = Variable<String>(surveyVersionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

}

class SurveySectionsTable extends SurveySections with TableInfo<SurveySectionsTable, SurveySection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SurveySectionsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> surveyVersionId = GeneratedColumn<String>('survey_version_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES survey_versions(id)'));
  late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<int> position = GeneratedColumn<int>('position', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surveyVersionId,
        title,
        description,
        position,
        createdAt
      ];

  @override
  String get aliasedName => _alias ?? 'survey_sections';
  @override
  String get actualTableName => 'survey_sections';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<SurveySection> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('survey_version_id')) {
      context.handle(const VerificationMeta('surveyVersionId'), surveyVersionId.isAcceptableOrUnknown(data['survey_version_id']!, const VerificationMeta('surveyVersionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('surveyVersionId'));
    }
    if (data.containsKey('title')) {
      context.handle(const VerificationMeta('title'), title.isAcceptableOrUnknown(data['title']!, const VerificationMeta('title')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('title'));
    }
    if (data.containsKey('description')) {
      context.handle(const VerificationMeta('description'), description.isAcceptableOrUnknown(data['description']!, const VerificationMeta('description')));
    }
    if (data.containsKey('position')) {
      context.handle(const VerificationMeta('position'), position.isAcceptableOrUnknown(data['position']!, const VerificationMeta('position')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('position'));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    return context;
  }

  @override
  SurveySection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurveySection(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      surveyVersionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}survey_version_id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!
    );
  }

  @override
  SurveySectionsTable createAlias(String alias) => SurveySectionsTable(attachedDatabase, alias);
}

mixin _SurveySectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  SurveySectionsTable get surveySections => attachedDatabase.surveySections;
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String surveySectionId;
  final String surveyVersionId;
  final String questionType;
  final String text;
  final String? helpText;
  final bool isRequired;
  final int position;
  final String? validationRules;
  const Question({required this.id, required this.surveySectionId, required this.surveyVersionId, required this.questionType, required this.text, this.helpText, required this.isRequired, required this.position, this.validationRules});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['survey_section_id'] = Variable<String>(surveySectionId);
    map['survey_version_id'] = Variable<String>(surveyVersionId);
    map['question_type'] = Variable<String>(questionType);
    map['text'] = Variable<String>(text);
    if (!nullToAbsent || helpText != null) {
      map['help_text'] = Variable<String>(helpText);
    }
    map['is_required'] = Variable<bool>(isRequired);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || validationRules != null) {
      map['validation_rules'] = Variable<String>(validationRules);
    }
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      surveySectionId: Value(surveySectionId),
      surveyVersionId: Value(surveyVersionId),
      questionType: Value(questionType),
      text: Value(text),
      helpText: helpText == null && nullToAbsent ? const Value.absent() : Value(helpText),
      isRequired: Value(isRequired),
      position: Value(position),
      validationRules: validationRules == null && nullToAbsent ? const Value.absent() : Value(validationRules),
    );
  }

  factory Question.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      surveySectionId: serializer.fromJson<String>(json['surveySectionId']),
      surveyVersionId: serializer.fromJson<String>(json['surveyVersionId']),
      questionType: serializer.fromJson<String>(json['questionType']),
      text: serializer.fromJson<String>(json['text']),
      helpText: serializer.fromJson<String?>(json['helpText']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      position: serializer.fromJson<int>(json['position']),
      validationRules: serializer.fromJson<String?>(json['validationRules']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveySectionId': serializer.toJson<String>(surveySectionId),
      'surveyVersionId': serializer.toJson<String>(surveyVersionId),
      'questionType': serializer.toJson<String>(questionType),
      'text': serializer.toJson<String>(text),
      'helpText': serializer.toJson<String?>(helpText),
      'isRequired': serializer.toJson<bool>(isRequired),
      'position': serializer.toJson<int>(position),
      'validationRules': serializer.toJson<String?>(validationRules),
    };
  }

  Question copyWith({
    String? id,
    String? surveySectionId,
    String? surveyVersionId,
    String? questionType,
    String? text,
    Value<String?>? helpText = const Value.absent(),
    bool? isRequired,
    int? position,
    Value<String?>? validationRules = const Value.absent(),
  }) {
    return Question(
      id: id ?? this.id,
      surveySectionId: surveySectionId ?? this.surveySectionId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      questionType: questionType ?? this.questionType,
      text: text ?? this.text,
      helpText: helpText != null && helpText!.present ? helpText!.value : this.helpText,
      isRequired: isRequired ?? this.isRequired,
      position: position ?? this.position,
      validationRules: validationRules != null && validationRules!.present ? validationRules!.value : this.validationRules,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, surveySectionId, surveyVersionId, questionType, text, helpText, isRequired, position, validationRules]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Question && other.id == id && other.surveySectionId == surveySectionId && other.surveyVersionId == surveyVersionId && other.questionType == questionType && other.text == text && other.helpText == helpText && other.isRequired == isRequired && other.position == position && other.validationRules == validationRules);
  @override
  String toString() => 'Question(id: ${id}, surveySectionId: ${surveySectionId}, surveyVersionId: ${surveyVersionId}, questionType: ${questionType}, text: ${text}, helpText: ${helpText}, isRequired: ${isRequired}, position: ${position}, validationRules: ${validationRules})';
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> surveySectionId;
  final Value<String> surveyVersionId;
  final Value<String> questionType;
  final Value<String> text;
  final Value<String?> helpText;
  final Value<bool> isRequired;
  final Value<int> position;
  final Value<String?> validationRules;
  const QuestionsCompanion({this.id = const Value.absent(), this.surveySectionId = const Value.absent(), this.surveyVersionId = const Value.absent(), this.questionType = const Value.absent(), this.text = const Value.absent(), this.helpText = const Value.absent(), this.isRequired = const Value.absent(), this.position = const Value.absent(), this.validationRules = const Value.absent()});

  QuestionsCompanion.insert({
    required String id,
    required String surveySectionId,
    required String surveyVersionId,
    required String questionType,
    required String text,
    this.helpText = const Value.absent(),
    this.isRequired = const Value.absent(),
    required int position,
    this.validationRules = const Value.absent(),
  }) :
        id = Value(id),
        surveySectionId = Value(surveySectionId),
        surveyVersionId = Value(surveyVersionId),
        questionType = Value(questionType),
        text = Value(text),
        helpText = this.helpText,
        isRequired = this.isRequired,
        position = Value(position),
        validationRules = this.validationRules,
        ;

  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? surveySectionId,
    Expression<String>? surveyVersionId,
    Expression<String>? questionType,
    Expression<String>? text,
    Expression<String?>? helpText,
    Expression<bool>? isRequired,
    Expression<int>? position,
    Expression<String?>? validationRules,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveySectionId != null) 'survey_section_id': surveySectionId,
      if (surveyVersionId != null) 'survey_version_id': surveyVersionId,
      if (questionType != null) 'question_type': questionType,
      if (text != null) 'text': text,
      if (helpText != null) 'help_text': helpText,
      if (isRequired != null) 'is_required': isRequired,
      if (position != null) 'position': position,
      if (validationRules != null) 'validation_rules': validationRules,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? surveySectionId,
    Value<String>? surveyVersionId,
    Value<String>? questionType,
    Value<String>? text,
    Value<String?>? helpText,
    Value<bool>? isRequired,
    Value<int>? position,
    Value<String?>? validationRules,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      surveySectionId: surveySectionId ?? this.surveySectionId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      questionType: questionType ?? this.questionType,
      text: text ?? this.text,
      helpText: helpText ?? this.helpText,
      isRequired: isRequired ?? this.isRequired,
      position: position ?? this.position,
      validationRules: validationRules ?? this.validationRules,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveySectionId.present) {
      map['survey_section_id'] = Variable<String>(surveySectionId.value);
    }
    if (surveyVersionId.present) {
      map['survey_version_id'] = Variable<String>(surveyVersionId.value);
    }
    if (questionType.present) {
      map['question_type'] = Variable<String>(questionType.value);
    }
    if (text.present) {
      map['text'] = Variable<String>(text.value);
    }
    if (helpText.present) {
      map['help_text'] = Variable<String>(helpText.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (validationRules.present) {
      map['validation_rules'] = Variable<String>(validationRules.value);
    }
    return map;
  }

}

class QuestionsTable extends Questions with TableInfo<QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  QuestionsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> surveySectionId = GeneratedColumn<String>('survey_section_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES survey_sections(id)'));
  late final GeneratedColumn<String> surveyVersionId = GeneratedColumn<String>('survey_version_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES survey_versions(id)'));
  late final GeneratedColumn<String> questionType = GeneratedColumn<String>('question_type', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> text = GeneratedColumn<String>('text', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> helpText = GeneratedColumn<String>('help_text', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>('is_required', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(false));
  late final GeneratedColumn<int> position = GeneratedColumn<int>('position', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: true);
  late final GeneratedColumn<String> validationRules = GeneratedColumn<String>('validation_rules', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surveySectionId,
        surveyVersionId,
        questionType,
        text,
        helpText,
        isRequired,
        position,
        validationRules
      ];

  @override
  String get aliasedName => _alias ?? 'questions';
  @override
  String get actualTableName => 'questions';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<Question> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('survey_section_id')) {
      context.handle(const VerificationMeta('surveySectionId'), surveySectionId.isAcceptableOrUnknown(data['survey_section_id']!, const VerificationMeta('surveySectionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('surveySectionId'));
    }
    if (data.containsKey('survey_version_id')) {
      context.handle(const VerificationMeta('surveyVersionId'), surveyVersionId.isAcceptableOrUnknown(data['survey_version_id']!, const VerificationMeta('surveyVersionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('surveyVersionId'));
    }
    if (data.containsKey('question_type')) {
      context.handle(const VerificationMeta('questionType'), questionType.isAcceptableOrUnknown(data['question_type']!, const VerificationMeta('questionType')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('questionType'));
    }
    if (data.containsKey('text')) {
      context.handle(const VerificationMeta('text'), text.isAcceptableOrUnknown(data['text']!, const VerificationMeta('text')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('text'));
    }
    if (data.containsKey('help_text')) {
      context.handle(const VerificationMeta('helpText'), helpText.isAcceptableOrUnknown(data['help_text']!, const VerificationMeta('helpText')));
    }
    if (data.containsKey('is_required')) {
      context.handle(const VerificationMeta('isRequired'), isRequired.isAcceptableOrUnknown(data['is_required']!, const VerificationMeta('isRequired')));
    }
    if (data.containsKey('position')) {
      context.handle(const VerificationMeta('position'), position.isAcceptableOrUnknown(data['position']!, const VerificationMeta('position')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('position'));
    }
    if (data.containsKey('validation_rules')) {
      context.handle(const VerificationMeta('validationRules'), validationRules.isAcceptableOrUnknown(data['validation_rules']!, const VerificationMeta('validationRules')));
    }
    return context;
  }

  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      surveySectionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}survey_section_id'])!,
      surveyVersionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}survey_version_id'])!,
      questionType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}question_type'])!,
      text: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      helpText: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}help_text']),
      isRequired: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_required'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      validationRules: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}validation_rules'])
    );
  }

  @override
  QuestionsTable createAlias(String alias) => QuestionsTable(attachedDatabase, alias);
}

mixin _QuestionsDaoMixin on DatabaseAccessor<AppDatabase> {
  QuestionsTable get questions => attachedDatabase.questions;
}

class QuestionOption extends DataClass implements Insertable<QuestionOption> {
  final String id;
  final String questionId;
  final String value;
  final String label;
  final int position;
  final bool isDefault;
  const QuestionOption({required this.id, required this.questionId, required this.value, required this.label, required this.position, required this.isDefault});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question_id'] = Variable<String>(questionId);
    map['value'] = Variable<String>(value);
    map['label'] = Variable<String>(label);
    map['position'] = Variable<int>(position);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  QuestionOptionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionOptionsCompanion(
      id: Value(id),
      questionId: Value(questionId),
      value: Value(value),
      label: Value(label),
      position: Value(position),
      isDefault: Value(isDefault),
    );
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionOption(
      id: serializer.fromJson<String>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      value: serializer.fromJson<String>(json['value']),
      label: serializer.fromJson<String>(json['label']),
      position: serializer.fromJson<int>(json['position']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questionId': serializer.toJson<String>(questionId),
      'value': serializer.toJson<String>(value),
      'label': serializer.toJson<String>(label),
      'position': serializer.toJson<int>(position),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  QuestionOption copyWith({
    String? id,
    String? questionId,
    String? value,
    String? label,
    int? position,
    bool? isDefault,
  }) {
    return QuestionOption(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      value: value ?? this.value,
      label: label ?? this.label,
      position: position ?? this.position,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, questionId, value, label, position, isDefault]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is QuestionOption && other.id == id && other.questionId == questionId && other.value == value && other.label == label && other.position == position && other.isDefault == isDefault);
  @override
  String toString() => 'QuestionOption(id: ${id}, questionId: ${questionId}, value: ${value}, label: ${label}, position: ${position}, isDefault: ${isDefault})';
}

class QuestionOptionsCompanion extends UpdateCompanion<QuestionOption> {
  final Value<String> id;
  final Value<String> questionId;
  final Value<String> value;
  final Value<String> label;
  final Value<int> position;
  final Value<bool> isDefault;
  const QuestionOptionsCompanion({this.id = const Value.absent(), this.questionId = const Value.absent(), this.value = const Value.absent(), this.label = const Value.absent(), this.position = const Value.absent(), this.isDefault = const Value.absent()});

  QuestionOptionsCompanion.insert({
    required String id,
    required String questionId,
    required String value,
    required String label,
    this.position = const Value.absent(),
    this.isDefault = const Value.absent(),
  }) :
        id = Value(id),
        questionId = Value(questionId),
        value = Value(value),
        label = Value(label),
        position = this.position,
        isDefault = this.isDefault,
        ;

  static Insertable<QuestionOption> custom({
    Expression<String>? id,
    Expression<String>? questionId,
    Expression<String>? value,
    Expression<String>? label,
    Expression<int>? position,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (value != null) 'value': value,
      if (label != null) 'label': label,
      if (position != null) 'position': position,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  QuestionOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? questionId,
    Value<String>? value,
    Value<String>? label,
    Value<int>? position,
    Value<bool>? isDefault,
  }) {
    return QuestionOptionsCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      value: value ?? this.value,
      label: label ?? this.label,
      position: position ?? this.position,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

}

class QuestionOptionsTable extends QuestionOptions with TableInfo<QuestionOptionsTable, QuestionOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  QuestionOptionsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>('question_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES questions(id)'));
  late final GeneratedColumn<String> value = GeneratedColumn<String>('value', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> label = GeneratedColumn<String>('label', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<int> position = GeneratedColumn<int>('position', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(0));
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>('is_default', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        questionId,
        value,
        label,
        position,
        isDefault
      ];

  @override
  String get aliasedName => _alias ?? 'question_options';
  @override
  String get actualTableName => 'question_options';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<QuestionOption> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('question_id')) {
      context.handle(const VerificationMeta('questionId'), questionId.isAcceptableOrUnknown(data['question_id']!, const VerificationMeta('questionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('questionId'));
    }
    if (data.containsKey('value')) {
      context.handle(const VerificationMeta('value'), value.isAcceptableOrUnknown(data['value']!, const VerificationMeta('value')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('value'));
    }
    if (data.containsKey('label')) {
      context.handle(const VerificationMeta('label'), label.isAcceptableOrUnknown(data['label']!, const VerificationMeta('label')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('label'));
    }
    if (data.containsKey('position')) {
      context.handle(const VerificationMeta('position'), position.isAcceptableOrUnknown(data['position']!, const VerificationMeta('position')));
    }
    if (data.containsKey('is_default')) {
      context.handle(const VerificationMeta('isDefault'), isDefault.isAcceptableOrUnknown(data['is_default']!, const VerificationMeta('isDefault')));
    }
    return context;
  }

  @override
  QuestionOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionOption(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      questionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      label: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      isDefault: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!
    );
  }

  @override
  QuestionOptionsTable createAlias(String alias) => QuestionOptionsTable(attachedDatabase, alias);
}

mixin _QuestionOptionsDaoMixin on DatabaseAccessor<AppDatabase> {
  QuestionOptionsTable get questionOptions => attachedDatabase.questionOptions;
}

class Response extends DataClass implements Insertable<Response> {
  final String id;
  final String questionId;
  final String userId;
  final String surveyVersionId;
  final String answer;
  final DateTime answeredAt;
  final bool isSynced;
  final DateTime? updatedAt;
  const Response({required this.id, required this.questionId, required this.userId, required this.surveyVersionId, required this.answer, required this.answeredAt, required this.isSynced, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question_id'] = Variable<String>(questionId);
    map['user_id'] = Variable<String>(userId);
    map['survey_version_id'] = Variable<String>(surveyVersionId);
    map['answer'] = Variable<String>(answer);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ResponsesCompanion toCompanion(bool nullToAbsent) {
    return ResponsesCompanion(
      id: Value(id),
      questionId: Value(questionId),
      userId: Value(userId),
      surveyVersionId: Value(surveyVersionId),
      answer: Value(answer),
      answeredAt: Value(answeredAt),
      isSynced: Value(isSynced),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory Response.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Response(
      id: serializer.fromJson<String>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      userId: serializer.fromJson<String>(json['userId']),
      surveyVersionId: serializer.fromJson<String>(json['surveyVersionId']),
      answer: serializer.fromJson<String>(json['answer']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questionId': serializer.toJson<String>(questionId),
      'userId': serializer.toJson<String>(userId),
      'surveyVersionId': serializer.toJson<String>(surveyVersionId),
      'answer': serializer.toJson<String>(answer),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Response copyWith({
    String? id,
    String? questionId,
    String? userId,
    String? surveyVersionId,
    String? answer,
    DateTime? answeredAt,
    bool? isSynced,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return Response(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      answer: answer ?? this.answer,
      answeredAt: answeredAt ?? this.answeredAt,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, questionId, userId, surveyVersionId, answer, answeredAt, isSynced, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Response && other.id == id && other.questionId == questionId && other.userId == userId && other.surveyVersionId == surveyVersionId && other.answer == answer && other.answeredAt == answeredAt && other.isSynced == isSynced && other.updatedAt == updatedAt);
  @override
  String toString() => 'Response(id: ${id}, questionId: ${questionId}, userId: ${userId}, surveyVersionId: ${surveyVersionId}, answer: ${answer}, answeredAt: ${answeredAt}, isSynced: ${isSynced}, updatedAt: ${updatedAt})';
}

class ResponsesCompanion extends UpdateCompanion<Response> {
  final Value<String> id;
  final Value<String> questionId;
  final Value<String> userId;
  final Value<String> surveyVersionId;
  final Value<String> answer;
  final Value<DateTime> answeredAt;
  final Value<bool> isSynced;
  final Value<DateTime?> updatedAt;
  const ResponsesCompanion({this.id = const Value.absent(), this.questionId = const Value.absent(), this.userId = const Value.absent(), this.surveyVersionId = const Value.absent(), this.answer = const Value.absent(), this.answeredAt = const Value.absent(), this.isSynced = const Value.absent(), this.updatedAt = const Value.absent()});

  ResponsesCompanion.insert({
    required String id,
    required String questionId,
    required String userId,
    required String surveyVersionId,
    required String answer,
    this.answeredAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        questionId = Value(questionId),
        userId = Value(userId),
        surveyVersionId = Value(surveyVersionId),
        answer = Value(answer),
        answeredAt = this.answeredAt,
        isSynced = this.isSynced,
        updatedAt = this.updatedAt,
        ;

  static Insertable<Response> custom({
    Expression<String>? id,
    Expression<String>? questionId,
    Expression<String>? userId,
    Expression<String>? surveyVersionId,
    Expression<String>? answer,
    Expression<DateTime>? answeredAt,
    Expression<bool>? isSynced,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (userId != null) 'user_id': userId,
      if (surveyVersionId != null) 'survey_version_id': surveyVersionId,
      if (answer != null) 'answer': answer,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ResponsesCompanion copyWith({
    Value<String>? id,
    Value<String>? questionId,
    Value<String>? userId,
    Value<String>? surveyVersionId,
    Value<String>? answer,
    Value<DateTime>? answeredAt,
    Value<bool>? isSynced,
    Value<DateTime?>? updatedAt,
  }) {
    return ResponsesCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      answer: answer ?? this.answer,
      answeredAt: answeredAt ?? this.answeredAt,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (surveyVersionId.present) {
      map['survey_version_id'] = Variable<String>(surveyVersionId.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class ResponsesTable extends Responses with TableInfo<ResponsesTable, Response> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ResponsesTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>('question_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES questions(id)'));
  late final GeneratedColumn<String> userId = GeneratedColumn<String>('user_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> surveyVersionId = GeneratedColumn<String>('survey_version_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES survey_versions(id)'));
  late final GeneratedColumn<String> answer = GeneratedColumn<String>('answer', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>('answered_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>('is_synced', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(false));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        questionId,
        userId,
        surveyVersionId,
        answer,
        answeredAt,
        isSynced,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'responses';
  @override
  String get actualTableName => 'responses';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [{questionId, userId}];

  @override
  VerificationContext validateIntegrity(Insertable<Response> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('question_id')) {
      context.handle(const VerificationMeta('questionId'), questionId.isAcceptableOrUnknown(data['question_id']!, const VerificationMeta('questionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('questionId'));
    }
    if (data.containsKey('user_id')) {
      context.handle(const VerificationMeta('userId'), userId.isAcceptableOrUnknown(data['user_id']!, const VerificationMeta('userId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('userId'));
    }
    if (data.containsKey('survey_version_id')) {
      context.handle(const VerificationMeta('surveyVersionId'), surveyVersionId.isAcceptableOrUnknown(data['survey_version_id']!, const VerificationMeta('surveyVersionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('surveyVersionId'));
    }
    if (data.containsKey('answer')) {
      context.handle(const VerificationMeta('answer'), answer.isAcceptableOrUnknown(data['answer']!, const VerificationMeta('answer')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('answer'));
    }
    if (data.containsKey('answered_at')) {
      context.handle(const VerificationMeta('answeredAt'), answeredAt.isAcceptableOrUnknown(data['answered_at']!, const VerificationMeta('answeredAt')));
    }
    if (data.containsKey('is_synced')) {
      context.handle(const VerificationMeta('isSynced'), isSynced.isAcceptableOrUnknown(data['is_synced']!, const VerificationMeta('isSynced')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  Response map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Response(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      questionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      surveyVersionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}survey_version_id'])!,
      answer: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      answeredAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
      isSynced: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  ResponsesTable createAlias(String alias) => ResponsesTable(attachedDatabase, alias);
}

mixin _ResponsesDaoMixin on DatabaseAccessor<AppDatabase> {
  ResponsesTable get responses => attachedDatabase.responses;
}

class Report extends DataClass implements Insertable<Report> {
  final String id;
  final String userId;
  final String surveyVersionId;
  final String status;
  final String? url;
  final DateTime generatedAt;
  final DateTime? updatedAt;
  const Report({required this.id, required this.userId, required this.surveyVersionId, required this.status, this.url, required this.generatedAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['survey_version_id'] = Variable<String>(surveyVersionId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      userId: Value(userId),
      surveyVersionId: Value(surveyVersionId),
      status: Value(status),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      generatedAt: Value(generatedAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory Report.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Report(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      surveyVersionId: serializer.fromJson<String>(json['surveyVersionId']),
      status: serializer.fromJson<String>(json['status']),
      url: serializer.fromJson<String?>(json['url']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'surveyVersionId': serializer.toJson<String>(surveyVersionId),
      'status': serializer.toJson<String>(status),
      'url': serializer.toJson<String?>(url),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Report copyWith({
    String? id,
    String? userId,
    String? surveyVersionId,
    String? status,
    Value<String?>? url = const Value.absent(),
    DateTime? generatedAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      status: status ?? this.status,
      url: url != null && url!.present ? url!.value : this.url,
      generatedAt: generatedAt ?? this.generatedAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, userId, surveyVersionId, status, url, generatedAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Report && other.id == id && other.userId == userId && other.surveyVersionId == surveyVersionId && other.status == status && other.url == url && other.generatedAt == generatedAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'Report(id: ${id}, userId: ${userId}, surveyVersionId: ${surveyVersionId}, status: ${status}, url: ${url}, generatedAt: ${generatedAt}, updatedAt: ${updatedAt})';
}

class ReportsCompanion extends UpdateCompanion<Report> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> surveyVersionId;
  final Value<String> status;
  final Value<String?> url;
  final Value<DateTime> generatedAt;
  final Value<DateTime?> updatedAt;
  const ReportsCompanion({this.id = const Value.absent(), this.userId = const Value.absent(), this.surveyVersionId = const Value.absent(), this.status = const Value.absent(), this.url = const Value.absent(), this.generatedAt = const Value.absent(), this.updatedAt = const Value.absent()});

  ReportsCompanion.insert({
    required String id,
    required String userId,
    required String surveyVersionId,
    required String status,
    this.url = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        userId = Value(userId),
        surveyVersionId = Value(surveyVersionId),
        status = Value(status),
        url = this.url,
        generatedAt = this.generatedAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<Report> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? surveyVersionId,
    Expression<String>? status,
    Expression<String?>? url,
    Expression<DateTime>? generatedAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (surveyVersionId != null) 'survey_version_id': surveyVersionId,
      if (status != null) 'status': status,
      if (url != null) 'url': url,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? surveyVersionId,
    Value<String>? status,
    Value<String?>? url,
    Value<DateTime>? generatedAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      surveyVersionId: surveyVersionId ?? this.surveyVersionId,
      status: status ?? this.status,
      url: url ?? this.url,
      generatedAt: generatedAt ?? this.generatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (surveyVersionId.present) {
      map['survey_version_id'] = Variable<String>(surveyVersionId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class ReportsTable extends Reports with TableInfo<ReportsTable, Report> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ReportsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> userId = GeneratedColumn<String>('user_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> surveyVersionId = GeneratedColumn<String>('survey_version_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES survey_versions(id)'));
  late final GeneratedColumn<String> status = GeneratedColumn<String>('status', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> url = GeneratedColumn<String>('url', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>('generated_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        surveyVersionId,
        status,
        url,
        generatedAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'reports';
  @override
  String get actualTableName => 'reports';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<Report> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('user_id')) {
      context.handle(const VerificationMeta('userId'), userId.isAcceptableOrUnknown(data['user_id']!, const VerificationMeta('userId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('userId'));
    }
    if (data.containsKey('survey_version_id')) {
      context.handle(const VerificationMeta('surveyVersionId'), surveyVersionId.isAcceptableOrUnknown(data['survey_version_id']!, const VerificationMeta('surveyVersionId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('surveyVersionId'));
    }
    if (data.containsKey('status')) {
      context.handle(const VerificationMeta('status'), status.isAcceptableOrUnknown(data['status']!, const VerificationMeta('status')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('status'));
    }
    if (data.containsKey('url')) {
      context.handle(const VerificationMeta('url'), url.isAcceptableOrUnknown(data['url']!, const VerificationMeta('url')));
    }
    if (data.containsKey('generated_at')) {
      context.handle(const VerificationMeta('generatedAt'), generatedAt.isAcceptableOrUnknown(data['generated_at']!, const VerificationMeta('generatedAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  Report map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Report(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      surveyVersionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}survey_version_id'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url']),
      generatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  ReportsTable createAlias(String alias) => ReportsTable(attachedDatabase, alias);
}

mixin _ReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  ReportsTable get reports => attachedDatabase.reports;
}

class Chat extends DataClass implements Insertable<Chat> {
  final String id;
  final String userId;
  final String? title;
  final String? status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Chat({required this.id, required this.userId, this.title, this.status, required this.createdAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      status: status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String?>(json['title']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String?>(title),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Chat copyWith({
    String? id,
    String? userId,
    Value<String?>? title = const Value.absent(),
    Value<String?>? status = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title != null && title!.present ? title!.value : this.title,
      status: status != null && status!.present ? status!.value : this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, userId, title, status, createdAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Chat && other.id == id && other.userId == userId && other.title == title && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'Chat(id: ${id}, userId: ${userId}, title: ${title}, status: ${status}, createdAt: ${createdAt}, updatedAt: ${updatedAt})';
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> title;
  final Value<String?> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ChatsCompanion({this.id = const Value.absent(), this.userId = const Value.absent(), this.title = const Value.absent(), this.status = const Value.absent(), this.createdAt = const Value.absent(), this.updatedAt = const Value.absent()});

  ChatsCompanion.insert({
    required String id,
    required String userId,
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        userId = Value(userId),
        title = this.title,
        status = this.status,
        createdAt = this.createdAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<Chat> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String?>? title,
    Expression<String?>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? title,
    Value<String?>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ChatsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class ChatsTable extends Chats with TableInfo<ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ChatsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> userId = GeneratedColumn<String>('user_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<String> status = GeneratedColumn<String>('status', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        status,
        createdAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'chats';
  @override
  String get actualTableName => 'chats';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('user_id')) {
      context.handle(const VerificationMeta('userId'), userId.isAcceptableOrUnknown(data['user_id']!, const VerificationMeta('userId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('userId'));
    }
    if (data.containsKey('title')) {
      context.handle(const VerificationMeta('title'), title.isAcceptableOrUnknown(data['title']!, const VerificationMeta('title')));
    }
    if (data.containsKey('status')) {
      context.handle(const VerificationMeta('status'), status.isAcceptableOrUnknown(data['status']!, const VerificationMeta('status')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title']),
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  ChatsTable createAlias(String alias) => ChatsTable(attachedDatabase, alias);
}

mixin _ChatsDaoMixin on DatabaseAccessor<AppDatabase> {
  ChatsTable get chats => attachedDatabase.chats;
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String chatId;
  final String senderId;
  final String body;
  final String messageType;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? updatedAt;
  const Message({required this.id, required this.chatId, required this.senderId, required this.body, required this.messageType, required this.isRead, required this.sentAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['sender_id'] = Variable<String>(senderId);
    map['body'] = Variable<String>(body);
    map['message_type'] = Variable<String>(messageType);
    map['is_read'] = Variable<bool>(isRead);
    map['sent_at'] = Variable<DateTime>(sentAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      senderId: Value(senderId),
      body: Value(body),
      messageType: Value(messageType),
      isRead: Value(isRead),
      sentAt: Value(sentAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      body: serializer.fromJson<String>(json['body']),
      messageType: serializer.fromJson<String>(json['messageType']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'senderId': serializer.toJson<String>(senderId),
      'body': serializer.toJson<String>(body),
      'messageType': serializer.toJson<String>(messageType),
      'isRead': serializer.toJson<bool>(isRead),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? body,
    String? messageType,
    bool? isRead,
    DateTime? sentAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, chatId, senderId, body, messageType, isRead, sentAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Message && other.id == id && other.chatId == chatId && other.senderId == senderId && other.body == body && other.messageType == messageType && other.isRead == isRead && other.sentAt == sentAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'Message(id: ${id}, chatId: ${chatId}, senderId: ${senderId}, body: ${body}, messageType: ${messageType}, isRead: ${isRead}, sentAt: ${sentAt}, updatedAt: ${updatedAt})';
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String> senderId;
  final Value<String> body;
  final Value<String> messageType;
  final Value<bool> isRead;
  final Value<DateTime> sentAt;
  final Value<DateTime?> updatedAt;
  const MessagesCompanion({this.id = const Value.absent(), this.chatId = const Value.absent(), this.senderId = const Value.absent(), this.body = const Value.absent(), this.messageType = const Value.absent(), this.isRead = const Value.absent(), this.sentAt = const Value.absent(), this.updatedAt = const Value.absent()});

  MessagesCompanion.insert({
    required String id,
    required String chatId,
    required String senderId,
    required String body,
    this.messageType = const Value.absent(),
    this.isRead = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        chatId = Value(chatId),
        senderId = Value(senderId),
        body = Value(body),
        messageType = this.messageType,
        isRead = this.isRead,
        sentAt = this.sentAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? senderId,
    Expression<String>? body,
    Expression<String>? messageType,
    Expression<bool>? isRead,
    Expression<DateTime>? sentAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (senderId != null) 'sender_id': senderId,
      if (body != null) 'body': body,
      if (messageType != null) 'message_type': messageType,
      if (isRead != null) 'is_read': isRead,
      if (sentAt != null) 'sent_at': sentAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? chatId,
    Value<String>? senderId,
    Value<String>? body,
    Value<String>? messageType,
    Value<bool>? isRead,
    Value<DateTime>? sentAt,
    Value<DateTime?>? updatedAt,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class MessagesTable extends Messages with TableInfo<MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessagesTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>('chat_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES chats(id)'));
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>('sender_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> body = GeneratedColumn<String>('body', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>('message_type', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: false, defaultValue: const Constant('text'));
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>('is_read', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: const Constant(false));
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>('sent_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chatId,
        senderId,
        body,
        messageType,
        isRead,
        sentAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'messages';
  @override
  String get actualTableName => 'messages';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<Message> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('chat_id')) {
      context.handle(const VerificationMeta('chatId'), chatId.isAcceptableOrUnknown(data['chat_id']!, const VerificationMeta('chatId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('chatId'));
    }
    if (data.containsKey('sender_id')) {
      context.handle(const VerificationMeta('senderId'), senderId.isAcceptableOrUnknown(data['sender_id']!, const VerificationMeta('senderId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('senderId'));
    }
    if (data.containsKey('body')) {
      context.handle(const VerificationMeta('body'), body.isAcceptableOrUnknown(data['body']!, const VerificationMeta('body')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('body'));
    }
    if (data.containsKey('message_type')) {
      context.handle(const VerificationMeta('messageType'), messageType.isAcceptableOrUnknown(data['message_type']!, const VerificationMeta('messageType')));
    }
    if (data.containsKey('is_read')) {
      context.handle(const VerificationMeta('isRead'), isRead.isAcceptableOrUnknown(data['is_read']!, const VerificationMeta('isRead')));
    }
    if (data.containsKey('sent_at')) {
      context.handle(const VerificationMeta('sentAt'), sentAt.isAcceptableOrUnknown(data['sent_at']!, const VerificationMeta('sentAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      senderId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      body: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      messageType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}message_type'])!,
      isRead: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      sentAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  MessagesTable createAlias(String alias) => MessagesTable(attachedDatabase, alias);
}

mixin _MessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  MessagesTable get messages => attachedDatabase.messages;
}

class FileEntity extends DataClass implements Insertable<FileEntity> {
  final String id;
  final String? messageId;
  final String? ownerId;
  final String url;
  final String? mimeType;
  final int? size;
  final DateTime createdAt;
  const FileEntity({required this.id, this.messageId, this.ownerId, required this.url, this.mimeType, this.size, required this.createdAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<String>(messageId);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      id: Value(id),
      messageId: messageId == null && nullToAbsent ? const Value.absent() : Value(messageId),
      ownerId: ownerId == null && nullToAbsent ? const Value.absent() : Value(ownerId),
      url: Value(url),
      mimeType: mimeType == null && nullToAbsent ? const Value.absent() : Value(mimeType),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      createdAt: Value(createdAt),
    );
  }

  factory FileEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileEntity(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String?>(json['messageId']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      url: serializer.fromJson<String>(json['url']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      size: serializer.fromJson<int?>(json['size']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String?>(messageId),
      'ownerId': serializer.toJson<String?>(ownerId),
      'url': serializer.toJson<String>(url),
      'mimeType': serializer.toJson<String?>(mimeType),
      'size': serializer.toJson<int?>(size),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FileEntity copyWith({
    String? id,
    Value<String?>? messageId = const Value.absent(),
    Value<String?>? ownerId = const Value.absent(),
    String? url,
    Value<String?>? mimeType = const Value.absent(),
    Value<int?>? size = const Value.absent(),
    DateTime? createdAt,
  }) {
    return FileEntity(
      id: id ?? this.id,
      messageId: messageId != null && messageId!.present ? messageId!.value : this.messageId,
      ownerId: ownerId != null && ownerId!.present ? ownerId!.value : this.ownerId,
      url: url ?? this.url,
      mimeType: mimeType != null && mimeType!.present ? mimeType!.value : this.mimeType,
      size: size != null && size!.present ? size!.value : this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, messageId, ownerId, url, mimeType, size, createdAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is FileEntity && other.id == id && other.messageId == messageId && other.ownerId == ownerId && other.url == url && other.mimeType == mimeType && other.size == size && other.createdAt == createdAt);
  @override
  String toString() => 'FileEntity(id: ${id}, messageId: ${messageId}, ownerId: ${ownerId}, url: ${url}, mimeType: ${mimeType}, size: ${size}, createdAt: ${createdAt})';
}

class FilesCompanion extends UpdateCompanion<FileEntity> {
  final Value<String> id;
  final Value<String?> messageId;
  final Value<String?> ownerId;
  final Value<String> url;
  final Value<String?> mimeType;
  final Value<int?> size;
  final Value<DateTime> createdAt;
  const FilesCompanion({this.id = const Value.absent(), this.messageId = const Value.absent(), this.ownerId = const Value.absent(), this.url = const Value.absent(), this.mimeType = const Value.absent(), this.size = const Value.absent(), this.createdAt = const Value.absent()});

  FilesCompanion.insert({
    required String id,
    this.messageId = const Value.absent(),
    this.ownerId = const Value.absent(),
    required String url,
    this.mimeType = const Value.absent(),
    this.size = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) :
        id = Value(id),
        messageId = this.messageId,
        ownerId = this.ownerId,
        url = Value(url),
        mimeType = this.mimeType,
        size = this.size,
        createdAt = this.createdAt,
        ;

  static Insertable<FileEntity> custom({
    Expression<String>? id,
    Expression<String?>? messageId,
    Expression<String?>? ownerId,
    Expression<String>? url,
    Expression<String?>? mimeType,
    Expression<int?>? size,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (ownerId != null) 'owner_id': ownerId,
      if (url != null) 'url': url,
      if (mimeType != null) 'mime_type': mimeType,
      if (size != null) 'size': size,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? messageId,
    Value<String?>? ownerId,
    Value<String>? url,
    Value<String?>? mimeType,
    Value<int?>? size,
    Value<DateTime>? createdAt,
  }) {
    return FilesCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      ownerId: ownerId ?? this.ownerId,
      url: url ?? this.url,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

}

class FilesTable extends Files with TableInfo<FilesTable, FileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FilesTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>('message_id', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES messages(id)'));
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>('owner_id', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> url = GeneratedColumn<String>('url', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>('mime_type', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<int> size = GeneratedColumn<int>('size', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageId,
        ownerId,
        url,
        mimeType,
        size,
        createdAt
      ];

  @override
  String get aliasedName => _alias ?? 'files';
  @override
  String get actualTableName => 'files';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<FileEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('message_id')) {
      context.handle(const VerificationMeta('messageId'), messageId.isAcceptableOrUnknown(data['message_id']!, const VerificationMeta('messageId')));
    }
    if (data.containsKey('owner_id')) {
      context.handle(const VerificationMeta('ownerId'), ownerId.isAcceptableOrUnknown(data['owner_id']!, const VerificationMeta('ownerId')));
    }
    if (data.containsKey('url')) {
      context.handle(const VerificationMeta('url'), url.isAcceptableOrUnknown(data['url']!, const VerificationMeta('url')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('url'));
    }
    if (data.containsKey('mime_type')) {
      context.handle(const VerificationMeta('mimeType'), mimeType.isAcceptableOrUnknown(data['mime_type']!, const VerificationMeta('mimeType')));
    }
    if (data.containsKey('size')) {
      context.handle(const VerificationMeta('size'), size.isAcceptableOrUnknown(data['size']!, const VerificationMeta('size')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    return context;
  }

  @override
  FileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}message_id']),
      ownerId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}owner_id']),
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      mimeType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      size: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}size']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!
    );
  }

  @override
  FilesTable createAlias(String alias) => FilesTable(attachedDatabase, alias);
}

mixin _FilesDaoMixin on DatabaseAccessor<AppDatabase> {
  FilesTable get files => attachedDatabase.files;
}

class PushToken extends DataClass implements Insertable<PushToken> {
  final String id;
  final String userId;
  final String token;
  final String? deviceType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PushToken({required this.id, required this.userId, required this.token, this.deviceType, required this.createdAt, this.updatedAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['token'] = Variable<String>(token);
    if (!nullToAbsent || deviceType != null) {
      map['device_type'] = Variable<String>(deviceType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PushTokensCompanion toCompanion(bool nullToAbsent) {
    return PushTokensCompanion(
      id: Value(id),
      userId: Value(userId),
      token: Value(token),
      deviceType: deviceType == null && nullToAbsent ? const Value.absent() : Value(deviceType),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
    );
  }

  factory PushToken.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PushToken(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      token: serializer.fromJson<String>(json['token']),
      deviceType: serializer.fromJson<String?>(json['deviceType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'token': serializer.toJson<String>(token),
      'deviceType': serializer.toJson<String?>(deviceType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PushToken copyWith({
    String? id,
    String? userId,
    String? token,
    Value<String?>? deviceType = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?>? updatedAt = const Value.absent(),
  }) {
    return PushToken(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      deviceType: deviceType != null && deviceType!.present ? deviceType!.value : this.deviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null && updatedAt!.present ? updatedAt!.value : this.updatedAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, userId, token, deviceType, createdAt, updatedAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is PushToken && other.id == id && other.userId == userId && other.token == token && other.deviceType == deviceType && other.createdAt == createdAt && other.updatedAt == updatedAt);
  @override
  String toString() => 'PushToken(id: ${id}, userId: ${userId}, token: ${token}, deviceType: ${deviceType}, createdAt: ${createdAt}, updatedAt: ${updatedAt})';
}

class PushTokensCompanion extends UpdateCompanion<PushToken> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> token;
  final Value<String?> deviceType;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PushTokensCompanion({this.id = const Value.absent(), this.userId = const Value.absent(), this.token = const Value.absent(), this.deviceType = const Value.absent(), this.createdAt = const Value.absent(), this.updatedAt = const Value.absent()});

  PushTokensCompanion.insert({
    required String id,
    required String userId,
    required String token,
    this.deviceType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) :
        id = Value(id),
        userId = Value(userId),
        token = Value(token),
        deviceType = this.deviceType,
        createdAt = this.createdAt,
        updatedAt = this.updatedAt,
        ;

  static Insertable<PushToken> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? token,
    Expression<String?>? deviceType,
    Expression<DateTime>? createdAt,
    Expression<DateTime?>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (token != null) 'token': token,
      if (deviceType != null) 'device_type': deviceType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PushTokensCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? token,
    Value<String?>? deviceType,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PushTokensCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      deviceType: deviceType ?? this.deviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (deviceType.present) {
      map['device_type'] = Variable<String>(deviceType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

}

class PushTokensTable extends PushTokens with TableInfo<PushTokensTable, PushToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PushTokensTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> userId = GeneratedColumn<String>('user_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> token = GeneratedColumn<String>('token', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> deviceType = GeneratedColumn<String>('device_type', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        token,
        deviceType,
        createdAt,
        updatedAt
      ];

  @override
  String get aliasedName => _alias ?? 'push_tokens';
  @override
  String get actualTableName => 'push_tokens';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<PushToken> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('user_id')) {
      context.handle(const VerificationMeta('userId'), userId.isAcceptableOrUnknown(data['user_id']!, const VerificationMeta('userId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('userId'));
    }
    if (data.containsKey('token')) {
      context.handle(const VerificationMeta('token'), token.isAcceptableOrUnknown(data['token']!, const VerificationMeta('token')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('token'));
    }
    if (data.containsKey('device_type')) {
      context.handle(const VerificationMeta('deviceType'), deviceType.isAcceptableOrUnknown(data['device_type']!, const VerificationMeta('deviceType')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    if (data.containsKey('updated_at')) {
      context.handle(const VerificationMeta('updatedAt'), updatedAt.isAcceptableOrUnknown(data['updated_at']!, const VerificationMeta('updatedAt')));
    }
    return context;
  }

  @override
  PushToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PushToken(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      token: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}token'])!,
      deviceType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}device_type']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])
    );
  }

  @override
  PushTokensTable createAlias(String alias) => PushTokensTable(attachedDatabase, alias);
}

mixin _PushTokensDaoMixin on DatabaseAccessor<AppDatabase> {
  PushTokensTable get pushTokens => attachedDatabase.pushTokens;
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String? actorId;
  final String? payload;
  final DateTime createdAt;
  const AuditLogData({required this.id, required this.entityType, required this.entityId, required this.action, this.actorId, this.payload, required this.createdAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || actorId != null) {
      map['actor_id'] = Variable<String>(actorId);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      actorId: actorId == null && nullToAbsent ? const Value.absent() : Value(actorId),
      payload: payload == null && nullToAbsent ? const Value.absent() : Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      actorId: serializer.fromJson<String?>(json['actorId']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'actorId': serializer.toJson<String?>(actorId),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLogData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? action,
    Value<String?>? actorId = const Value.absent(),
    Value<String?>? payload = const Value.absent(),
    DateTime? createdAt,
  }) {
    return AuditLogData(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      actorId: actorId != null && actorId!.present ? actorId!.value : this.actorId,
      payload: payload != null && payload!.present ? payload!.value : this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  int get hashCode => Object.hashAll([id, entityType, entityId, action, actorId, payload, createdAt]);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is AuditLogData && other.id == id && other.entityType == entityType && other.entityId == entityId && other.action == action && other.actorId == actorId && other.payload == payload && other.createdAt == createdAt);
  @override
  String toString() => 'AuditLogData(id: ${id}, entityType: ${entityType}, entityId: ${entityId}, action: ${action}, actorId: ${actorId}, payload: ${payload}, createdAt: ${createdAt})';
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> actorId;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  const AuditLogCompanion({this.id = const Value.absent(), this.entityType = const Value.absent(), this.entityId = const Value.absent(), this.action = const Value.absent(), this.actorId = const Value.absent(), this.payload = const Value.absent(), this.createdAt = const Value.absent()});

  AuditLogCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String action,
    this.actorId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) :
        id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        actorId = this.actorId,
        payload = this.payload,
        createdAt = this.createdAt,
        ;

  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String?>? actorId,
    Expression<String?>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (actorId != null) 'actor_id': actorId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<String?>? actorId,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      actorId: actorId ?? this.actorId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

}

class AuditLogTable extends AuditLog with TableInfo<AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AuditLogTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>('entity_type', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>('entity_id', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> action = GeneratedColumn<String>('action', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: true);
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>('actor_id', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES users(id)'));
  late final GeneratedColumn<String> payload = GeneratedColumn<String>('payload', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        action,
        actorId,
        payload,
        createdAt
      ];

  @override
  String get aliasedName => _alias ?? 'audit_log';
  @override
  String get actualTableName => 'audit_log';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  VerificationContext validateIntegrity(Insertable<AuditLogData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('id'));
    }
    if (data.containsKey('entity_type')) {
      context.handle(const VerificationMeta('entityType'), entityType.isAcceptableOrUnknown(data['entity_type']!, const VerificationMeta('entityType')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('entityType'));
    }
    if (data.containsKey('entity_id')) {
      context.handle(const VerificationMeta('entityId'), entityId.isAcceptableOrUnknown(data['entity_id']!, const VerificationMeta('entityId')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('entityId'));
    }
    if (data.containsKey('action')) {
      context.handle(const VerificationMeta('action'), action.isAcceptableOrUnknown(data['action']!, const VerificationMeta('action')));
    } else if (isInserting) {
      context.missing(const VerificationMeta('action'));
    }
    if (data.containsKey('actor_id')) {
      context.handle(const VerificationMeta('actorId'), actorId.isAcceptableOrUnknown(data['actor_id']!, const VerificationMeta('actorId')));
    }
    if (data.containsKey('payload')) {
      context.handle(const VerificationMeta('payload'), payload.isAcceptableOrUnknown(data['payload']!, const VerificationMeta('payload')));
    }
    if (data.containsKey('created_at')) {
      context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    }
    return context;
  }

  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      actorId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}actor_id']),
      payload: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}payload']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!
    );
  }

  @override
  AuditLogTable createAlias(String alias) => AuditLogTable(attachedDatabase, alias);
}

mixin _AuditLogDaoMixin on DatabaseAccessor<AppDatabase> {
  AuditLogTable get auditLog => attachedDatabase.auditLog;
}
