#!/usr/bin/env php
<?php
/**
 * @package Modyllic
 * Ref: test.sql / test-2.sql
 */

require_once dirname(__FILE__)."/../test_environment.php";

plan( 2 );

$parser = new Modyllic_Parser();

$schema1_sql = <<< EOSQL
create table t1(id serial);

ALTER TABLE t1
ADD CONSTRAINT `fk-t1-id` FOREIGN KEY (id)
REFERENCES t1 (id);

CREATE TABLE t2 (
  id serial,
  PRIMARY KEY (id)
) ENGINE = INNODB;

ALTER TABLE t2
ADD INDEX idx_barfoo (id);
EOSQL;

$schema2_sql = <<< EOSQL
create table t1(id serial);

ALTER TABLE t1
ADD CONSTRAINT `fk-t1-id` FOREIGN KEY (id)
REFERENCES t1 (id);

CREATE TABLE t2 (
  id serial,
  foo varchar(25),
  PRIMARY KEY (id)
) ENGINE = INNODB;

ALTER TABLE t2
ADD INDEX idx_barfoo (foo);
EOSQL;

$schema1 = $parser->parse($schema1_sql);
$schema2 = $parser->parse($schema2_sql);

$diff = new Modyllic_Diff($schema1,$schema2);

$changes = $diff->changeset();

is($changes->has_changes(), true, "Changing charset and collation changes schema" );
is(count($changes->schema->from->errors), 0, "Errors while parsing");
