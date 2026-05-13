// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
      'photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, phone, gender, address, photo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      photo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String? gender;
  final String? address;
  final String? photo;
  const Customer(
      {required this.id,
      required this.name,
      this.email,
      required this.phone,
      this.gender,
      this.address,
      this.photo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone: Value(phone),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      gender: serializer.fromJson<String?>(json['gender']),
      address: serializer.fromJson<String?>(json['address']),
      photo: serializer.fromJson<String?>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String>(phone),
      'gender': serializer.toJson<String?>(gender),
      'address': serializer.toJson<String?>(address),
      'photo': serializer.toJson<String?>(photo),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> email = const Value.absent(),
          String? phone,
          Value<String?> gender = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> photo = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email.present ? email.value : this.email,
        phone: phone ?? this.phone,
        gender: gender.present ? gender.value : this.gender,
        address: address.present ? address.value : this.address,
        photo: photo.present ? photo.value : this.photo,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      gender: data.gender.present ? data.gender.value : this.gender,
      address: data.address.present ? data.address.value : this.address,
      photo: data.photo.present ? data.photo.value : this.photo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, phone, gender, address, photo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.gender == this.gender &&
          other.address == this.address &&
          other.photo == this.photo);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<String> phone;
  final Value<String?> gender;
  final Value<String?> address;
  final Value<String?> photo;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.gender = const Value.absent(),
    this.address = const Value.absent(),
    this.photo = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.email = const Value.absent(),
    required String phone,
    this.gender = const Value.absent(),
    this.address = const Value.absent(),
    this.photo = const Value.absent(),
  })  : name = Value(name),
        phone = Value(phone);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? gender,
    Expression<String>? address,
    Expression<String>? photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (photo != null) 'photo': photo,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? email,
      Value<String>? phone,
      Value<String?>? gender,
      Value<String?>? address,
      Value<String?>? photo}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      photo: photo ?? this.photo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String name;
  const Unit({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Unit copyWith({int? id, String? name}) => Unit(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit && other.id == this.id && other.name == this.name);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> name;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  UnitsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PerfumesTable extends Perfumes with TableInfo<$PerfumesTable, Perfume> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerfumesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perfumes';
  @override
  VerificationContext validateIntegrity(Insertable<Perfume> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Perfume map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Perfume(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $PerfumesTable createAlias(String alias) {
    return $PerfumesTable(attachedDatabase, alias);
  }
}

class Perfume extends DataClass implements Insertable<Perfume> {
  final int id;
  final String name;
  const Perfume({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PerfumesCompanion toCompanion(bool nullToAbsent) {
    return PerfumesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Perfume.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Perfume(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Perfume copyWith({int? id, String? name}) => Perfume(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Perfume copyWithCompanion(PerfumesCompanion data) {
    return Perfume(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Perfume(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Perfume && other.id == this.id && other.name == this.name);
}

class PerfumesCompanion extends UpdateCompanion<Perfume> {
  final Value<int> id;
  final Value<String> name;
  const PerfumesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PerfumesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Perfume> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PerfumesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PerfumesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerfumesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ServiceProcessesTable extends ServiceProcesses
    with TableInfo<$ServiceProcessesTable, ServiceProcessesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceProcessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_processes';
  @override
  VerificationContext validateIntegrity(
      Insertable<ServiceProcessesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceProcessesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceProcessesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ServiceProcessesTable createAlias(String alias) {
    return $ServiceProcessesTable(attachedDatabase, alias);
  }
}

class ServiceProcessesData extends DataClass
    implements Insertable<ServiceProcessesData> {
  final int id;
  final String name;
  const ServiceProcessesData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ServiceProcessesCompanion toCompanion(bool nullToAbsent) {
    return ServiceProcessesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ServiceProcessesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceProcessesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ServiceProcessesData copyWith({int? id, String? name}) =>
      ServiceProcessesData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  ServiceProcessesData copyWithCompanion(ServiceProcessesCompanion data) {
    return ServiceProcessesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceProcessesData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceProcessesData &&
          other.id == this.id &&
          other.name == this.name);
}

class ServiceProcessesCompanion extends UpdateCompanion<ServiceProcessesData> {
  final Value<int> id;
  final Value<String> name;
  const ServiceProcessesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ServiceProcessesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ServiceProcessesData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ServiceProcessesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ServiceProcessesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceProcessesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cuciMeta = const VerificationMeta('cuci');
  @override
  late final GeneratedColumn<bool> cuci = GeneratedColumn<bool>(
      'cuci', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cuci" IN (0, 1))'));
  static const VerificationMeta _keringMeta = const VerificationMeta('kering');
  @override
  late final GeneratedColumn<bool> kering = GeneratedColumn<bool>(
      'kering', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("kering" IN (0, 1))'));
  static const VerificationMeta _setrikaMeta =
      const VerificationMeta('setrika');
  @override
  late final GeneratedColumn<bool> setrika = GeneratedColumn<bool>(
      'setrika', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("setrika" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, name, cuci, kering, setrika];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(Insertable<Service> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cuci')) {
      context.handle(
          _cuciMeta, cuci.isAcceptableOrUnknown(data['cuci']!, _cuciMeta));
    } else if (isInserting) {
      context.missing(_cuciMeta);
    }
    if (data.containsKey('kering')) {
      context.handle(_keringMeta,
          kering.isAcceptableOrUnknown(data['kering']!, _keringMeta));
    } else if (isInserting) {
      context.missing(_keringMeta);
    }
    if (data.containsKey('setrika')) {
      context.handle(_setrikaMeta,
          setrika.isAcceptableOrUnknown(data['setrika']!, _setrikaMeta));
    } else if (isInserting) {
      context.missing(_setrikaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cuci: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cuci'])!,
      kering: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}kering'])!,
      setrika: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}setrika'])!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String name;
  final bool cuci;
  final bool kering;
  final bool setrika;
  const Service(
      {required this.id,
      required this.name,
      required this.cuci,
      required this.kering,
      required this.setrika});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['cuci'] = Variable<bool>(cuci);
    map['kering'] = Variable<bool>(kering);
    map['setrika'] = Variable<bool>(setrika);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      cuci: Value(cuci),
      kering: Value(kering),
      setrika: Value(setrika),
    );
  }

  factory Service.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      cuci: serializer.fromJson<bool>(json['cuci']),
      kering: serializer.fromJson<bool>(json['kering']),
      setrika: serializer.fromJson<bool>(json['setrika']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'cuci': serializer.toJson<bool>(cuci),
      'kering': serializer.toJson<bool>(kering),
      'setrika': serializer.toJson<bool>(setrika),
    };
  }

  Service copyWith(
          {int? id, String? name, bool? cuci, bool? kering, bool? setrika}) =>
      Service(
        id: id ?? this.id,
        name: name ?? this.name,
        cuci: cuci ?? this.cuci,
        kering: kering ?? this.kering,
        setrika: setrika ?? this.setrika,
      );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      cuci: data.cuci.present ? data.cuci.value : this.cuci,
      kering: data.kering.present ? data.kering.value : this.kering,
      setrika: data.setrika.present ? data.setrika.value : this.setrika,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cuci: $cuci, ')
          ..write('kering: $kering, ')
          ..write('setrika: $setrika')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, cuci, kering, setrika);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.name == this.name &&
          other.cuci == this.cuci &&
          other.kering == this.kering &&
          other.setrika == this.setrika);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> cuci;
  final Value<bool> kering;
  final Value<bool> setrika;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cuci = const Value.absent(),
    this.kering = const Value.absent(),
    this.setrika = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  })  : name = Value(name),
        cuci = Value(cuci),
        kering = Value(kering),
        setrika = Value(setrika);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? cuci,
    Expression<bool>? kering,
    Expression<bool>? setrika,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (cuci != null) 'cuci': cuci,
      if (kering != null) 'kering': kering,
      if (setrika != null) 'setrika': setrika,
    });
  }

  ServicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? cuci,
      Value<bool>? kering,
      Value<bool>? setrika}) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      cuci: cuci ?? this.cuci,
      kering: kering ?? this.kering,
      setrika: setrika ?? this.setrika,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cuci.present) {
      map['cuci'] = Variable<bool>(cuci.value);
    }
    if (kering.present) {
      map['kering'] = Variable<bool>(kering.value);
    }
    if (setrika.present) {
      map['setrika'] = Variable<bool>(setrika.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cuci: $cuci, ')
          ..write('kering: $kering, ')
          ..write('setrika: $setrika')
          ..write(')'))
        .toString();
  }
}

class $ServiceTypesTable extends ServiceTypes
    with TableInfo<$ServiceTypesTable, ServiceType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serviceIdMeta =
      const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
      'service_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _estimateDayMeta =
      const VerificationMeta('estimateDay');
  @override
  late final GeneratedColumn<int> estimateDay = GeneratedColumn<int>(
      'estimate_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isHourMeta = const VerificationMeta('isHour');
  @override
  late final GeneratedColumn<bool> isHour = GeneratedColumn<bool>(
      'is_hour', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hour" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serviceId,
        name,
        image,
        unitId,
        price,
        estimateDay,
        isHour,
        keterangan
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_types';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta,
          serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('estimate_day')) {
      context.handle(
          _estimateDayMeta,
          estimateDay.isAcceptableOrUnknown(
              data['estimate_day']!, _estimateDayMeta));
    } else if (isInserting) {
      context.missing(_estimateDayMeta);
    }
    if (data.containsKey('is_hour')) {
      context.handle(_isHourMeta,
          isHour.isAcceptableOrUnknown(data['is_hour']!, _isHourMeta));
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}service_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      estimateDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimate_day'])!,
      isHour: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hour'])!,
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
    );
  }

  @override
  $ServiceTypesTable createAlias(String alias) {
    return $ServiceTypesTable(attachedDatabase, alias);
  }
}

class ServiceType extends DataClass implements Insertable<ServiceType> {
  final int id;
  final int serviceId;
  final String name;
  final String? image;
  final int unitId;
  final double price;
  final int estimateDay;

  /// true = Jam, false = Hari
  final bool isHour;
  final String? keterangan;
  const ServiceType(
      {required this.id,
      required this.serviceId,
      required this.name,
      this.image,
      required this.unitId,
      required this.price,
      required this.estimateDay,
      required this.isHour,
      this.keterangan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['service_id'] = Variable<int>(serviceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['unit_id'] = Variable<int>(unitId);
    map['price'] = Variable<double>(price);
    map['estimate_day'] = Variable<int>(estimateDay);
    map['is_hour'] = Variable<bool>(isHour);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    return map;
  }

  ServiceTypesCompanion toCompanion(bool nullToAbsent) {
    return ServiceTypesCompanion(
      id: Value(id),
      serviceId: Value(serviceId),
      name: Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      unitId: Value(unitId),
      price: Value(price),
      estimateDay: Value(estimateDay),
      isHour: Value(isHour),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
    );
  }

  factory ServiceType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceType(
      id: serializer.fromJson<int>(json['id']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String?>(json['image']),
      unitId: serializer.fromJson<int>(json['unitId']),
      price: serializer.fromJson<double>(json['price']),
      estimateDay: serializer.fromJson<int>(json['estimateDay']),
      isHour: serializer.fromJson<bool>(json['isHour']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serviceId': serializer.toJson<int>(serviceId),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String?>(image),
      'unitId': serializer.toJson<int>(unitId),
      'price': serializer.toJson<double>(price),
      'estimateDay': serializer.toJson<int>(estimateDay),
      'isHour': serializer.toJson<bool>(isHour),
      'keterangan': serializer.toJson<String?>(keterangan),
    };
  }

  ServiceType copyWith(
          {int? id,
          int? serviceId,
          String? name,
          Value<String?> image = const Value.absent(),
          int? unitId,
          double? price,
          int? estimateDay,
          bool? isHour,
          Value<String?> keterangan = const Value.absent()}) =>
      ServiceType(
        id: id ?? this.id,
        serviceId: serviceId ?? this.serviceId,
        name: name ?? this.name,
        image: image.present ? image.value : this.image,
        unitId: unitId ?? this.unitId,
        price: price ?? this.price,
        estimateDay: estimateDay ?? this.estimateDay,
        isHour: isHour ?? this.isHour,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
      );
  ServiceType copyWithCompanion(ServiceTypesCompanion data) {
    return ServiceType(
      id: data.id.present ? data.id.value : this.id,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      name: data.name.present ? data.name.value : this.name,
      image: data.image.present ? data.image.value : this.image,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      price: data.price.present ? data.price.value : this.price,
      estimateDay:
          data.estimateDay.present ? data.estimateDay.value : this.estimateDay,
      isHour: data.isHour.present ? data.isHour.value : this.isHour,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceType(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('unitId: $unitId, ')
          ..write('price: $price, ')
          ..write('estimateDay: $estimateDay, ')
          ..write('isHour: $isHour, ')
          ..write('keterangan: $keterangan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serviceId, name, image, unitId, price,
      estimateDay, isHour, keterangan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceType &&
          other.id == this.id &&
          other.serviceId == this.serviceId &&
          other.name == this.name &&
          other.image == this.image &&
          other.unitId == this.unitId &&
          other.price == this.price &&
          other.estimateDay == this.estimateDay &&
          other.isHour == this.isHour &&
          other.keterangan == this.keterangan);
}

class ServiceTypesCompanion extends UpdateCompanion<ServiceType> {
  final Value<int> id;
  final Value<int> serviceId;
  final Value<String> name;
  final Value<String?> image;
  final Value<int> unitId;
  final Value<double> price;
  final Value<int> estimateDay;
  final Value<bool> isHour;
  final Value<String?> keterangan;
  const ServiceTypesCompanion({
    this.id = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.unitId = const Value.absent(),
    this.price = const Value.absent(),
    this.estimateDay = const Value.absent(),
    this.isHour = const Value.absent(),
    this.keterangan = const Value.absent(),
  });
  ServiceTypesCompanion.insert({
    this.id = const Value.absent(),
    required int serviceId,
    required String name,
    this.image = const Value.absent(),
    required int unitId,
    required double price,
    required int estimateDay,
    this.isHour = const Value.absent(),
    this.keterangan = const Value.absent(),
  })  : serviceId = Value(serviceId),
        name = Value(name),
        unitId = Value(unitId),
        price = Value(price),
        estimateDay = Value(estimateDay);
  static Insertable<ServiceType> custom({
    Expression<int>? id,
    Expression<int>? serviceId,
    Expression<String>? name,
    Expression<String>? image,
    Expression<int>? unitId,
    Expression<double>? price,
    Expression<int>? estimateDay,
    Expression<bool>? isHour,
    Expression<String>? keterangan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceId != null) 'service_id': serviceId,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (unitId != null) 'unit_id': unitId,
      if (price != null) 'price': price,
      if (estimateDay != null) 'estimate_day': estimateDay,
      if (isHour != null) 'is_hour': isHour,
      if (keterangan != null) 'keterangan': keterangan,
    });
  }

  ServiceTypesCompanion copyWith(
      {Value<int>? id,
      Value<int>? serviceId,
      Value<String>? name,
      Value<String?>? image,
      Value<int>? unitId,
      Value<double>? price,
      Value<int>? estimateDay,
      Value<bool>? isHour,
      Value<String?>? keterangan}) {
    return ServiceTypesCompanion(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      image: image ?? this.image,
      unitId: unitId ?? this.unitId,
      price: price ?? this.price,
      estimateDay: estimateDay ?? this.estimateDay,
      isHour: isHour ?? this.isHour,
      keterangan: keterangan ?? this.keterangan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (estimateDay.present) {
      map['estimate_day'] = Variable<int>(estimateDay.value);
    }
    if (isHour.present) {
      map['is_hour'] = Variable<bool>(isHour.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTypesCompanion(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('unitId: $unitId, ')
          ..write('price: $price, ')
          ..write('estimateDay: $estimateDay, ')
          ..write('isHour: $isHour, ')
          ..write('keterangan: $keterangan')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceMeta =
      const VerificationMeta('invoice');
  @override
  late final GeneratedColumn<String> invoice = GeneratedColumn<String>(
      'invoice', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _metodeBayarMeta =
      const VerificationMeta('metodeBayar');
  @override
  late final GeneratedColumn<String> metodeBayar = GeneratedColumn<String>(
      'metode_bayar', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cash'));
  static const VerificationMeta _diskonMeta = const VerificationMeta('diskon');
  @override
  late final GeneratedColumn<double> diskon = GeneratedColumn<double>(
      'diskon', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _diskonPersenMeta =
      const VerificationMeta('diskonPersen');
  @override
  late final GeneratedColumn<bool> diskonPersen = GeneratedColumn<bool>(
      'diskon_persen', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("diskon_persen" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _jumlahBayarMeta =
      const VerificationMeta('jumlahBayar');
  @override
  late final GeneratedColumn<double> jumlahBayar = GeneratedColumn<double>(
      'jumlah_bayar', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoice,
        customerId,
        total,
        status,
        createdAt,
        metodeBayar,
        diskon,
        diskonPersen,
        jumlahBayar
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice')) {
      context.handle(_invoiceMeta,
          invoice.isAcceptableOrUnknown(data['invoice']!, _invoiceMeta));
    } else if (isInserting) {
      context.missing(_invoiceMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('metode_bayar')) {
      context.handle(
          _metodeBayarMeta,
          metodeBayar.isAcceptableOrUnknown(
              data['metode_bayar']!, _metodeBayarMeta));
    }
    if (data.containsKey('diskon')) {
      context.handle(_diskonMeta,
          diskon.isAcceptableOrUnknown(data['diskon']!, _diskonMeta));
    }
    if (data.containsKey('diskon_persen')) {
      context.handle(
          _diskonPersenMeta,
          diskonPersen.isAcceptableOrUnknown(
              data['diskon_persen']!, _diskonPersenMeta));
    }
    if (data.containsKey('jumlah_bayar')) {
      context.handle(
          _jumlahBayarMeta,
          jumlahBayar.isAcceptableOrUnknown(
              data['jumlah_bayar']!, _jumlahBayarMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      metodeBayar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metode_bayar'])!,
      diskon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}diskon'])!,
      diskonPersen: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}diskon_persen'])!,
      jumlahBayar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}jumlah_bayar'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String invoice;
  final int customerId;
  final double total;
  final String status;
  final DateTime createdAt;
  final String metodeBayar;
  final double diskon;
  final bool diskonPersen;
  final double jumlahBayar;
  const Transaction(
      {required this.id,
      required this.invoice,
      required this.customerId,
      required this.total,
      required this.status,
      required this.createdAt,
      required this.metodeBayar,
      required this.diskon,
      required this.diskonPersen,
      required this.jumlahBayar});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice'] = Variable<String>(invoice);
    map['customer_id'] = Variable<int>(customerId);
    map['total'] = Variable<double>(total);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['metode_bayar'] = Variable<String>(metodeBayar);
    map['diskon'] = Variable<double>(diskon);
    map['diskon_persen'] = Variable<bool>(diskonPersen);
    map['jumlah_bayar'] = Variable<double>(jumlahBayar);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      invoice: Value(invoice),
      customerId: Value(customerId),
      total: Value(total),
      status: Value(status),
      createdAt: Value(createdAt),
      metodeBayar: Value(metodeBayar),
      diskon: Value(diskon),
      diskonPersen: Value(diskonPersen),
      jumlahBayar: Value(jumlahBayar),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      invoice: serializer.fromJson<String>(json['invoice']),
      customerId: serializer.fromJson<int>(json['customerId']),
      total: serializer.fromJson<double>(json['total']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      metodeBayar: serializer.fromJson<String>(json['metodeBayar']),
      diskon: serializer.fromJson<double>(json['diskon']),
      diskonPersen: serializer.fromJson<bool>(json['diskonPersen']),
      jumlahBayar: serializer.fromJson<double>(json['jumlahBayar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoice': serializer.toJson<String>(invoice),
      'customerId': serializer.toJson<int>(customerId),
      'total': serializer.toJson<double>(total),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'metodeBayar': serializer.toJson<String>(metodeBayar),
      'diskon': serializer.toJson<double>(diskon),
      'diskonPersen': serializer.toJson<bool>(diskonPersen),
      'jumlahBayar': serializer.toJson<double>(jumlahBayar),
    };
  }

  Transaction copyWith(
          {int? id,
          String? invoice,
          int? customerId,
          double? total,
          String? status,
          DateTime? createdAt,
          String? metodeBayar,
          double? diskon,
          bool? diskonPersen,
          double? jumlahBayar}) =>
      Transaction(
        id: id ?? this.id,
        invoice: invoice ?? this.invoice,
        customerId: customerId ?? this.customerId,
        total: total ?? this.total,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        metodeBayar: metodeBayar ?? this.metodeBayar,
        diskon: diskon ?? this.diskon,
        diskonPersen: diskonPersen ?? this.diskonPersen,
        jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      invoice: data.invoice.present ? data.invoice.value : this.invoice,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      metodeBayar:
          data.metodeBayar.present ? data.metodeBayar.value : this.metodeBayar,
      diskon: data.diskon.present ? data.diskon.value : this.diskon,
      diskonPersen: data.diskonPersen.present
          ? data.diskonPersen.value
          : this.diskonPersen,
      jumlahBayar:
          data.jumlahBayar.present ? data.jumlahBayar.value : this.jumlahBayar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('invoice: $invoice, ')
          ..write('customerId: $customerId, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('metodeBayar: $metodeBayar, ')
          ..write('diskon: $diskon, ')
          ..write('diskonPersen: $diskonPersen, ')
          ..write('jumlahBayar: $jumlahBayar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoice, customerId, total, status,
      createdAt, metodeBayar, diskon, diskonPersen, jumlahBayar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.invoice == this.invoice &&
          other.customerId == this.customerId &&
          other.total == this.total &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.metodeBayar == this.metodeBayar &&
          other.diskon == this.diskon &&
          other.diskonPersen == this.diskonPersen &&
          other.jumlahBayar == this.jumlahBayar);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> invoice;
  final Value<int> customerId;
  final Value<double> total;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String> metodeBayar;
  final Value<double> diskon;
  final Value<bool> diskonPersen;
  final Value<double> jumlahBayar;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.invoice = const Value.absent(),
    this.customerId = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.metodeBayar = const Value.absent(),
    this.diskon = const Value.absent(),
    this.diskonPersen = const Value.absent(),
    this.jumlahBayar = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String invoice,
    required int customerId,
    required double total,
    required String status,
    required DateTime createdAt,
    this.metodeBayar = const Value.absent(),
    this.diskon = const Value.absent(),
    this.diskonPersen = const Value.absent(),
    this.jumlahBayar = const Value.absent(),
  })  : invoice = Value(invoice),
        customerId = Value(customerId),
        total = Value(total),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? invoice,
    Expression<int>? customerId,
    Expression<double>? total,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? metodeBayar,
    Expression<double>? diskon,
    Expression<bool>? diskonPersen,
    Expression<double>? jumlahBayar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoice != null) 'invoice': invoice,
      if (customerId != null) 'customer_id': customerId,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (metodeBayar != null) 'metode_bayar': metodeBayar,
      if (diskon != null) 'diskon': diskon,
      if (diskonPersen != null) 'diskon_persen': diskonPersen,
      if (jumlahBayar != null) 'jumlah_bayar': jumlahBayar,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? invoice,
      Value<int>? customerId,
      Value<double>? total,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<String>? metodeBayar,
      Value<double>? diskon,
      Value<bool>? diskonPersen,
      Value<double>? jumlahBayar}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      invoice: invoice ?? this.invoice,
      customerId: customerId ?? this.customerId,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      metodeBayar: metodeBayar ?? this.metodeBayar,
      diskon: diskon ?? this.diskon,
      diskonPersen: diskonPersen ?? this.diskonPersen,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoice.present) {
      map['invoice'] = Variable<String>(invoice.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (metodeBayar.present) {
      map['metode_bayar'] = Variable<String>(metodeBayar.value);
    }
    if (diskon.present) {
      map['diskon'] = Variable<double>(diskon.value);
    }
    if (diskonPersen.present) {
      map['diskon_persen'] = Variable<bool>(diskonPersen.value);
    }
    if (jumlahBayar.present) {
      map['jumlah_bayar'] = Variable<double>(jumlahBayar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('invoice: $invoice, ')
          ..write('customerId: $customerId, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('metodeBayar: $metodeBayar, ')
          ..write('diskon: $diskon, ')
          ..write('diskonPersen: $diskonPersen, ')
          ..write('jumlahBayar: $jumlahBayar')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _serviceTypeIdMeta =
      const VerificationMeta('serviceTypeId');
  @override
  late final GeneratedColumn<int> serviceTypeId = GeneratedColumn<int>(
      'service_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
      'qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _perfumeIdMeta =
      const VerificationMeta('perfumeId');
  @override
  late final GeneratedColumn<int> perfumeId = GeneratedColumn<int>(
      'perfume_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tanggalMasukMeta =
      const VerificationMeta('tanggalMasuk');
  @override
  late final GeneratedColumn<DateTime> tanggalMasuk = GeneratedColumn<DateTime>(
      'tanggal_masuk', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _estimasiSelesaiMeta =
      const VerificationMeta('estimasiSelesai');
  @override
  late final GeneratedColumn<DateTime> estimasiSelesai =
      GeneratedColumn<DateTime>('estimasi_selesai', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionId,
        serviceTypeId,
        qty,
        price,
        perfumeId,
        keterangan,
        tanggalMasuk,
        estimasiSelesai
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('service_type_id')) {
      context.handle(
          _serviceTypeIdMeta,
          serviceTypeId.isAcceptableOrUnknown(
              data['service_type_id']!, _serviceTypeIdMeta));
    } else if (isInserting) {
      context.missing(_serviceTypeIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('perfume_id')) {
      context.handle(_perfumeIdMeta,
          perfumeId.isAcceptableOrUnknown(data['perfume_id']!, _perfumeIdMeta));
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    if (data.containsKey('tanggal_masuk')) {
      context.handle(
          _tanggalMasukMeta,
          tanggalMasuk.isAcceptableOrUnknown(
              data['tanggal_masuk']!, _tanggalMasukMeta));
    }
    if (data.containsKey('estimasi_selesai')) {
      context.handle(
          _estimasiSelesaiMeta,
          estimasiSelesai.isAcceptableOrUnknown(
              data['estimasi_selesai']!, _estimasiSelesaiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      serviceTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}service_type_id'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}qty'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      perfumeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}perfume_id']),
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
      tanggalMasuk: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}tanggal_masuk'])!,
      estimasiSelesai: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}estimasi_selesai'])!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int id;
  final int transactionId;
  final int serviceTypeId;
  final double qty;
  final double price;
  final int? perfumeId;
  final String? keterangan;
  final DateTime tanggalMasuk;
  final DateTime estimasiSelesai;
  const TransactionItem(
      {required this.id,
      required this.transactionId,
      required this.serviceTypeId,
      required this.qty,
      required this.price,
      this.perfumeId,
      this.keterangan,
      required this.tanggalMasuk,
      required this.estimasiSelesai});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['service_type_id'] = Variable<int>(serviceTypeId);
    map['qty'] = Variable<double>(qty);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || perfumeId != null) {
      map['perfume_id'] = Variable<int>(perfumeId);
    }
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    map['tanggal_masuk'] = Variable<DateTime>(tanggalMasuk);
    map['estimasi_selesai'] = Variable<DateTime>(estimasiSelesai);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      serviceTypeId: Value(serviceTypeId),
      qty: Value(qty),
      price: Value(price),
      perfumeId: perfumeId == null && nullToAbsent
          ? const Value.absent()
          : Value(perfumeId),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      tanggalMasuk: Value(tanggalMasuk),
      estimasiSelesai: Value(estimasiSelesai),
    );
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      serviceTypeId: serializer.fromJson<int>(json['serviceTypeId']),
      qty: serializer.fromJson<double>(json['qty']),
      price: serializer.fromJson<double>(json['price']),
      perfumeId: serializer.fromJson<int?>(json['perfumeId']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      tanggalMasuk: serializer.fromJson<DateTime>(json['tanggalMasuk']),
      estimasiSelesai: serializer.fromJson<DateTime>(json['estimasiSelesai']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'serviceTypeId': serializer.toJson<int>(serviceTypeId),
      'qty': serializer.toJson<double>(qty),
      'price': serializer.toJson<double>(price),
      'perfumeId': serializer.toJson<int?>(perfumeId),
      'keterangan': serializer.toJson<String?>(keterangan),
      'tanggalMasuk': serializer.toJson<DateTime>(tanggalMasuk),
      'estimasiSelesai': serializer.toJson<DateTime>(estimasiSelesai),
    };
  }

  TransactionItem copyWith(
          {int? id,
          int? transactionId,
          int? serviceTypeId,
          double? qty,
          double? price,
          Value<int?> perfumeId = const Value.absent(),
          Value<String?> keterangan = const Value.absent(),
          DateTime? tanggalMasuk,
          DateTime? estimasiSelesai}) =>
      TransactionItem(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        serviceTypeId: serviceTypeId ?? this.serviceTypeId,
        qty: qty ?? this.qty,
        price: price ?? this.price,
        perfumeId: perfumeId.present ? perfumeId.value : this.perfumeId,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
        tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
        estimasiSelesai: estimasiSelesai ?? this.estimasiSelesai,
      );
  TransactionItem copyWithCompanion(TransactionItemsCompanion data) {
    return TransactionItem(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      serviceTypeId: data.serviceTypeId.present
          ? data.serviceTypeId.value
          : this.serviceTypeId,
      qty: data.qty.present ? data.qty.value : this.qty,
      price: data.price.present ? data.price.value : this.price,
      perfumeId: data.perfumeId.present ? data.perfumeId.value : this.perfumeId,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
      tanggalMasuk: data.tanggalMasuk.present
          ? data.tanggalMasuk.value
          : this.tanggalMasuk,
      estimasiSelesai: data.estimasiSelesai.present
          ? data.estimasiSelesai.value
          : this.estimasiSelesai,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItem(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('perfumeId: $perfumeId, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggalMasuk: $tanggalMasuk, ')
          ..write('estimasiSelesai: $estimasiSelesai')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionId, serviceTypeId, qty, price,
      perfumeId, keterangan, tanggalMasuk, estimasiSelesai);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItem &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.serviceTypeId == this.serviceTypeId &&
          other.qty == this.qty &&
          other.price == this.price &&
          other.perfumeId == this.perfumeId &&
          other.keterangan == this.keterangan &&
          other.tanggalMasuk == this.tanggalMasuk &&
          other.estimasiSelesai == this.estimasiSelesai);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> serviceTypeId;
  final Value<double> qty;
  final Value<double> price;
  final Value<int?> perfumeId;
  final Value<String?> keterangan;
  final Value<DateTime> tanggalMasuk;
  final Value<DateTime> estimasiSelesai;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.serviceTypeId = const Value.absent(),
    this.qty = const Value.absent(),
    this.price = const Value.absent(),
    this.perfumeId = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.tanggalMasuk = const Value.absent(),
    this.estimasiSelesai = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int serviceTypeId,
    required double qty,
    required double price,
    this.perfumeId = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.tanggalMasuk = const Value.absent(),
    this.estimasiSelesai = const Value.absent(),
  })  : transactionId = Value(transactionId),
        serviceTypeId = Value(serviceTypeId),
        qty = Value(qty),
        price = Value(price);
  static Insertable<TransactionItem> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? serviceTypeId,
    Expression<double>? qty,
    Expression<double>? price,
    Expression<int>? perfumeId,
    Expression<String>? keterangan,
    Expression<DateTime>? tanggalMasuk,
    Expression<DateTime>? estimasiSelesai,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (serviceTypeId != null) 'service_type_id': serviceTypeId,
      if (qty != null) 'qty': qty,
      if (price != null) 'price': price,
      if (perfumeId != null) 'perfume_id': perfumeId,
      if (keterangan != null) 'keterangan': keterangan,
      if (tanggalMasuk != null) 'tanggal_masuk': tanggalMasuk,
      if (estimasiSelesai != null) 'estimasi_selesai': estimasiSelesai,
    });
  }

  TransactionItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? serviceTypeId,
      Value<double>? qty,
      Value<double>? price,
      Value<int?>? perfumeId,
      Value<String?>? keterangan,
      Value<DateTime>? tanggalMasuk,
      Value<DateTime>? estimasiSelesai}) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      perfumeId: perfumeId ?? this.perfumeId,
      keterangan: keterangan ?? this.keterangan,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      estimasiSelesai: estimasiSelesai ?? this.estimasiSelesai,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (serviceTypeId.present) {
      map['service_type_id'] = Variable<int>(serviceTypeId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (perfumeId.present) {
      map['perfume_id'] = Variable<int>(perfumeId.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (tanggalMasuk.present) {
      map['tanggal_masuk'] = Variable<DateTime>(tanggalMasuk.value);
    }
    if (estimasiSelesai.present) {
      map['estimasi_selesai'] = Variable<DateTime>(estimasiSelesai.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('serviceTypeId: $serviceTypeId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('perfumeId: $perfumeId, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggalMasuk: $tanggalMasuk, ')
          ..write('estimasiSelesai: $estimasiSelesai')
          ..write(')'))
        .toString();
  }
}

class $PengeluaransTable extends Pengeluarans
    with TableInfo<$PengeluaransTable, Pengeluaran> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PengeluaransTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
      'nama', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<double> jumlah = GeneratedColumn<double>(
      'jumlah', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tanggalMeta =
      const VerificationMeta('tanggal');
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
      'tanggal', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, nama, jumlah, keterangan, tanggal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pengeluarans';
  @override
  VerificationContext validateIntegrity(Insertable<Pengeluaran> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
          _namaMeta, nama.isAcceptableOrUnknown(data['nama']!, _namaMeta));
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(_jumlahMeta,
          jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta));
    } else if (isInserting) {
      context.missing(_jumlahMeta);
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    if (data.containsKey('tanggal')) {
      context.handle(_tanggalMeta,
          tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pengeluaran map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pengeluaran(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nama: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama'])!,
      jumlah: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}jumlah'])!,
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
      tanggal: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tanggal'])!,
    );
  }

  @override
  $PengeluaransTable createAlias(String alias) {
    return $PengeluaransTable(attachedDatabase, alias);
  }
}

class Pengeluaran extends DataClass implements Insertable<Pengeluaran> {
  final int id;
  final String nama;
  final double jumlah;
  final String? keterangan;
  final DateTime tanggal;
  const Pengeluaran(
      {required this.id,
      required this.nama,
      required this.jumlah,
      this.keterangan,
      required this.tanggal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    map['jumlah'] = Variable<double>(jumlah);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    return map;
  }

  PengeluaransCompanion toCompanion(bool nullToAbsent) {
    return PengeluaransCompanion(
      id: Value(id),
      nama: Value(nama),
      jumlah: Value(jumlah),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      tanggal: Value(tanggal),
    );
  }

  factory Pengeluaran.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pengeluaran(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      jumlah: serializer.fromJson<double>(json['jumlah']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'jumlah': serializer.toJson<double>(jumlah),
      'keterangan': serializer.toJson<String?>(keterangan),
      'tanggal': serializer.toJson<DateTime>(tanggal),
    };
  }

  Pengeluaran copyWith(
          {int? id,
          String? nama,
          double? jumlah,
          Value<String?> keterangan = const Value.absent(),
          DateTime? tanggal}) =>
      Pengeluaran(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        jumlah: jumlah ?? this.jumlah,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
        tanggal: tanggal ?? this.tanggal,
      );
  Pengeluaran copyWithCompanion(PengeluaransCompanion data) {
    return Pengeluaran(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pengeluaran(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jumlah: $jumlah, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, jumlah, keterangan, tanggal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pengeluaran &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.jumlah == this.jumlah &&
          other.keterangan == this.keterangan &&
          other.tanggal == this.tanggal);
}

class PengeluaransCompanion extends UpdateCompanion<Pengeluaran> {
  final Value<int> id;
  final Value<String> nama;
  final Value<double> jumlah;
  final Value<String?> keterangan;
  final Value<DateTime> tanggal;
  const PengeluaransCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.tanggal = const Value.absent(),
  });
  PengeluaransCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    required double jumlah,
    this.keterangan = const Value.absent(),
    this.tanggal = const Value.absent(),
  })  : nama = Value(nama),
        jumlah = Value(jumlah);
  static Insertable<Pengeluaran> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<double>? jumlah,
    Expression<String>? keterangan,
    Expression<DateTime>? tanggal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (jumlah != null) 'jumlah': jumlah,
      if (keterangan != null) 'keterangan': keterangan,
      if (tanggal != null) 'tanggal': tanggal,
    });
  }

  PengeluaransCompanion copyWith(
      {Value<int>? id,
      Value<String>? nama,
      Value<double>? jumlah,
      Value<String?>? keterangan,
      Value<DateTime>? tanggal}) {
    return PengeluaransCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jumlah: jumlah ?? this.jumlah,
      keterangan: keterangan ?? this.keterangan,
      tanggal: tanggal ?? this.tanggal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<double>(jumlah.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PengeluaransCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jumlah: $jumlah, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal')
          ..write(')'))
        .toString();
  }
}

class $KasirsTable extends Kasirs with TableInfo<$KasirsTable, Kasir> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KasirsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
      'nama', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noHpMeta = const VerificationMeta('noHp');
  @override
  late final GeneratedColumn<String> noHp = GeneratedColumn<String>(
      'no_hp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fotoPathMeta =
      const VerificationMeta('fotoPath');
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
      'foto_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
      'pin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAktifMeta =
      const VerificationMeta('isAktif');
  @override
  late final GeneratedColumn<bool> isAktif = GeneratedColumn<bool>(
      'is_aktif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_aktif" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nama, noHp, fotoPath, pin, isAktif];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kasirs';
  @override
  VerificationContext validateIntegrity(Insertable<Kasir> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
          _namaMeta, nama.isAcceptableOrUnknown(data['nama']!, _namaMeta));
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('no_hp')) {
      context.handle(
          _noHpMeta, noHp.isAcceptableOrUnknown(data['no_hp']!, _noHpMeta));
    }
    if (data.containsKey('foto_path')) {
      context.handle(_fotoPathMeta,
          fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta));
    }
    if (data.containsKey('pin')) {
      context.handle(
          _pinMeta, pin.isAcceptableOrUnknown(data['pin']!, _pinMeta));
    }
    if (data.containsKey('is_aktif')) {
      context.handle(_isAktifMeta,
          isAktif.isAcceptableOrUnknown(data['is_aktif']!, _isAktifMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kasir map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kasir(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nama: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama'])!,
      noHp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_hp']),
      fotoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}foto_path']),
      pin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin']),
      isAktif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_aktif'])!,
    );
  }

  @override
  $KasirsTable createAlias(String alias) {
    return $KasirsTable(attachedDatabase, alias);
  }
}

class Kasir extends DataClass implements Insertable<Kasir> {
  final int id;
  final String nama;
  final String? noHp;
  final String? fotoPath;
  final String? pin;
  final bool isAktif;
  const Kasir(
      {required this.id,
      required this.nama,
      this.noHp,
      this.fotoPath,
      this.pin,
      required this.isAktif});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || noHp != null) {
      map['no_hp'] = Variable<String>(noHp);
    }
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    if (!nullToAbsent || pin != null) {
      map['pin'] = Variable<String>(pin);
    }
    map['is_aktif'] = Variable<bool>(isAktif);
    return map;
  }

  KasirsCompanion toCompanion(bool nullToAbsent) {
    return KasirsCompanion(
      id: Value(id),
      nama: Value(nama),
      noHp: noHp == null && nullToAbsent ? const Value.absent() : Value(noHp),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      isAktif: Value(isAktif),
    );
  }

  factory Kasir.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kasir(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      noHp: serializer.fromJson<String?>(json['noHp']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      pin: serializer.fromJson<String?>(json['pin']),
      isAktif: serializer.fromJson<bool>(json['isAktif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'noHp': serializer.toJson<String?>(noHp),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'pin': serializer.toJson<String?>(pin),
      'isAktif': serializer.toJson<bool>(isAktif),
    };
  }

  Kasir copyWith(
          {int? id,
          String? nama,
          Value<String?> noHp = const Value.absent(),
          Value<String?> fotoPath = const Value.absent(),
          Value<String?> pin = const Value.absent(),
          bool? isAktif}) =>
      Kasir(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        noHp: noHp.present ? noHp.value : this.noHp,
        fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
        pin: pin.present ? pin.value : this.pin,
        isAktif: isAktif ?? this.isAktif,
      );
  Kasir copyWithCompanion(KasirsCompanion data) {
    return Kasir(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      noHp: data.noHp.present ? data.noHp.value : this.noHp,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      pin: data.pin.present ? data.pin.value : this.pin,
      isAktif: data.isAktif.present ? data.isAktif.value : this.isAktif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kasir(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('noHp: $noHp, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('pin: $pin, ')
          ..write('isAktif: $isAktif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, noHp, fotoPath, pin, isAktif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kasir &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.noHp == this.noHp &&
          other.fotoPath == this.fotoPath &&
          other.pin == this.pin &&
          other.isAktif == this.isAktif);
}

class KasirsCompanion extends UpdateCompanion<Kasir> {
  final Value<int> id;
  final Value<String> nama;
  final Value<String?> noHp;
  final Value<String?> fotoPath;
  final Value<String?> pin;
  final Value<bool> isAktif;
  const KasirsCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.noHp = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.pin = const Value.absent(),
    this.isAktif = const Value.absent(),
  });
  KasirsCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    this.noHp = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.pin = const Value.absent(),
    this.isAktif = const Value.absent(),
  }) : nama = Value(nama);
  static Insertable<Kasir> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<String>? noHp,
    Expression<String>? fotoPath,
    Expression<String>? pin,
    Expression<bool>? isAktif,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (noHp != null) 'no_hp': noHp,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (pin != null) 'pin': pin,
      if (isAktif != null) 'is_aktif': isAktif,
    });
  }

  KasirsCompanion copyWith(
      {Value<int>? id,
      Value<String>? nama,
      Value<String?>? noHp,
      Value<String?>? fotoPath,
      Value<String?>? pin,
      Value<bool>? isAktif}) {
    return KasirsCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noHp: noHp ?? this.noHp,
      fotoPath: fotoPath ?? this.fotoPath,
      pin: pin ?? this.pin,
      isAktif: isAktif ?? this.isAktif,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (noHp.present) {
      map['no_hp'] = Variable<String>(noHp.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (isAktif.present) {
      map['is_aktif'] = Variable<bool>(isAktif.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KasirsCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('noHp: $noHp, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('pin: $pin, ')
          ..write('isAktif: $isAktif')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $PerfumesTable perfumes = $PerfumesTable(this);
  late final $ServiceProcessesTable serviceProcesses =
      $ServiceProcessesTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $ServiceTypesTable serviceTypes = $ServiceTypesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems =
      $TransactionItemsTable(this);
  late final $PengeluaransTable pengeluarans = $PengeluaransTable(this);
  late final $KasirsTable kasirs = $KasirsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        customers,
        units,
        perfumes,
        serviceProcesses,
        services,
        serviceTypes,
        transactions,
        transactionItems,
        pengeluarans,
        kasirs
      ];
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> email,
  required String phone,
  Value<String?> gender,
  Value<String?> address,
  Value<String?> photo,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> email,
  Value<String> phone,
  Value<String?> gender,
  Value<String?> address,
  Value<String?> photo,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> photo = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            email: email,
            phone: phone,
            gender: gender,
            address: address,
            photo: photo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> email = const Value.absent(),
            required String phone,
            Value<String?> gender = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> photo = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            email: email,
            phone: phone,
            gender: gender,
            address: address,
            photo: photo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              UnitsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()>;
typedef $$PerfumesTableCreateCompanionBuilder = PerfumesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$PerfumesTableUpdateCompanionBuilder = PerfumesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$PerfumesTableFilterComposer
    extends Composer<_$AppDatabase, $PerfumesTable> {
  $$PerfumesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$PerfumesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerfumesTable> {
  $$PerfumesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$PerfumesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerfumesTable> {
  $$PerfumesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$PerfumesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PerfumesTable,
    Perfume,
    $$PerfumesTableFilterComposer,
    $$PerfumesTableOrderingComposer,
    $$PerfumesTableAnnotationComposer,
    $$PerfumesTableCreateCompanionBuilder,
    $$PerfumesTableUpdateCompanionBuilder,
    (Perfume, BaseReferences<_$AppDatabase, $PerfumesTable, Perfume>),
    Perfume,
    PrefetchHooks Function()> {
  $$PerfumesTableTableManager(_$AppDatabase db, $PerfumesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerfumesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerfumesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerfumesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              PerfumesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              PerfumesCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PerfumesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PerfumesTable,
    Perfume,
    $$PerfumesTableFilterComposer,
    $$PerfumesTableOrderingComposer,
    $$PerfumesTableAnnotationComposer,
    $$PerfumesTableCreateCompanionBuilder,
    $$PerfumesTableUpdateCompanionBuilder,
    (Perfume, BaseReferences<_$AppDatabase, $PerfumesTable, Perfume>),
    Perfume,
    PrefetchHooks Function()>;
typedef $$ServiceProcessesTableCreateCompanionBuilder
    = ServiceProcessesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ServiceProcessesTableUpdateCompanionBuilder
    = ServiceProcessesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$ServiceProcessesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceProcessesTable> {
  $$ServiceProcessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$ServiceProcessesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceProcessesTable> {
  $$ServiceProcessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$ServiceProcessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceProcessesTable> {
  $$ServiceProcessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$ServiceProcessesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceProcessesTable,
    ServiceProcessesData,
    $$ServiceProcessesTableFilterComposer,
    $$ServiceProcessesTableOrderingComposer,
    $$ServiceProcessesTableAnnotationComposer,
    $$ServiceProcessesTableCreateCompanionBuilder,
    $$ServiceProcessesTableUpdateCompanionBuilder,
    (
      ServiceProcessesData,
      BaseReferences<_$AppDatabase, $ServiceProcessesTable,
          ServiceProcessesData>
    ),
    ServiceProcessesData,
    PrefetchHooks Function()> {
  $$ServiceProcessesTableTableManager(
      _$AppDatabase db, $ServiceProcessesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceProcessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceProcessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceProcessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ServiceProcessesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              ServiceProcessesCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServiceProcessesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceProcessesTable,
    ServiceProcessesData,
    $$ServiceProcessesTableFilterComposer,
    $$ServiceProcessesTableOrderingComposer,
    $$ServiceProcessesTableAnnotationComposer,
    $$ServiceProcessesTableCreateCompanionBuilder,
    $$ServiceProcessesTableUpdateCompanionBuilder,
    (
      ServiceProcessesData,
      BaseReferences<_$AppDatabase, $ServiceProcessesTable,
          ServiceProcessesData>
    ),
    ServiceProcessesData,
    PrefetchHooks Function()>;
typedef $$ServicesTableCreateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  required String name,
  required bool cuci,
  required bool kering,
  required bool setrika,
});
typedef $$ServicesTableUpdateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> cuci,
  Value<bool> kering,
  Value<bool> setrika,
});

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cuci => $composableBuilder(
      column: $table.cuci, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get kering => $composableBuilder(
      column: $table.kering, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get setrika => $composableBuilder(
      column: $table.setrika, builder: (column) => ColumnFilters(column));
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cuci => $composableBuilder(
      column: $table.cuci, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get kering => $composableBuilder(
      column: $table.kering, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get setrika => $composableBuilder(
      column: $table.setrika, builder: (column) => ColumnOrderings(column));
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get cuci =>
      $composableBuilder(column: $table.cuci, builder: (column) => column);

  GeneratedColumn<bool> get kering =>
      $composableBuilder(column: $table.kering, builder: (column) => column);

  GeneratedColumn<bool> get setrika =>
      $composableBuilder(column: $table.setrika, builder: (column) => column);
}

class $$ServicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
    Service,
    PrefetchHooks Function()> {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> cuci = const Value.absent(),
            Value<bool> kering = const Value.absent(),
            Value<bool> setrika = const Value.absent(),
          }) =>
              ServicesCompanion(
            id: id,
            name: name,
            cuci: cuci,
            kering: kering,
            setrika: setrika,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required bool cuci,
            required bool kering,
            required bool setrika,
          }) =>
              ServicesCompanion.insert(
            id: id,
            name: name,
            cuci: cuci,
            kering: kering,
            setrika: setrika,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
    Service,
    PrefetchHooks Function()>;
typedef $$ServiceTypesTableCreateCompanionBuilder = ServiceTypesCompanion
    Function({
  Value<int> id,
  required int serviceId,
  required String name,
  Value<String?> image,
  required int unitId,
  required double price,
  required int estimateDay,
  Value<bool> isHour,
  Value<String?> keterangan,
});
typedef $$ServiceTypesTableUpdateCompanionBuilder = ServiceTypesCompanion
    Function({
  Value<int> id,
  Value<int> serviceId,
  Value<String> name,
  Value<String?> image,
  Value<int> unitId,
  Value<double> price,
  Value<int> estimateDay,
  Value<bool> isHour,
  Value<String?> keterangan,
});

class $$ServiceTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimateDay => $composableBuilder(
      column: $table.estimateDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHour => $composableBuilder(
      column: $table.isHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));
}

class $$ServiceTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimateDay => $composableBuilder(
      column: $table.estimateDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHour => $composableBuilder(
      column: $table.isHour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));
}

class $$ServiceTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get estimateDay => $composableBuilder(
      column: $table.estimateDay, builder: (column) => column);

  GeneratedColumn<bool> get isHour =>
      $composableBuilder(column: $table.isHour, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);
}

class $$ServiceTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceTypesTable,
    ServiceType,
    $$ServiceTypesTableFilterComposer,
    $$ServiceTypesTableOrderingComposer,
    $$ServiceTypesTableAnnotationComposer,
    $$ServiceTypesTableCreateCompanionBuilder,
    $$ServiceTypesTableUpdateCompanionBuilder,
    (
      ServiceType,
      BaseReferences<_$AppDatabase, $ServiceTypesTable, ServiceType>
    ),
    ServiceType,
    PrefetchHooks Function()> {
  $$ServiceTypesTableTableManager(_$AppDatabase db, $ServiceTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> serviceId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int> unitId = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> estimateDay = const Value.absent(),
            Value<bool> isHour = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
          }) =>
              ServiceTypesCompanion(
            id: id,
            serviceId: serviceId,
            name: name,
            image: image,
            unitId: unitId,
            price: price,
            estimateDay: estimateDay,
            isHour: isHour,
            keterangan: keterangan,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int serviceId,
            required String name,
            Value<String?> image = const Value.absent(),
            required int unitId,
            required double price,
            required int estimateDay,
            Value<bool> isHour = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
          }) =>
              ServiceTypesCompanion.insert(
            id: id,
            serviceId: serviceId,
            name: name,
            image: image,
            unitId: unitId,
            price: price,
            estimateDay: estimateDay,
            isHour: isHour,
            keterangan: keterangan,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServiceTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceTypesTable,
    ServiceType,
    $$ServiceTypesTableFilterComposer,
    $$ServiceTypesTableOrderingComposer,
    $$ServiceTypesTableAnnotationComposer,
    $$ServiceTypesTableCreateCompanionBuilder,
    $$ServiceTypesTableUpdateCompanionBuilder,
    (
      ServiceType,
      BaseReferences<_$AppDatabase, $ServiceTypesTable, ServiceType>
    ),
    ServiceType,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required String invoice,
  required int customerId,
  required double total,
  required String status,
  required DateTime createdAt,
  Value<String> metodeBayar,
  Value<double> diskon,
  Value<bool> diskonPersen,
  Value<double> jumlahBayar,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String> invoice,
  Value<int> customerId,
  Value<double> total,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<String> metodeBayar,
  Value<double> diskon,
  Value<bool> diskonPersen,
  Value<double> jumlahBayar,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoice => $composableBuilder(
      column: $table.invoice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodeBayar => $composableBuilder(
      column: $table.metodeBayar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get diskon => $composableBuilder(
      column: $table.diskon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get diskonPersen => $composableBuilder(
      column: $table.diskonPersen, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get jumlahBayar => $composableBuilder(
      column: $table.jumlahBayar, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoice => $composableBuilder(
      column: $table.invoice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodeBayar => $composableBuilder(
      column: $table.metodeBayar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get diskon => $composableBuilder(
      column: $table.diskon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get diskonPersen => $composableBuilder(
      column: $table.diskonPersen,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get jumlahBayar => $composableBuilder(
      column: $table.jumlahBayar, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoice =>
      $composableBuilder(column: $table.invoice, builder: (column) => column);

  GeneratedColumn<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get metodeBayar => $composableBuilder(
      column: $table.metodeBayar, builder: (column) => column);

  GeneratedColumn<double> get diskon =>
      $composableBuilder(column: $table.diskon, builder: (column) => column);

  GeneratedColumn<bool> get diskonPersen => $composableBuilder(
      column: $table.diskonPersen, builder: (column) => column);

  GeneratedColumn<double> get jumlahBayar => $composableBuilder(
      column: $table.jumlahBayar, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> invoice = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> metodeBayar = const Value.absent(),
            Value<double> diskon = const Value.absent(),
            Value<bool> diskonPersen = const Value.absent(),
            Value<double> jumlahBayar = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            invoice: invoice,
            customerId: customerId,
            total: total,
            status: status,
            createdAt: createdAt,
            metodeBayar: metodeBayar,
            diskon: diskon,
            diskonPersen: diskonPersen,
            jumlahBayar: jumlahBayar,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String invoice,
            required int customerId,
            required double total,
            required String status,
            required DateTime createdAt,
            Value<String> metodeBayar = const Value.absent(),
            Value<double> diskon = const Value.absent(),
            Value<bool> diskonPersen = const Value.absent(),
            Value<double> jumlahBayar = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            invoice: invoice,
            customerId: customerId,
            total: total,
            status: status,
            createdAt: createdAt,
            metodeBayar: metodeBayar,
            diskon: diskon,
            diskonPersen: diskonPersen,
            jumlahBayar: jumlahBayar,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$TransactionItemsTableCreateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  required int transactionId,
  required int serviceTypeId,
  required double qty,
  required double price,
  Value<int?> perfumeId,
  Value<String?> keterangan,
  Value<DateTime> tanggalMasuk,
  Value<DateTime> estimasiSelesai,
});
typedef $$TransactionItemsTableUpdateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  Value<int> transactionId,
  Value<int> serviceTypeId,
  Value<double> qty,
  Value<double> price,
  Value<int?> perfumeId,
  Value<String?> keterangan,
  Value<DateTime> tanggalMasuk,
  Value<DateTime> estimasiSelesai,
});

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serviceTypeId => $composableBuilder(
      column: $table.serviceTypeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get perfumeId => $composableBuilder(
      column: $table.perfumeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggalMasuk => $composableBuilder(
      column: $table.tanggalMasuk, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get estimasiSelesai => $composableBuilder(
      column: $table.estimasiSelesai,
      builder: (column) => ColumnFilters(column));
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serviceTypeId => $composableBuilder(
      column: $table.serviceTypeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get perfumeId => $composableBuilder(
      column: $table.perfumeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggalMasuk => $composableBuilder(
      column: $table.tanggalMasuk,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get estimasiSelesai => $composableBuilder(
      column: $table.estimasiSelesai,
      builder: (column) => ColumnOrderings(column));
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<int> get serviceTypeId => $composableBuilder(
      column: $table.serviceTypeId, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get perfumeId =>
      $composableBuilder(column: $table.perfumeId, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalMasuk => $composableBuilder(
      column: $table.tanggalMasuk, builder: (column) => column);

  GeneratedColumn<DateTime> get estimasiSelesai => $composableBuilder(
      column: $table.estimasiSelesai, builder: (column) => column);
}

class $$TransactionItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (
      TransactionItem,
      BaseReferences<_$AppDatabase, $TransactionItemsTable, TransactionItem>
    ),
    TransactionItem,
    PrefetchHooks Function()> {
  $$TransactionItemsTableTableManager(
      _$AppDatabase db, $TransactionItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transactionId = const Value.absent(),
            Value<int> serviceTypeId = const Value.absent(),
            Value<double> qty = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int?> perfumeId = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<DateTime> tanggalMasuk = const Value.absent(),
            Value<DateTime> estimasiSelesai = const Value.absent(),
          }) =>
              TransactionItemsCompanion(
            id: id,
            transactionId: transactionId,
            serviceTypeId: serviceTypeId,
            qty: qty,
            price: price,
            perfumeId: perfumeId,
            keterangan: keterangan,
            tanggalMasuk: tanggalMasuk,
            estimasiSelesai: estimasiSelesai,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transactionId,
            required int serviceTypeId,
            required double qty,
            required double price,
            Value<int?> perfumeId = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<DateTime> tanggalMasuk = const Value.absent(),
            Value<DateTime> estimasiSelesai = const Value.absent(),
          }) =>
              TransactionItemsCompanion.insert(
            id: id,
            transactionId: transactionId,
            serviceTypeId: serviceTypeId,
            qty: qty,
            price: price,
            perfumeId: perfumeId,
            keterangan: keterangan,
            tanggalMasuk: tanggalMasuk,
            estimasiSelesai: estimasiSelesai,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (
      TransactionItem,
      BaseReferences<_$AppDatabase, $TransactionItemsTable, TransactionItem>
    ),
    TransactionItem,
    PrefetchHooks Function()>;
typedef $$PengeluaransTableCreateCompanionBuilder = PengeluaransCompanion
    Function({
  Value<int> id,
  required String nama,
  required double jumlah,
  Value<String?> keterangan,
  Value<DateTime> tanggal,
});
typedef $$PengeluaransTableUpdateCompanionBuilder = PengeluaransCompanion
    Function({
  Value<int> id,
  Value<String> nama,
  Value<double> jumlah,
  Value<String?> keterangan,
  Value<DateTime> tanggal,
});

class $$PengeluaransTableFilterComposer
    extends Composer<_$AppDatabase, $PengeluaransTable> {
  $$PengeluaransTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nama => $composableBuilder(
      column: $table.nama, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get jumlah => $composableBuilder(
      column: $table.jumlah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnFilters(column));
}

class $$PengeluaransTableOrderingComposer
    extends Composer<_$AppDatabase, $PengeluaransTable> {
  $$PengeluaransTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nama => $composableBuilder(
      column: $table.nama, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get jumlah => $composableBuilder(
      column: $table.jumlah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnOrderings(column));
}

class $$PengeluaransTableAnnotationComposer
    extends Composer<_$AppDatabase, $PengeluaransTable> {
  $$PengeluaransTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<double> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);
}

class $$PengeluaransTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PengeluaransTable,
    Pengeluaran,
    $$PengeluaransTableFilterComposer,
    $$PengeluaransTableOrderingComposer,
    $$PengeluaransTableAnnotationComposer,
    $$PengeluaransTableCreateCompanionBuilder,
    $$PengeluaransTableUpdateCompanionBuilder,
    (
      Pengeluaran,
      BaseReferences<_$AppDatabase, $PengeluaransTable, Pengeluaran>
    ),
    Pengeluaran,
    PrefetchHooks Function()> {
  $$PengeluaransTableTableManager(_$AppDatabase db, $PengeluaransTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PengeluaransTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PengeluaransTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PengeluaransTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nama = const Value.absent(),
            Value<double> jumlah = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<DateTime> tanggal = const Value.absent(),
          }) =>
              PengeluaransCompanion(
            id: id,
            nama: nama,
            jumlah: jumlah,
            keterangan: keterangan,
            tanggal: tanggal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nama,
            required double jumlah,
            Value<String?> keterangan = const Value.absent(),
            Value<DateTime> tanggal = const Value.absent(),
          }) =>
              PengeluaransCompanion.insert(
            id: id,
            nama: nama,
            jumlah: jumlah,
            keterangan: keterangan,
            tanggal: tanggal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PengeluaransTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PengeluaransTable,
    Pengeluaran,
    $$PengeluaransTableFilterComposer,
    $$PengeluaransTableOrderingComposer,
    $$PengeluaransTableAnnotationComposer,
    $$PengeluaransTableCreateCompanionBuilder,
    $$PengeluaransTableUpdateCompanionBuilder,
    (
      Pengeluaran,
      BaseReferences<_$AppDatabase, $PengeluaransTable, Pengeluaran>
    ),
    Pengeluaran,
    PrefetchHooks Function()>;
typedef $$KasirsTableCreateCompanionBuilder = KasirsCompanion Function({
  Value<int> id,
  required String nama,
  Value<String?> noHp,
  Value<String?> fotoPath,
  Value<String?> pin,
  Value<bool> isAktif,
});
typedef $$KasirsTableUpdateCompanionBuilder = KasirsCompanion Function({
  Value<int> id,
  Value<String> nama,
  Value<String?> noHp,
  Value<String?> fotoPath,
  Value<String?> pin,
  Value<bool> isAktif,
});

class $$KasirsTableFilterComposer
    extends Composer<_$AppDatabase, $KasirsTable> {
  $$KasirsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nama => $composableBuilder(
      column: $table.nama, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noHp => $composableBuilder(
      column: $table.noHp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAktif => $composableBuilder(
      column: $table.isAktif, builder: (column) => ColumnFilters(column));
}

class $$KasirsTableOrderingComposer
    extends Composer<_$AppDatabase, $KasirsTable> {
  $$KasirsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nama => $composableBuilder(
      column: $table.nama, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noHp => $composableBuilder(
      column: $table.noHp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAktif => $composableBuilder(
      column: $table.isAktif, builder: (column) => ColumnOrderings(column));
}

class $$KasirsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KasirsTable> {
  $$KasirsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get noHp =>
      $composableBuilder(column: $table.noHp, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<bool> get isAktif =>
      $composableBuilder(column: $table.isAktif, builder: (column) => column);
}

class $$KasirsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KasirsTable,
    Kasir,
    $$KasirsTableFilterComposer,
    $$KasirsTableOrderingComposer,
    $$KasirsTableAnnotationComposer,
    $$KasirsTableCreateCompanionBuilder,
    $$KasirsTableUpdateCompanionBuilder,
    (Kasir, BaseReferences<_$AppDatabase, $KasirsTable, Kasir>),
    Kasir,
    PrefetchHooks Function()> {
  $$KasirsTableTableManager(_$AppDatabase db, $KasirsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KasirsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KasirsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KasirsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nama = const Value.absent(),
            Value<String?> noHp = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<String?> pin = const Value.absent(),
            Value<bool> isAktif = const Value.absent(),
          }) =>
              KasirsCompanion(
            id: id,
            nama: nama,
            noHp: noHp,
            fotoPath: fotoPath,
            pin: pin,
            isAktif: isAktif,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nama,
            Value<String?> noHp = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<String?> pin = const Value.absent(),
            Value<bool> isAktif = const Value.absent(),
          }) =>
              KasirsCompanion.insert(
            id: id,
            nama: nama,
            noHp: noHp,
            fotoPath: fotoPath,
            pin: pin,
            isAktif: isAktif,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KasirsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KasirsTable,
    Kasir,
    $$KasirsTableFilterComposer,
    $$KasirsTableOrderingComposer,
    $$KasirsTableAnnotationComposer,
    $$KasirsTableCreateCompanionBuilder,
    $$KasirsTableUpdateCompanionBuilder,
    (Kasir, BaseReferences<_$AppDatabase, $KasirsTable, Kasir>),
    Kasir,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$PerfumesTableTableManager get perfumes =>
      $$PerfumesTableTableManager(_db, _db.perfumes);
  $$ServiceProcessesTableTableManager get serviceProcesses =>
      $$ServiceProcessesTableTableManager(_db, _db.serviceProcesses);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$ServiceTypesTableTableManager get serviceTypes =>
      $$ServiceTypesTableTableManager(_db, _db.serviceTypes);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
  $$PengeluaransTableTableManager get pengeluarans =>
      $$PengeluaransTableTableManager(_db, _db.pengeluarans);
  $$KasirsTableTableManager get kasirs =>
      $$KasirsTableTableManager(_db, _db.kasirs);
}
